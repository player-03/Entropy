package entropy {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.flintparticles.twoD.actions.CollisionZone;
	import org.flintparticles.twoD.renderers.BitmapRenderer;
	import org.flintparticles.twoD.zones.BitmapDataZone;
	import org.flintparticles.twoD.zones.DiscZone;
	import org.flintparticles.twoD.zones.LineZone;
	import org.flintparticles.twoD.zones.MultiZone;
	
	[Frame(factoryClass="entropy.Preloader")]
	public class Main extends Sprite {
		public static const STAGE_WIDTH:int = 640;
		public static const STAGE_HEIGHT:int = 480;
		
		private var renderer:BitmapRenderer;
		private var emitter:GasEmitter;
		
		private var wallShape:Vector.<Point>;
		private var wallContainer:Sprite;
		
		[Embed(source="../../lib/img/Wall.png")]
		private var Wall:Class;
		private var wallImage:BitmapData;
		
		public function Main() {
			if(stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			graphics.beginFill(0x000000);
			graphics.drawRect(0, 0, STAGE_WIDTH, STAGE_HEIGHT);
			graphics.endFill();
			
			wallImage = (new Wall() as Bitmap).bitmapData;
			
			wallContainer = new Sprite();
			wallShape = new Vector.<Point>(6);
			for(var i:int = 0; i < 6; i++) {
				wallShape[i] 
			}
			
			emitter = new GasEmitter();
			renderer = new BitmapRenderer(new Rectangle(0, 0, STAGE_WIDTH, STAGE_HEIGHT));
			renderer.addEmitter(emitter);
			
			//add children in the order they should be drawn
			addChild(renderer);
			addChild(wallContainer);
			
			addWall(480, 240);
			addWall(612, 413);
			addWall(300, 20);
			addWall(240, 360);
			emitter.emitFrom(600, new HexagonZone(STAGE_WIDTH / 2, STAGE_HEIGHT / 2, 100));
		}
		
		private function addWall(x:Number, y:Number):void {
			emitter.addAction(new CollisionZone(new HexagonZone(x, y, 23)));
			
			var wallBitmap:Bitmap = new Bitmap(wallImage);
			wallBitmap.x = x - wallImage.width / 2;
			wallBitmap.y = y - wallImage.height / 2;
			wallContainer.addChild(wallBitmap);
		}
	}
}