package entropy {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.PixelSnapping;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.utils.getDefinitionByName;
	
	public class Preloader extends MovieClip {
		private var bitmapData:BitmapData;
		private var bitmap:Bitmap;
		private var cutoffInData:int = 0;
		private var prevCutoff:int = 0;
		
		public function Preloader() {
			if(stage) {
				stage.scaleMode = StageScaleMode.SHOW_ALL;//NO_SCALE;
				//stage.align = StageAlign.TOP_LEFT;
			}
			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			bitmapData = new BitmapData(Main.STAGE_WIDTH / 2, Main.STAGE_HEIGHT / 2, false, 0x808080);
			bitmap = new Bitmap(bitmapData, PixelSnapping.ALWAYS);
			bitmap.scaleX = bitmap.scaleY = 2;
			addChild(bitmap);
		}
		
		private function ioError(e:IOErrorEvent):void {
			trace(e.text);
		}
		
		private function progress(e:ProgressEvent):void {
			cutoffInData = int(e.bytesLoaded / e.bytesTotal * bitmapData.width);
		}
		
		private function checkFrame(e:Event):void {
			if(currentFrame == totalFrames) {
				stop();
				loadingFinished();
			} else {
				bitmapData.lock();
				var i:int, j:int;
				for(i = cutoffInData - 1; i >= prevCutoff; i--) {
					for(j = bitmapData.height - 1; j >= 0; j--) {
						bitmapData.setPixel(i, j, Math.random() > 0.5 ? 0xFFFFFF : 0x000000);
					}
				}
				prevCutoff = cutoffInData;
				bitmapData.unlock();
			}
		}
		
		private function loadingFinished():void {
			removeEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			removeChild(bitmap);
			bitmapData.dispose();
			
			startup();
		}
		
		private function startup():void {
			var mainClass:Class = getDefinitionByName("entropy.Main") as Class;
			addChild(new mainClass() as DisplayObject);
		}
	}
}