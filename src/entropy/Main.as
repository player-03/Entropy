package entropy {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import org.flintparticles.twoD.actions.CollisionZone;
	import org.flintparticles.twoD.renderers.BitmapRenderer;
	import org.flintparticles.twoD.zones.BitmapDataZone;
	import org.flintparticles.twoD.zones.DiscZone;
	import org.flintparticles.twoD.zones.LineZone;
	import org.flintparticles.twoD.zones.MultiZone;
	
	[Frame(factoryClass="entropy.Preloader")]
	public class Main extends Sprite {
		public static const STAGE_WIDTH:int = 640;//describe stage hight and width
		public static const STAGE_HEIGHT:int = 480;
		
		private var renderer:BitmapRenderer;
		private var emitter:GasEmitter;//utilizing a single emitter for now with 
		
		private var player:Sprite;
		
		private var wallShape:Vector.<Point>;
		private var wallContainer:Sprite;
		
		[Embed(source="../../lib/img/Wall.png")]
		private var Wall:Class;//declare a class to hold the image
		private var wallImage:BitmapData;
		
		public function Main() {//starting function for program
			if(stage) init();//if the stage is up then init
			else addEventListener(Event.ADDED_TO_STAGE, init);//otherwise wait for the stage
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);//don't need to list for this anymore
			
			graphics.beginFill(0x000000);//choose black
			graphics.drawRect(0, 0, STAGE_WIDTH, STAGE_HEIGHT);//black out the stage
			graphics.endFill();//resolve
			
			player = new Player();
			addChild(player);

			wallImage = (new Wall() as Bitmap).bitmapData;//declare that the wall image is the bitmap data for the wall class
			
			wallContainer = new Sprite();//a display object that contains all wall hexagons
			wallShape = new Vector.<Point>(6);//define the wall by its points
			for(var i:int = 0; i < 6; i++) {
				wallShape[i] //not 100% sure what this does --tom
			}
			
			emitter = new GasEmitter();//declare the particle emitter we are using as an instance of the gas emitter
			renderer = new BitmapRenderer(new Rectangle(0, 0, STAGE_WIDTH, STAGE_HEIGHT));//overlay a flint renderer over the entire screen.
			renderer.addEmitter(emitter);//register the emitter with the flint renderer
			
			//add children in the order they should be drawn
			addChild(renderer);//add the renderer to the stage
			addChild(wallContainer);//add the display object containing all hexagons
			
			addWall(480, 240);
			addWall(612, 413);
			addWall(300, 20);
			addWall(240, 360);//4 hexagons
			emitter.emitFrom(600, new HexagonZone(STAGE_WIDTH / 2, STAGE_HEIGHT / 2, 100));//emit 100 particles from a 100 radius hexagon in the center
		}
		
		private function addWall(x:Number, y:Number):void {//later we can move this sort of thing to the hex grid class
			emitter.addAction(new CollisionZone(new HexagonZone(x, y, 23)));//build a hexagon at xy location with constant radius
			
			var wallBitmap:Bitmap = new Bitmap(wallImage);
			wallBitmap.x = x - wallImage.width / 2;//move the bitmap to the left side
			wallBitmap.y = y - wallImage.height / 2;//move the bitmap to the top.  the bitmap is now at the topleft of the object
			wallContainer.addChild(wallBitmap);//add the bitmap that shows the wall to the wallbitmap
		}
	}
}