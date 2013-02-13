package entropy 
{
	import flash.display.Sprite;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.net.FileFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	//class written with guidance from http://www.adobe.com/devnet/flash/quickstart/filereference_class_as3.html
	
	
	public class titleScreen extends Sprite
	{
		
//---------------------------------------------------------------------------------------------------------
//public properties
		public static const tText:String = "AsteroidMiner";
		public static const lbText:String = "Load";
		public static const sbText:String = "Play";
		public static const lsText:String = "LOADING";
//private properties
		private var m_sButton:Sprite;
		private var m_lButton:Sprite;
		private var m_ref:FileReference;
		private var m_titleLabel:TextField;
		
		private var loaded:Boolean = false;
		
//--------------------------------------------------------------------------------------------------------------
	//public functions
	
	//constructor

		public function titleScreen(fRef:FileReference) 
		{
			super();
			
			//guided by direction to use sprite with button functionality, built with assistance from http://www.blog.mpcreation.pl/making-a-simply-button-in-as3/
			m_sButton = new Sprite();
			m_sButton.buttonMode = true;
			m_sButton.mouseChildren = false;
			m_lButton = new Sprite();
			m_lButton.buttonMode = true;
			m_lButton.mouseChildren = false;
			//set colors
			//0xFFFF00 = yellow
			//0x00FFFF = cyan
			//0x00FF00 = green
			//0xFF0000 = red
			
			//title
			m_titleLabel = new TextField();
			m_titleLabel.defaultTextFormat = new TextFormat("Arial", 30, 0x00FF00, true, false, false, null, null, TextFormatAlign.CENTER);
			m_titleLabel.text = tText;
			m_titleLabel.selectable = false;
			m_titleLabel.width = Main.STAGE_WIDTH; 
			m_titleLabel.height = m_titleLabel.textHeight + 2;
			this.addChild(m_titleLabel);
			
			m_ref = fRef;
			
			//play (random level) button
			var tempL1:TextField = new TextField();
			tempL1.defaultTextFormat = new TextFormat(null, 20, 0x00FF00, false, false, false, null, null, TextFormatAlign.CENTER);
			tempL1.text = sbText;
			tempL1.height = 50;
			m_sButton.graphics.beginFill(0xFF0000);
			m_sButton.graphics.drawRoundRect(0, 0, 100, 50, 5);
			m_sButton.graphics.endFill();
			m_sButton.addChild(tempL1);
			m_sButton.x = (Main.STAGE_WIDTH - m_sButton.width) / 2;
			m_sButton.y = Main.STAGE_HEIGHT * 2 / 5;
			this.addChild(m_sButton);
			
			//load (from file) button
			var tempL2:TextField = new TextField();
			tempL2.defaultTextFormat = tempL1.defaultTextFormat;
			tempL2.text = lbText;
			tempL2.height = 50;
			m_lButton.graphics.beginFill(0xFF0000);
			m_lButton.graphics.drawRoundRect(0, 0, 100, 50, 5);
			m_lButton.graphics.endFill();
			m_lButton.addChild(tempL2);
			m_lButton.x = (Main.STAGE_WIDTH - m_lButton.width) / 2;
			m_lButton.y = 2 + m_sButton.y + m_sButton.height;
			this.addChild(m_lButton);
			
			//set your events
			m_lButton.addEventListener(MouseEvent.CLICK, selFile);
			m_sButton.addEventListener(MouseEvent.CLICK, startGame);
			
		}
	
	//getters and setters
		
		public function get reference():FileReference
		{
			return this.m_ref;
		}
		
		public function get fileLoaded():Boolean
		{
			return loaded;
		}
		
//----------------------------------------------------------------------------------------------
	//private functions
	
	//event handlers
		private function startGame(e:Event):void
		{
			loaded = false;
			stage.dispatchEvent(new Event(Event.CANCEL, true, true));
		}
		
		private function selFile(e:Event):void
		{
			m_sButton.removeEventListener(MouseEvent.CLICK, startGame);
			m_lButton.removeEventListener(MouseEvent.CLICK, selFile);
			//m_inBox.editable = false;
			
			m_ref.addEventListener(Event.SELECT, selectedHandler);
			m_ref.addEventListener(Event.CANCEL, browseCanceledHandler);
			
			var fFilter:FileFilter = new FileFilter("Documents", "*.txt");
			//trace("selection start");
			m_ref.browse([fFilter]);
		}
		
		private function browseCanceledHandler(e:Event):void
		{
			//trace("browsing cancelled");
			m_sButton.addEventListener(MouseEvent.CLICK, startGame);
			m_lButton.addEventListener(MouseEvent.CLICK, selFile);
			//m_inBox.editable = true;
		}
		
		private function selectedHandler(e:Event):void
		{
			loaded = true;
			//trace("item selected")
			m_ref.removeEventListener(Event.SELECT, selFile);
			m_ref.removeEventListener(Event.CANCEL, browseCanceledHandler);
			m_ref.addEventListener(Event.COMPLETE, loadedHandler);
			m_ref.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			m_ref.load();
		}
		private function loadedHandler(e:Event):void
		{
			//trace("item loaded");
			//stage.removeChild(this);//now we move on to the thing
			stage.dispatchEvent(new Event(Event.COMPLETE, true, true));//must add event listener to stage first
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