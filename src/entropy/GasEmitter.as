package entropy {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import org.flintparticles.common.counters.Blast;
	import org.flintparticles.common.initializers.CollisionRadiusInit;
	import org.flintparticles.common.initializers.SharedImage;
	import org.flintparticles.twoD.actions.Collide;
	import org.flintparticles.twoD.actions.CollisionZone;
	import org.flintparticles.twoD.actions.DeathZone;
	import org.flintparticles.twoD.actions.Move;
	import org.flintparticles.twoD.emitters.Emitter2D;
	import org.flintparticles.twoD.initializers.Position;
	import org.flintparticles.twoD.initializers.Velocity;
	import org.flintparticles.twoD.zones.DiscZone;
	import org.flintparticles.twoD.zones.RectangleZone;
	import org.flintparticles.twoD.zones.Zone2D;
	
	public class GasEmitter extends Emitter2D {
		[Embed(source="../../lib/img/GasParticle.png")]
		private var GasParticleClass:Class;
		
		private var blast:Blast;
		private var position:Position;
		
		public function GasEmitter() {
			super();
			
			blast = new Blast();
			counter = blast;
			
			var image:Bitmap = new GasParticleClass() as Bitmap;
			image.x = -image.width / 2;
			image.y = -image.height / 2;
			var imageContainer:Sprite = new Sprite();
			imageContainer.addChild(image);
			
			position = new Position();
			
			addInitializer(position);
			addInitializer(new SharedImage(imageContainer));
			addInitializer(new Velocity(new DiscZone(null, 40, 40)));
			addInitializer(new CollisionRadiusInit(10));
			
			addAction(new Move());
			addAction(new Collide());
			addAction(new DeathZone(new RectangleZone(0, 0,
								Main.STAGE_WIDTH, Main.STAGE_HEIGHT), true));
			addAction(new CollisionZone(new RectangleZone(0, 0,
								Main.STAGE_WIDTH, Main.STAGE_HEIGHT)));
		}
		
		public function emitFrom(count:uint, zone:Zone2D):void {
			blast.startCount = count;
			position.zone = zone;
			start();
		}
	}
}