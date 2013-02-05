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
		private var GasParticle:Class;
		
		private var blast:Blast;
		private var position:Position;
		
		public function GasEmitter() {
			super();
			
			blast = new Blast();
			counter = blast;
			
			var image:Bitmap = new GasParticle() as Bitmap;
			image.scaleX = image.scaleY = 0.4;
			image.x = -image.width / 2;
			image.y = -image.height / 2;
			var imageContainer:Sprite = new Sprite();
			imageContainer.addChild(image);
			
			position = new Position();
			
			addInitializer(position);
			addInitializer(new SharedImage(imageContainer));
			addInitializer(new Velocity(new DiscZone(null, 40, 40)));
			addInitializer(new CollisionRadiusInit(4));
			
			addAction(new Move());
			addAction(new Collide());
			addAction(new GravityWell(50, Main.STAGE_WIDTH / 2, Main.STAGE_HEIGHT / 2, 300));
			
			//this will remove particles that go too far offscreen
			addAction(new DeathZone(new RectangleZone(-OFFSCREEN_LEEWAY, -OFFSCREEN_LEEWAY,
								Main.STAGE_WIDTH + 2 * OFFSCREEN_LEEWAY,
								Main.STAGE_HEIGHT + 2 * OFFSCREEN_LEEWAY), true));
			
			//this will prevent particles from leaving the screen
			//addAction(new CollisionZone(new RectangleZone(0, 0,
			//					Main.STAGE_WIDTH, Main.STAGE_HEIGHT)));
		}
		
		public function emitFrom(count:uint, zone:Zone2D):void {
			blast.startCount = count;
			position.zone = zone;
			start();
		}
	}
}