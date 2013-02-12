package entropy 
{
	import flash.display.Sprite;
	import fl.controls.Button;
	import fl.controls.Label;
	import fl.controls.TextInput;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.FileReference;

	//class written with guidance from http://www.adobe.com/devnet/flash/quickstart/filereference_class_as3.html
	
	
	public class titleScreen extends Sprite
	{
		
//---------------------------------------------------------------------------------------------------------
//public properties
		public static const tText:String = "AsteroidMiner";
		public static const lbText:String = "load";
		public static const sbText:String = "play";
		public static const lsText:String = "LOADING";
//private properties
		private var m_inString:String;
		private var m_sButton:Button;
		private var m_lButton:Button;
		//private var m_inBox:TextInput;
		private var m_ref:FileReference;
		private var m_loadLabel:Label;
		private var m_titleLabel:Label;
		
//--------------------------------------------------------------------------------------------------------------
	//public functions
	
	//constructor

		public function titleScreen(fRef:FileReference) 
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
			//m_inBox = new TextInput();
			m_sButton = new Button();
			m_sButton.label = sbText;
			m_lButton = new Button();
			m_lButton.label = lbText;
			m_inString = "";
			//m_inBox.text = m_inString;
			m_titleLabel = new Label();
			m_titleLabel.text = tText;
			
			//set up in view
			m_titleLabel.x = 0;
			m_titleLabel.y = 0;
			this.addChild(m_titleLabel);
			m_sButton.x = 0;
			m_sButton.y = 2 + m_titleLabel.y + m_titleLabel.height;
			this.addChild(m_sButton);
			m_lButton.x = 0;
			m_lButton.y = 2 + m_sButton.y + m_sButton.height;
			this.addChild(m_lButton);
			//m_inBox.x = 0;
			//m_inBox.y = 2 + m_lButton
			//this.addChild(m_inBox);
			
			//set your events
			m_lButton.addEventListener(MouseEvent.CLICK, selFile);
			m_sButton.addEventListener(MouseEvent.CLICK, startGame);
			
		}
	
	//getters and setters
	
		public function get inString():String
		{
			return this.m_inString;
		}
		
		public function set inString(value:String):void
		{
			this.m_inString = value;
		}
		
		public function get reference():FileReference
		{
			return this.m_ref;
		}

		
//----------------------------------------------------------------------------------------------
	//private functions
	
	//event handlers
		private function startGame(e:Event):void
		{
			
		}
		
		private function selFile(e:Event):void
		{
			m_sButton.removeEventListener(MouseEvent.CLICK, startGame);
			m_lButton.removeEventListener(MouseEvent.CLICK, selFile);
			//m_inBox.editable = false;
			
			m_ref.addEventListener(Event.SELECT, selectedHandler);
			m_ref.addEventListener(Event.CANCEL, browseCanceledHandler);
			
			m_ref.browse();
		}
		
		private function browseCanceledHandler(e:Event):void
		{
			m_sButton.addEventListener(MouseEvent.CLICK, startGame);
			m_lButton.addEventListener(MouseEvent.CLICK, selFile);
			//m_inBox.editable = true;
		}
		
		private function selectedHandler(e:Event):void
		{
			m_ref.removeEventListener(Event.SELECT, selFile);
			m_ref.removeEventListener(Event.CANCEL, browseCanceledHandler);
			m_ref.addEventListener(Event.COMPLETE, loadedHandler);
			m_ref.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
		}
		
		private function loadedHandler(e:Event):void
		{
			stage.removeChild(this);//now we move on to the thing
		}
		
		private function errorHandler(e:IOErrorEvent):void
		{
			trace("error loading file");
			
			m_ref.removeEventListener(Event.COMPLETE, loadedHandler);
			m_ref.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			
			m_lButton.addEventListener(MouseEvent.CLICK, selFile);
			m_sButton.addEventListener(MouseEvent.CLICK, startGame);
			
		}
		
		
		
		
	}

}