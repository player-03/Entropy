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
			player = createAvatar(0xFFFF00);
			addChild(player);
			
			player.x = 300;
			player.y = 200;
			
			moveSounds = new moveSound() as Sound; 			     
			
			this.hex = hex;
			this.energyGauge = energyGauge;
		}
		
		private function addedToStageHandler(e:Event):void {
			this.stage.addEventListener(MouseEvent.CLICK, mousePressedDown);
		}
		
		private function mousePressedDown(event:MouseEvent):void {
			var clickedHex:HexTile = hex.getHexAtCoordinates(mouseX, mouseY);
			if(clickedHex == null) {
				return;
			}
			
			var playerHex:HexTile = hex.getHexAtCoordinates(player.x, player.y);
			
			var check:Vector.<HexTile>;
			check =	hex.getHexesAround(playerHex.column, playerHex.row);
			var canMove:Boolean = false;
			
			if(clickedHex == playerHex) {
				switch(clickedHex.type) {
					case HexTile.EXCAVATED:
						if(energyGauge.energyLevel >= 2) {
							energyGauge.energyLevel -= 2;
							clickedHex.type = HexTile.VALVE_OPEN;
						}
						break;
					case HexTile.VALVE_OPEN:
						clickedHex.type = HexTile.VALVE_CLOSED;
						break;
					case HexTile.VALVE_CLOSED:
						clickedHex.type = HexTile.VALVE_OPEN;
						break;
					case HexTile.TURBINE_BOTTOM_LEFT_TO_TOP_RIGHT:
						clickedHex.type = HexTile.TURBINE_TOP_LEFT_TO_BOTTOM_RIGHT;
						break;
					case HexTile.TURBINE_TOP_LEFT_TO_BOTTOM_RIGHT:
						clickedHex.type = HexTile.TURBINE_VERTICAL;
						break;
					case HexTile.TURBINE_VERTICAL:
						clickedHex.type = HexTile.TURBINE_BOTTOM_LEFT_TO_TOP_RIGHT;
						break;
				}
			} else if(check.indexOf(clickedHex) != -1) {
				switch(clickedHex.type) {
					case HexTile.FILLED:
						if(energyGauge.energyLevel >= 8) {
							energyGauge.energyLevel -= 8;
							clickedHex.type = HexTile.EXCAVATED;
						}
						break;
					case HexTile.VALVE_CLOSED:
						clickedHex.type = HexTile.VALVE_TEMPORARILY_OPEN;
						break;
					default:
				}
			}
			
			//if the tile isn't in range, you can still move to it as long
			//as it's something you placed
			else if(clickedHex.type != HexTile.EXCAVATED
					&& clickedHex.type != HexTile.VALVE_OPEN
					&& clickedHex.type != HexTile.VALVE_CLOSED) {
				return;
			}
			
			if(!HexTile.typeIsSolid(clickedHex.type)) {
				player.x = HexGrid.columnToX(clickedHex.column);
				player.y = HexGrid.columnRowToY(clickedHex.column, clickedHex.row);
				moveSounds.play();
				
				if(playerHex.type == HexTile.VALVE_TEMPORARILY_OPEN) {
					playerHex.type = HexTile.VALVE_CLOSED;
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