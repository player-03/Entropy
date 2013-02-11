package entropy 
{
	import flash.display.Sprite;
	import fl.controls.Button;
	import fl.controls.Label;
	import fl.controls.TextInput;

	public class titleScreen extends Sprite
	{
		public static const tText:String = "AsteroidMiner";
		public static const lText:String = "load";
		public static const sText:String = "play";
		
		private var inString:String;
		private var sButton:Button;
		private var lButton:Button;
		private var inBox:TextInput;
		
		public function titleScreen() 
		{
			super();
			/*
				var cButton:Button = new Button();
				var tf1:TextFormat = new TextFormat(); 
				//tf.color = 0x00FF00; 
				//tf.font = "Georgia"; 
				tf1.size = 26;
				var tf2:TextFormat = new TextFormat();//lol tf2
				tf2.size = 12;
				//myCh.setStyle("textFormat", tf); 
				//myRb.setStyle("textFormat", myCh.getStyle("textFormat"));
				cButton.width = 200;
				cButton.height = 80;
				cButton.x = 20;
				cButton.y = 50;
				cButton.setStyle("textFormat", tf1);
				cButton.label = "start";//remember to switch button style to small.
				cButton.addEventListener(MouseEvent.CLICK, startMovieWButton);
				var cButton2:Button = new Button();
				cButton2.height = 30;
				cButton2.width = 185;
				cButton2.x = 35;
				cButton2.y = 110;
				cButton2.setStyle("textFormat", tf2);
				cButton2.label = "forwards?";
				cButton2.addEventListener(MouseEvent.CLICK, nextColor);
				var tField1:TextInput = new TextInput();
				tField1.maxChars=3;//only need up to 3 very max
				//tField1.multiline = false;
				//tField1.selectable = true;
				tField1.text = "1";//start at one
				tField1.height = 30;
				tField1.width = 60;
				tField1.x = 35;
				tField1.y = 135;
				ControlLayer.addChild(cButton);//don't add the second yet
				ControlLayer.addChild(tField1);
				//finalize by adding layers to stage
				stage.addChild(SpriteLayer);
				stage.addChild(ControlLayer);
				stop();
			*/
			inString = null
			sButton = null;
			lButton = null;
			inString = "";
		}
		
	}

}