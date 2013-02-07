package entropy {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	/**
	 * Data relating to a single tile in the hex grid.
	 */
	public class HexTile extends Bitmap {
		/**
		 * The distance from the left vertex to the right vertex of the tile.
		 */
		public static const TILE_WIDTH:int = 46;
		
		/**
		 * The difference between x values of each column of tiles. This
		 * differs from TILE_WIDTH because the columns overlap.
		 */
		public static const TILE_X_OFFSET:Number = TILE_WIDTH * 0.75;
		
		/**
		 * The distance from the top edge to the bottom edge of the tile.
		 * Equals the difference between y values of tiles directly above
		 * and below one another.
		 */
		public static const TILE_HEIGHT:int = 41;
		
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
		private static var emptyBitmapData:BitmapData;
		
		private static function checkData(data:BitmapData):void {
			if(data.width != TILE_WIDTH
					|| data.height != TILE_HEIGHT) {
				throw new Error("TILE_WIDTH and TILE_HEIGHT are not up to date!\n"
							+ "TILE_WIDTH is " + TILE_WIDTH + " and TILE_HEIGHT is " + TILE_HEIGHT
							+ ", but they should be " + data.width + " and " + data.height + ".");
			}
		}
		
		private static function getBitmapData(type:uint):BitmapData {
			switch(type) {
				case FILLED:
					if(filledBitmapData == null) {
						filledBitmapData = ((Bitmap) (new Filled())).bitmapData;
						checkData(filledBitmapData);
					}
					return filledBitmapData;
				case SPACE:
				default:
					return null;
			}
		}
		
		public static function typeCollides(type:uint):Boolean {
			return type == FILLED || type == VALVE_CLOSED;
		}
		
		private var mType:uint;
		private var collisionZone:HexagonZone;
		
		public function HexTile(type:uint, x:Number, y:Number) {
			super(getBitmapData(type));
			visible = bitmapData != null;
			
			this.x = x - TILE_WIDTH / 2;
			this.y = y - TILE_HEIGHT / 2;
			
			mType = type;
			
			//collision data may be necessary for any tile type except
			//space, so create the zone now
			if(mType != SPACE) {
				collisionZone = new HexagonZone(x, y, TILE_WIDTH / 2);
				collisionZone.collisionEnabled = typeCollides(mType);
			}
		}
		
		public function get type():uint {
			return mType;
		}
		
		public function set type(value:uint):void {
			//you cannot change space tiles
			if(mType == SPACE) {
				return;
			}
			
			mType = value;
			bitmapData = getBitmapData(mType);
			visible = bitmapData != null;
			
			if(collisionZone != null) {
				collisionZone.collisionEnabled = typeCollides(mType);
			}
		}
		
		public function getCollisionZone():HexagonZone {
			return collisionZone;
		}
	}
}