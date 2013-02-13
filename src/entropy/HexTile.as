package entropy {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Point;
	import org.flintparticles.common.actions.Action;
	import org.flintparticles.twoD.actions.CollisionZone;
	import org.flintparticles.twoD.actions.ZonedAction;
	import org.flintparticles.twoD.zones.DiscZone;
	
	/**
	 * Data relating to a single tile in the hex grid.
	 */
	public class HexTile extends Bitmap {
		/**
		 * The distance from the left vertex to the right vertex of the tile.
		 */
		public static const TILE_WIDTH:int = 36;
		
		/**
		 * The difference between x values of each column of tiles. This
		 * differs from TILE_WIDTH because the columns overlap.
		 */
		public static const TILE_X_OFFSET:Number = TILE_WIDTH * 0.75;
		
		/**
		 * The amount by which the tiles overlap.
		 */
		public static const TILE_X_OVERLAP:Number = TILE_WIDTH * 0.25;
		
		/**
		 * The distance from the top edge to the bottom edge of the tile.
		 * Equals the difference between y values of tiles directly above
		 * and below one another.
		 */
		public static const TILE_HEIGHT:int = 31;
		
		/**
		 * Represents a space outside the asteroid. Nothing can be placed
		 * here.
		 */
		public static const SPACE:uint = 0;
		
		/**
		 * Represents a space filled with dirt/rock. Blocks gas, but can
		 * be dug out.
		 */
		public static const FILLED:uint = 1;
		
		/**
		 * A space within the asteroid that has been dug out. Valves and
		 * turbines can be placed here.
		 */
		public static const EXCAVATED:uint = 2;
		
		/**
		 * A deposit of gas. Spawns gas particles when a space next to it
		 * is dug out, then becomes type EXCAVATED.
		 */
		public static const GAS_DEPOSIT:uint = 3;
		
		/**
		 * A temporary wall that blocks the passage of gas. Can be opened
		 * by the player.
		 */
		public static const VALVE_CLOSED:uint = 4;
		
		/**
		 * Blocks nothing while open, but can be closed by the player.
		 */
		public static const VALVE_OPEN:uint = 5;
		
		/**
		 * Collects energy when gas particles pass through in the same
		 * direction. Slows, but does not block, the particles as it does.
		 */
		public static const TURBINE_VERTICAL:uint = 6;
		public static const TURBINE_BOTTOM_LEFT_TO_TOP_RIGHT:uint = 7;
		public static const TURBINE_TOP_LEFT_TO_BOTTOM_RIGHT:uint = 8;
		
		[Embed(source="../../lib/img/Wall.png")]
		private static var Filled:Class;
		private static var filledBitmapData:BitmapData;
		
		[Embed(source="../../lib/img/ValveClosed.png")]
		private static var ValveClosed:Class;
		private static var valveClosedBitmapData:BitmapData;
		[Embed(source="../../lib/img/ValveOpen.png")]
		private static var ValveOpen:Class;
		private static var valveOpenBitmapData:BitmapData;
		
		[Embed(source="../../lib/img/Turbine1.png")]
		private static var Turbine1:Class;
		private static var turbine1BitmapData:BitmapData;
		[Embed(source="../../lib/img/Turbine2.png")]
		private static var Turbine2:Class;
		private static var turbine2BitmapData:BitmapData;
		[Embed(source="../../lib/img/Turbine3.png")]
		private static var Turbine3:Class;
		private static var turbine3BitmapData:BitmapData;
		
		private static var emptyBitmapData:BitmapData;
		
		private static function getBitmapData(type:uint):BitmapData {
			switch(type) {
				case FILLED:
					if(filledBitmapData == null) {
						filledBitmapData = ((Bitmap) (new Filled())).bitmapData;
					}
					return filledBitmapData;
				case VALVE_CLOSED:
					if(valveClosedBitmapData == null) {
						valveClosedBitmapData = ((Bitmap) (new ValveClosed())).bitmapData;
					}
					return valveClosedBitmapData;
				case VALVE_OPEN:
					if(valveOpenBitmapData == null) {
						valveOpenBitmapData = ((Bitmap) (new ValveOpen())).bitmapData;
					}
					return valveOpenBitmapData;
				case TURBINE_BOTTOM_LEFT_TO_TOP_RIGHT:
					if(turbine1BitmapData == null) {
						turbine1BitmapData = ((Bitmap) (new Turbine1())).bitmapData;
					}
					return turbine1BitmapData;
				case TURBINE_TOP_LEFT_TO_BOTTOM_RIGHT:
					if(turbine2BitmapData == null) {
						turbine2BitmapData = ((Bitmap) (new Turbine2())).bitmapData;
					}
					return turbine2BitmapData;
				case TURBINE_VERTICAL:
					if(turbine3BitmapData == null) {
						turbine3BitmapData = ((Bitmap) (new Turbine3())).bitmapData;
					}
					return turbine3BitmapData;
				case SPACE:
				default:
					return null;
			}
		}
		
		public static function typeIsSolid(type:uint):Boolean {
			return type == FILLED || type == VALVE_CLOSED;
		}
		public static function typeIsTurbine(type:uint):Boolean {
			return type == TURBINE_BOTTOM_LEFT_TO_TOP_RIGHT
				|| type == TURBINE_TOP_LEFT_TO_BOTTOM_RIGHT
				|| type == TURBINE_VERTICAL;
		}
		
		///////////////////////////////////////////////////////////////////////////
		
		private var mGrid:HexGrid;
		private var mEmitter:GasEmitter;
		
		private var mColumn:int;
		private var mRow:int;
		
		private var mType:uint;
		private var collisionZone:CollisionZone;
		private var turbineAction:Action;
		
		public function HexTile(grid:HexGrid, emitter:GasEmitter, type:uint,
								column:int, row:int) {
			super(getBitmapData(type));
			
			mGrid = grid;
			mEmitter = emitter;
			mColumn = column;
			mRow = row;
			
			setTypeWithoutSideEffects(type);
			
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			if(mType == GAS_DEPOSIT) {
				for each(var h:HexTile in mGrid.getHexesAround(column, row)) {
					if(h != null) {
						//all tiles around a gas deposit must start filled
						if(h.type != FILLED) {
							h.setTypeWithoutSideEffects(FILLED);
						}
						
						//gas deposits need to listen for nearby changes
						h.addEventListener(Event.CHANGE, onNearbyChange);
					}
				}
			}
		}
		
		private function onNearbyChange(e:Event):void {
			var target:HexTile = e.target as HexTile;
			
			if(mType != GAS_DEPOSIT) {
				target.removeEventListener(Event.CHANGE, onNearbyChange);
			} else if(!typeIsSolid(target.mType)) {
				target.removeEventListener(Event.CHANGE, onNearbyChange);
				type = EXCAVATED;
			}
		}
		
		public function get column():int {
			return mColumn;
		}
		public function get row():int {
			return mRow;
		}
		
		public function get type():uint {
			return mType;
		}
		
		public function set type(value:uint):void {
			//you cannot change space tiles
			if(mType == SPACE) {
				return;
			}
			
			//you cannot add gas pockets after starting the level
			if(value == GAS_DEPOSIT) {
				return;
			}
			
			//if this is a gas pocket, spawn the particles
			if(mType == GAS_DEPOSIT) {
				mEmitter.emitFrom(100, new HexagonZone(HexGrid.columnToX(column),
													HexGrid.columnRowToY(column, row),
													TILE_WIDTH / 2 - 2));
			}
			
			setTypeWithoutSideEffects(value);
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * For use only while setting up the level.
		 */
		private function setTypeWithoutSideEffects(type:uint):void {
			mType = type;
			bitmapData = getBitmapData(mType);
			onUpdateBitmapData();
			
			if(turbineAction != null) {
				mEmitter.removeAction(turbineAction);
				turbineAction = null;
			}
			
			//add or rebuild a hexagon collision zone for solid tile types
			if(typeIsSolid(mType)) {
				if(collisionZone != null) {
					mEmitter.removeAction(collisionZone);
				}
				
				collisionZone = new CollisionZone( 
								new HexagonZone(HexGrid.columnToX(column),
												HexGrid.columnRowToY(column, row),
												TILE_WIDTH / 2 - 2));
				mEmitter.addAction(collisionZone);
			}
			
			//add a custom collision zone and a custom friction action
			//for turbine tiles
			else if(typeIsTurbine(mType)) {
				if(collisionZone != null) {
					mEmitter.removeAction(collisionZone);
				}
				
				collisionZone = new CollisionZone(
								new TurbineWalls(HexGrid.columnToX(column),
												HexGrid.columnRowToY(column, row),
												TILE_WIDTH / 2 - 2,
												type));
				mEmitter.addAction(collisionZone);
				
				var dir:Point = new Point();
				if(mType == TURBINE_VERTICAL) {
					dir.y = 1;
				} else if(mType == TURBINE_BOTTOM_LEFT_TO_TOP_RIGHT) {
					dir.x = HexagonZone.SQRT_3_2;
					dir.y = 0.5;
				} else {
					dir.x = HexagonZone.SQRT_3_2;
					dir.y = -0.5;
				}
				
				turbineAction = new ZonedAction(
								new TurbineCollider(dir, mGrid.energyGauge.addEnergy),
								new DiscZone(new Point(HexGrid.columnToX(column),
													HexGrid.columnRowToY(column, row)),
											TILE_WIDTH / 4));
				mEmitter.addAction(turbineAction);
			} else {
				if(collisionZone != null) {
					mEmitter.removeAction(collisionZone);
					collisionZone = null;
				}
			}
		}
		
		private function onUpdateBitmapData():void {
			visible = bitmapData != null;
			
			if(visible) {
				x = HexGrid.columnToX(column) - bitmapData.width / 2;
				y = HexGrid.columnRowToY(column, row) - bitmapData.height / 2;
			}
		}
	}
}