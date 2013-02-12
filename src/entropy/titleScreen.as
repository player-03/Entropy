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
	import flash.net.FileFilter;

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
		//private var m_sButton:Button;
		//private var m_lButton:Button;
		private var m_sButton:Sprite;
		private var m_lButton:Sprite;
		private var m_ref:FileReference;
		private var m_loadLabel:Label;
		private var m_titleLabel:Label;
		
//--------------------------------------------------------------------------------------------------------------
	//public functions
	
	//constructor

		public function titleScreen(fRef:FileReference) 
		{
			super();
			//m_sButton = new Button();
			//m_sButton.label = sbText;
			//m_lButton = new Button();
			//m_lButton.label = lbText;
			
			//guided by direction to use sprite with button functionality, built with assistance from http://www.blog.mpcreation.pl/making-a-simply-button-in-as3/
			m_sButton = new Sprite();
			m_sButton.buttonMode = true;
			m_lButton = new Sprite();
			m_lButton.buttonMode = true;
			//set colors
			//0xFFFF00 = yellow
			//0x00FFFF = cyan
			m_sButton.graphics.beginFill(0x00FFFF);
			m_sButton.graphics.drawRect(0, 0, 100, 50);
			m_sButton.graphics.endFill();
			m_lButton.graphics.beginFill(0xFFFF00);
			m_lButton.graphics.drawRect(0, 0, 100, 50);
			m_lButton.graphics.endFill();
			
			m_titleLabel = new Label();
			m_titleLabel.text = tText;
			m_loadLabel = new Label();
			m_loadLabel.text = lsText;
			m_ref = fRef;
			//m_ref
			
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
			
			//set your events
			m_lButton.addEventListener(MouseEvent.CLICK, selFile);
			m_sButton.addEventListener(MouseEvent.CLICK, startGame);
			
		}
	
	//getters and setters
		
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
			
			var fFilter:FileFilter = new FileFilter("Documents", "*.txt");
			trace("selection start");
			m_ref.browse([fFilter]);
		}
		
		private function browseCanceledHandler(e:Event):void
		{
			trace("browsing cancelled");
			m_sButton.addEventListener(MouseEvent.CLICK, startGame);
			m_lButton.addEventListener(MouseEvent.CLICK, selFile);
			//m_inBox.editable = true;
		}
		
		private function selectedHandler(e:Event):void
		{
			trace("item selected")
			m_ref.removeEventListener(Event.SELECT, selFile);
			m_ref.removeEventListener(Event.CANCEL, browseCanceledHandler);
			m_ref.addEventListener(Event.COMPLETE, loadedHandler);
			m_ref.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			m_ref.load();
		}
		
		private function loadedHandler(e:Event):void
		{
			trace("item loaded");
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