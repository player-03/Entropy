package entropy {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.net.FileReference;
	import org.flintparticles.twoD.renderers.BitmapRenderer;
	
	
	//this project leverages the flint particle system, which can be found at http://flintparticles.org/
	//fl package of button components was provided through http://evolve.reintroducing.com/2007/10/30/tips-n-tricks/fl-package-swc/ by Matt Przybylski
	
	[Frame(factoryClass="entropy.Preloader")]
	public class Main extends Sprite {
		/**
		 * The default stage width, and the value that should be used as
		 * the stage width even when the window scales.
		 */
		public static const STAGE_WIDTH:int = 640;
		
		/**
		 * See STAGE_WIDTH.
		 */
		public static const STAGE_HEIGHT:int = 480;
		
		/**
		 * Defines whether loading a level or generating a random one
		 */
		public static const LOAD_LEVEL:uint = 0;
		/**
		 * Defines whether loading a level or generating a random one
		 */
		public static const RAND_LEVEL:uint = 1;
		
		/**
		 * The renderer manages and renders the particle system.
		 */
		private var renderer:BitmapRenderer;
		
		/**
		 * Currently the only emitter, because using multiple emitters
		 * would require registering the same collision data with each
		 * emitter.
		 */
		private var emitter:GasEmitter;
		
		/**
		 * A "container" display object is intended to hold multiple objects
		 * of the same type, so that they all get drawn as a group.
		 */
		private var grid:HexGrid;
		private var reader:LevelReader;
		private var title:titleScreen;
		
		public function Main() {
			//autogenerated
			//call init() once this has a reference to the stage
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void {
			//also autogenerated; the "entry point" is directly after this line
			removeEventListener(Event.ADDED_TO_STAGE, init);

			initTitle();
		}
	
		
		private function initMap(type:uint):void {
			
			//draw a black rectangle behind the stage
			graphics.beginFill(0x000000);
			graphics.drawRect(0, 0, STAGE_WIDTH, STAGE_HEIGHT);
			graphics.endFill();
			
			emitter = new GasEmitter();
			renderer = new BitmapRenderer(new Rectangle(0, 0, STAGE_WIDTH, STAGE_HEIGHT));
			renderer.addEmitter(emitter);
			
			//now we determine what to do if load
			if(type == LOAD_LEVEL)
			{
				var loadedData:Vector.<Vector.<HexTile>> = null;
				reader = new LevelReader(title.reference);
				loadedData = reader.fileToVector();
				
				grid = new HexGrid(emitter, 25, 15, -1, loadedData);
			}
			else
			{
				grid = new HexGrid(emitter, 25, 15);
			}
			
			//add children in the order they should be drawn
			addChild(renderer);
			addChild(grid);
		}
		
		private function initTitle():void
		{
			graphics.beginFill(0x000000);
			graphics.drawRect(0, 0, STAGE_WIDTH, STAGE_HEIGHT);
			graphics.endFill();
			title = new titleScreen(new FileReference());
			//title.addEventListener(Event.REMOVED_FROM_STAGE, f_Loaded);//what to do when title leaves
			stage.addEventListener(Event.COMPLETE, f_Loaded);
			stage.addEventListener(Event.CANCEL, f_random);//risky
			addChild(title);
		}
		
		private function f_Loaded(e:Event):void
		{
			removeChild(title);
			initMap(LOAD_LEVEL);
		}
		
		private function f_random(e:Event):void
		{
			removeChild(title);
			initMap(RAND_LEVEL);
		}
		
		
		
	}
}