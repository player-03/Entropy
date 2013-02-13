package entropy 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.ui.Keyboard;
	import entropy.HexGrid;
	import entropy.HexTile;
	import entropy.HexagonZone;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	
	
	public class Player extends Sprite
	{
		private var player:Sprite;
		
		public var energyGauge:EnergyGauge;
		
		public var hex:HexGrid;
		
		[Embed(source="../../lib/robotmove.mp3")]
		
		private var moveSound:Class;
		private var moveSounds:Sound;

		public function Player(hex:HexGrid, energyGauge:EnergyGauge) 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			
			mouseEnabled = false;
			mouseChildren = false;
			visible = true;
			player = createAvatar(0xFFFF00);
			addChild(player);
			
			player.x = 300;
			player.y = 200;
			
			this.hex = hex;
			this.energyGauge = energyGauge;
			
			
		}
		
		private function addedToStageHandler(e:Event):void {
			this.stage.addEventListener(MouseEvent.CLICK, mousePressedDown);
		}
		
		private function mousePressedDown(event:MouseEvent):void {
			moveSounds = (new moveSound) as Sound; 			     
			
			var clickedHex:HexTile = hex.getHexAtCoordinates(mouseX, mouseY);
			var playerHex:HexTile = hex.getHexAtCoordinates(player.x, player.y);
			
			var check:Vector.<HexTile> = new Vector.<HexTile>(6);	
			check =	hex.getHexesAround(playerHex.column, playerHex.row);
				
			if (clickedHex == check[0] || clickedHex == check[1] || clickedHex == check[2] || clickedHex == check[3] || clickedHex == check[4] || clickedHex == check[5]) {
			if (clickedHex != null) {
				//TODO: Move this to the player class.
				switch(clickedHex.type) {
					case HexTile.FILLED:
						if(energyGauge.energyLevel >= 12) {
							energyGauge.energyLevel -= 12;
							clickedHex.type = HexTile.EXCAVATED;
							player.x = mouseX;
							player.y = mouseY;
							moveSounds.play();
						}
						break;
					case HexTile.EXCAVATED:
						if(energyGauge.energyLevel >= 4) {
							energyGauge.energyLevel -= 4;
							clickedHex.type = HexTile.VALVE_CLOSED;
							player.x = mouseX;
							player.y = mouseY;
							moveSounds.play();
						}
						break;
					case HexTile.VALVE_OPEN:
						clickedHex.type = HexTile.VALVE_CLOSED;
						player.x = mouseX;
						player.y = mouseY;
						moveSounds.play();
						break;
					case HexTile.VALVE_CLOSED:
						clickedHex.type = HexTile.VALVE_OPEN;
						break;
					default:
				}
			}
			}
		}
		
		private function createAvatar(bgColor:uint):Sprite {
		  var s:Sprite = new Sprite();
		  s.graphics.beginFill(bgColor);
		  s.graphics.drawCircle(0, 0, 10);
		  s.graphics.endFill();
		  s.graphics.beginFill(0x000000);
		  s.graphics.endFill();
		  s.graphics.lineStyle(2, 0x000000, 100);
		  s.graphics.moveTo(-20,15);
			//this will define the start point of the curve
			//the first two numbers are your control point for the curve
			//the last two are the end point of the curve
		  return s;
		}
	}

}