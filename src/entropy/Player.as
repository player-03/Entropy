package entropy 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	
	public class Player extends Sprite
	{
		private var player:Sprite;
		
		public function Player() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			player = createAvatar(0xFFFF00);
			player.x = 200;
			player.y = 100;
			addChild(player);
		}
		
		private function addedToStageHandler(e:Event):void {
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyPressedDown);
		}
		
		private function keyPressedDown(event:KeyboardEvent):void {
		  var key:uint = event.keyCode;
		  var step:uint = 5
		  switch (key) {
			  case Keyboard.LEFT :
				player.x -= step;
				break;
			  case Keyboard.RIGHT :
				player.x += step;
				break;
			  case Keyboard.UP :
				player.y -= step;
				break;
			  case Keyboard.DOWN :
				player.y += step;
				break;
		  }
		}
		
		private function createAvatar(bgColor:uint):Sprite {
		  var s:Sprite = new Sprite();
		  s.graphics.beginFill(bgColor);
		  s.graphics.drawCircle(0, 0, 40);
		  s.graphics.endFill();
		  s.graphics.beginFill(0x000000);
		  s.graphics.drawCircle(-15, -10, 5);
		  s.graphics.drawCircle(+15, -10, 5);
		  s.graphics.endFill();
		  s.graphics.lineStyle(2, 0x000000, 100);
		  s.graphics.moveTo(-20,15);
			//this will define the start point of the curve
		  s.graphics.curveTo(0,35, 20,15); 
			//the first two numbers are your control point for the curve
			//the last two are the end point of the curve
		  return s;
		}	
	}

}