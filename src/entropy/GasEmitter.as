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
	
	/**
	 * An emitter that emits gas particles in bursts and defines their
	 * subsequent behavior.
	 */
	public class GasEmitter extends Emitter2D {
		private static const OFFSCREEN_LEEWAY:Number = 100;
		
		[Embed(source="../../lib/img/GasParticle.png")]
		private var GasParticle:Class;
		
		/**
		 * A blast "timer" makes the emitter emit multiple particles
		 * immediately upon being started, and then not again.
		 */
		private var blast:Blast;
		
		/**
		 * An initializer that will make particles start from a specified
		 * area. A reference to this is kept so that the starting area
		 * can be modified.
		 */
		private var position:Position;
		
		public function GasEmitter() {
			super();
			
			blast = new Blast();
			counter = blast;
			
			var image:Bitmap = new GasParticle() as Bitmap;
			
			//center the image
			image.x = -image.width / 2;
			image.y = -image.height / 2;
			
			//put the image in a container, or it won't appear centered
			var imageContainer:Sprite = new Sprite();
			imageContainer.addChild(image);
			addInitializer(new SharedImage(imageContainer));
			
			position = new Position();
			addInitializer(position);
			
			//the velocity initializer gets a random point in the given
			//zone and uses that point as a velocity; a disc zone defines
			//a "donut" with a minimum and maximum radius - in this case,
			//both are 40, so the particles will always start with speed 40
			addInitializer(new Velocity(new DiscZone(null, 40, 40)));
			
			//make the particles collide, with a small radius
			addInitializer(new CollisionRadiusInit(2));
			
			//actions update the particles each frame; without these, the
			//particles wouldn't do anything
			addAction(new Move());
			addAction(new Collide());
			
			//add gravity
			addAction(new GravityWell(10, Main.STAGE_WIDTH / 2, Main.STAGE_HEIGHT / 2, 300));
			
			//remove particles that go too far offscreen
			addAction(new DeathZone(new RectangleZone(-OFFSCREEN_LEEWAY, -OFFSCREEN_LEEWAY,
								Main.STAGE_WIDTH + 2 * OFFSCREEN_LEEWAY,
								Main.STAGE_HEIGHT + 2 * OFFSCREEN_LEEWAY), true));
			
			//prevent particles from leaving the screen in the first place
			//addAction(new CollisionZone(new RectangleZone(0, 0,
			//					Main.STAGE_WIDTH, Main.STAGE_HEIGHT)));
		}
		
		/**
		 * Spawns the given number of particles in the given region.
		 */
		public function emitFrom(count:uint, zone:Zone2D):void {
			blast.startCount = count;
			position.zone = zone;
			start();
		}
	}
}