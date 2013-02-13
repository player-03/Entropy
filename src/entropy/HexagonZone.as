package entropy {
	import org.flintparticles.twoD.particles.Particle2D;
	import flash.geom.Point;
	import org.flintparticles.twoD.zones.LineZone;
	import org.flintparticles.twoD.zones.MultiZone;
	import org.flintparticles.twoD.zones.PointZone;
	import org.flintparticles.twoD.zones.Zone2D;
	
	public class HexagonZone extends MultiZone {
		public static const SQRT_3_2:Number = Math.sqrt(3) / 2;
		
		/**
		 * Points defining a hexagon with radius 1.
		 */
		private static const UNIT_HEXAGON_POINTS:Vector.<Point> = Vector.<Point>([
				new Point(1, 0), //right
				new Point(0.5, -SQRT_3_2), //upper right
				new Point(-0.5, -SQRT_3_2), //upper left
				new Point(-1, 0), //left
				new Point(-0.5, SQRT_3_2), //lower left
				new Point(0.5, SQRT_3_2)]); //lower right
		
		private var centerX:Number;
		private var centerY:Number;
		
		/**
		 * The distance from the center to a corner. Equals the length of
		 * each side.
		 */
		private var radius:Number;
		
		/**
		 * The distance from the center to the middle of a side. Also
		 * known as the "inradius."
		 */
		private var apothem:Number;
		
		/**
		 * @param	radius The distance from the center to a corner.
		 */
		public function HexagonZone(centerX:Number = 0, centerY:Number = 0, radius:Number = 0) {
			super();
			
			this.centerX = centerX;
			this.centerY = centerY;
			
			if(radius < 0) {
				throw new ArgumentError("Radius cannot be less than 0!");
			}
			
			this.radius = radius;
			apothem = radius * SQRT_3_2;
			
			var points:Vector.<Point> = new Vector.<Point>(6);
			var i:int;
			for(i = 0; i < 6; i++) {
				points[i] = UNIT_HEXAGON_POINTS[i].clone();
				points[i].x = points[i].x * radius + centerX;
				points[i].y = points[i].y * radius + centerY;
			}
			placeWalls(points);
		}
		
		protected function placeWalls(points:Vector.<Point>):void {
			var i:int;
			for(i = 0; i < 6; i++) {
				addZone(new LineZone(points[i], points[i == 5 ? 0 : i + 1]));
				
				//this may be necessary to keep particles from passing through
				addZone(new PointZone(points[i]));
			}
		}
		
		public override function contains(x:Number, y:Number):Boolean {
			var xDiff:Number = x - centerX;
			var yDiff:Number = y - centerY;
			if(xDiff * xDiff + yDiff * yDiff > radius * radius) {
				return false;
			}
			
			return super.contains(x, y);
		}
		
		public override function getLocation():Point {
			//based on http://stackoverflow.com/a/3241819/804200
			var i:int = int(Math.random() * 3) * 2;
			var v1:Point = UNIT_HEXAGON_POINTS[i];
			var v2:Point = UNIT_HEXAGON_POINTS[i >= 4 ? 0 : i + 2];
			
			var result:Point = new Point(Math.random(), Math.random());
			result.setTo(result.x * v1.x + result.y * v2.x,
						result.x * v1.y + result.y * v2.y);
			result.x = result.x * radius + centerX;
			result.y = result.y * radius + centerY;
			return result;
		}
		
		public override function getArea():Number {
			//The radius and apothem are the base and height, respectively,
			//of the triangles you get by splitting the hexagon into 6.
			//Therefore, multiplying them together gives you twice the
			//area of one-sixth of the hexagon.
			return radius * apothem * 3;
		}
		
		public override function collideParticle(particle:Particle2D, bounce:Number = 1):Boolean {
			var xDiff:Number = particle.x - centerX;
			var yDiff:Number = particle.y - centerY;
			
			var adjustedRadius:Number = radius + particle.collisionRadius
						//uncomment this if you notice particles passing through
						//* 2
						;
			adjustedRadius *= adjustedRadius;
			
			//if moving towards the center
			if(particle.velX * xDiff + particle.velY * yDiff < 0) {
				//if the particle is still well outside the boundary
				if(xDiff * xDiff + yDiff * yDiff > adjustedRadius) {
					return false;
				}
				
				//if the particle started fully inside the boundary
				//(this seems to let particles through at times)
				/*xDiff = particle.previousX - centerX;
				yDiff = particle.previousY - centerY;
				adjustedRadius = apothem - particle.collisionRadius;
				adjustedRadius *= adjustedRadius;
				if(xDiff * xDiff + xDiff * xDiff < adjustedRadius) {
					return false;
				}*/
			}
			
			//if moving away from the center
			else {
				//if the particle started fully outside the boundary
				xDiff = particle.previousX - centerX;
				yDiff = particle.previousY - centerY;
				if(xDiff * xDiff + yDiff * yDiff > adjustedRadius) {
					return false;
				}
				
				//if the particle is still fully inside the boundary
				//(this seems to let particles through at times)
				/*xDiff = particle.x - centerX;
				yDiff = particle.y - centerY;
				adjustedRadius = apothem - particle.collisionRadius;
				adjustedRadius *= adjustedRadius;
				if(xDiff * xDiff + yDiff * yDiff < adjustedRadius) {
					return false;
				}*/
			}
			
			//now that the particle is known to be close to the hexagon,
			//test it against the individual line segments and points
			return super.collideParticle(particle, bounce);
		}
	}
}