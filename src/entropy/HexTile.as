package entropy {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.twoD.actions.CollisionZone;
	
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
		public static const TURBINE:uint = 6;
		
		[Embed(source="../../lib/img/Wall.png")]
		private static var Filled:Class;
		private static var filledBitmapData:BitmapData;
		
		[Embed(source="../../lib/img/ValveClosed.png")]
		private static var ValveClosed:Class;
		private static var valveClosedBitmapData:BitmapData;
		
		[Embed(source="../../lib/img/Turbine.png")]
		private static var Turbine:Class;
		private static var turbineBitmapData:BitmapData;
		
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
				case TURBINE:
					if(turbineBitmapData == null) {
						turbineBitmapData = ((Bitmap) (new Turbine())).bitmapData;
					}
					return turbineBitmapData;
				case SPACE:
				default:
					return null;
			}
		}
		
		public static function typeCollides(type:uint):Boolean {
			return type == FILLED || type == VALVE_CLOSED;
		}
		
		///////////////////////////////////////////////////////////////////////////
		
		private var mGrid:HexGrid;
		private var mEmitter:GasEmitter;
		
		private var mColumn:int;
		private var mRow:int;
		
		private var mType:uint;
		private var collisionZone:HexagonZone;
		
		public function HexTile(grid:HexGrid, emitter:GasEmitter, type:uint,
								column:int, row:int) {
			super(getBitmapData(type));
			
			mGrid = grid;
			mEmitter = emitter;
			mColumn = column;
			mRow = row;
			
			onUpdateBitmapData();
			
			mType = type;
			
			//collision data may be necessary for any tile type except
			//space, so create the zone now
			if(mType != SPACE && emitter != null) {
				collisionZone = new HexagonZone(HexGrid.columnToX(column),
												HexGrid.columnRowToY(column, row),
												TILE_WIDTH / 2 - 2);
				collisionZone.collisionEnabled = typeCollides(mType);
				emitter.addAction(new CollisionZone(collisionZone));
			}
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			//gas deposits need to listen for nearby changes
			if(mType == GAS_DEPOSIT) {
				registerChangeListener(mGrid.getHexAbove(column, row));
				registerChangeListener(mGrid.getHexAboveLeft(column, row));
				registerChangeListener(mGrid.getHexBelowLeft(column, row));
				registerChangeListener(mGrid.getHexBelow(column, row));
				registerChangeListener(mGrid.getHexBelowRight(column, row));
				registerChangeListener(mGrid.getHexAboveRight(column, row));
			}
		}
		
		/**
		 * call this before adding the hex grid to the stage
		 */
		public function preInit(inGrid:HexGrid, inEmitter:GasEmitter):void
		{
			this.mGrid = inGrid;
			this.mEmitter = inEmitter;
			if (mType != SPACE)
			{
				collisionZone = new HexagonZone(HexGrid.columnToX(column),
													HexGrid.columnRowToY(column, row),
													TILE_WIDTH / 2 - 2);
				collisionZone.collisionEnabled = typeCollides(mType);
				inEmitter.addAction(new CollisionZone(collisionZone));
			}
		}
		
		
		
		
		
		
		private function registerChangeListener(h:HexTile):void {
			if(h != null) {
				h.addEventListener(Event.CHANGE, onNearbyChange);
			}
		}
		
		private function onNearbyChange(e:Event):void {
			var target:HexTile = e.target as HexTile;
			
			if(mType != GAS_DEPOSIT) {
				target.removeEventListener(Event.CHANGE, onNearbyChange);
			} else if(!typeCollides(target.mType)) {
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
				mEmitter.emitFrom(80, collisionZone);
			}
			
			mType = value;
			bitmapData = getBitmapData(mType);
			onUpdateBitmapData();
			
			collisionZone.collisionEnabled = typeCollides(mType);
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function onUpdateBitmapData():void {
			visible = bitmapData != null;
			
			if(visible) {
				x = HexGrid.columnToX(column) - bitmapData.width / 2;
				y = HexGrid.columnRowToY(column, row) - bitmapData.height / 2;
			}
		}
		
		public function getCollisionZone():HexagonZone {
			return collisionZone;
		}
	}
}