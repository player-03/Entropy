package entropy {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import org.flintparticles.common.counters.Blast;
	import org.flintparticles.common.initializers.CollisionRadiusInit;
	import org.flintparticles.common.initializers.SharedImage;
	import org.flintparticles.twoD.actions.Collide;
	import org.flintparticles.twoD.actions.CollisionZone;
	import org.flintparticles.twoD.actions.DeathZone;
	import org.flintparticles.twoD.actions.GravityWell;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.initializers.Position;
	import org.flintparticles.twoD.initializers.Velocity;
	import org.flintparticles.twoD.zones.DiscZone;
	import org.flintparticles.twoD.zones.RectangleZone;
	import org.flintparticles.twoD.zones.Zone2D;
	
	public class GasEmitter extends Emitter2D {
		private static const OFFSCREEN_LEEWAY:Number = 200;
		
		[Embed(source="../../lib/img/GasParticle.png")]
		private var GasParticle:Class;//declare a class to hold the image
		
		private var blast:Blast;
		private var position:Position;
		
		public function GasEmitter() {
			super();//call constructor of the object it extends
			blast = new Blast();
			counter = blast;
			
			var image:Bitmap = new GasParticle() as Bitmap;//the gas particle
			image.scaleX = image.scaleY = 0.4;
			image.x = -image.width / 2;
			image.y = -image.height / 2;
			var imageContainer:Sprite = new Sprite();
			imageContainer.addChild(image);//scale the image move its bitmap to the top left of the particle and add it to the display object that holds all
			//particle images
			
			position = new Position();
			
			addInitializer(position);
			addInitializer(new SharedImage(imageContainer));//all particle display objects share the image container?
			addInitializer(new Velocity(new DiscZone(null, 40, 40)));//tell the particles to travel at speed 40 per sec toward a random point on a circle
			//relative to 
			addInitializer(new CollisionRadiusInit(4));//there is a radius of 4 pixels around each particle that defines their collision bounding
			
			addAction(new Move());//tell the particles to move based on the velocity in the initializer
			addAction(new Collide());//tell the particles that they should collide with things based on thier initializer
			addAction(new GravityWell(50, Main.STAGE_WIDTH / 2, Main.STAGE_HEIGHT / 2, 300));//tells the particles to be attracted back toward the center
			
			//this will remove particles that go too far offscreen
			addAction(new DeathZone(new RectangleZone(-OFFSCREEN_LEEWAY, -OFFSCREEN_LEEWAY,
								Main.STAGE_WIDTH + 2 * OFFSCREEN_LEEWAY,
								Main.STAGE_HEIGHT + 2 * OFFSCREEN_LEEWAY), true));
			
			//this will prevent particles from leaving the screen
			//addAction(new CollisionZone(new RectangleZone(0, 0,
			//					Main.STAGE_WIDTH, Main.STAGE_HEIGHT)));
		}
		
		public function emitFrom(count:uint, zone:Zone2D):void {//burst emit at zone
			blast.startCount = count;
			position.zone = zone;
			start();
		}
	}
}