package entropy {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.twoD.renderers.BitmapRenderer;
	import org.flintparticles.twoD.zones.DiscZone;
	
	[Frame(factoryClass="entropy.Preloader")]
	public class Main extends Sprite {
		public static const STAGE_WIDTH:int = 640;
		public static const STAGE_HEIGHT:int = 480;
		
		private var renderer:BitmapRenderer;
		private var emitter:GasEmitter;
		
		public function Main():void {
			if(stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			graphics.beginFill(0x000000);
			graphics.drawRect(0, 0, STAGE_WIDTH, STAGE_HEIGHT);
			graphics.endFill();
			
			var emitter:GasEmitter = new GasEmitter();
			
			renderer = new BitmapRenderer(new Rectangle(0, 0, STAGE_WIDTH, STAGE_HEIGHT));
			renderer.addEmitter(emitter);
			addChild(renderer);
			
			emitter.emitFrom(60, new DiscZone(new Point(STAGE_WIDTH / 2, STAGE_HEIGHT / 2), 100));
		}
	}
}