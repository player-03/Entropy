package entropy {
	import org.flintparticles.twoD.particles.Particle2D;
	import flash.geom.Point;
	import org.flintparticles.twoD.zones.LineZone;
	import org.flintparticles.twoD.zones.MultiZone;
	import org.flintparticles.twoD.zones.PointZone;
	import org.flintparticles.twoD.zones.Zone2D;
	
	public class HexagonZone extends MultiZone {
		private static const SQRT_3_2:Number = Math.sqrt(3) / 2;
		private static const UNIT_HEXAGON_POINTS:Vector.<Point> = Vector.<Point>([
				new Point(1, 0),//default radius is 2 before scaling, this is middle point on the left
				new Point(0.5, SQRT_3_2),//lower right
				new Point(-0.5, SQRT_3_2),//lower left
				new Point(-1, 0),//left
				new Point(-0.5, -SQRT_3_2),//upperleft
				new Point(0.5, -SQRT_3_2)]);//upper right
		
		private var centerX:Number;
		private var centerY:Number;
		private var radius:Number;//the radius of a regular hexagon is the same length as one of its sides, explains area function
		private var apothem:Number; //aka. "inradius"
		
		/**
		 * @param	radius The distance from the center to any of the corners.
		 */
		public function HexagonZone(centerX:Number = 0, centerY:Number = 0, radius:Number = 0) {
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
				points[i].x = points[i].x * radius + centerX;//define the location of each point based on original definition, scaling, and 
				points[i].y = points[i].y * radius + centerY;
			}
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
			var i:int = int(Math.random() * 3) * 2;//randomly choose one of the 6 points
			var v1:Point = UNIT_HEXAGON_POINTS[i];
			var v2:Point = UNIT_HEXAGON_POINTS[i >= 4 ? i - 4 : i + 2];//choose a point 2 spaces away to select a rhombus out of the hexagon?
			
			var result:Point = new Point(Math.random(), Math.random());//random xy scaling factor less than 1
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
		
		public override function collideParticle(particle:Particle2D, bounce:Number = 1):Boolean {//collision code
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
			
			return super.collideParticle(particle, bounce);// i personally need to look more at this --tom
		}
	}
}