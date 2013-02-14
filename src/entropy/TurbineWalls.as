package entropy {
	import flash.geom.Point;
	import org.flintparticles.twoD.zones.LineZone;
	import org.flintparticles.twoD.zones.MultiZone;
	import org.flintparticles.twoD.zones.PointZone;
	
	/**
	 * @author player_03
	 */
	public class TurbineWalls extends HexagonZone {
		private var startPoint:int;
		
		public function TurbineWalls(centerX:Number = 0, centerY:Number = 0, radius:Number = 0,
								orientation:int = -1) {
			switch(orientation) {
				case HexTile.TURBINE_TOP_LEFT_TO_BOTTOM_RIGHT:
					startPoint = 0;
					break;
				case HexTile.TURBINE_BOTTOM_LEFT_TO_TOP_RIGHT:
					startPoint = 1;
					break;
				case HexTile.TURBINE_VERTICAL:
				default:
					startPoint = 2;
			}
			super(centerX, centerY, radius);
		}
		
		protected override function placeWalls(points:Vector.<Point>):void {
			var i:int, j:int;
			for(i = 0; i < 6; i++) {
				if(i == 2) {
					j = 0;
				} else if(i == 5) {
					j = 3;
				} else {
					j = i + 1;
				}
				addZone(new LineZone(points[(i + startPoint) % 6],
								points[(j + startPoint) % 6]));
				
				addZone(new PointZone(points[i]));
			}
		}
	}
}