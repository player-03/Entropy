package entropy 
{
	
	import flash.net.FileReference;//use a file reference
	import flash.errors.IllegalOperationError;
	import entropy.HexTile;
	import entropy.HexGrid;
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.twoD.emitters.Emitter2D;
	
	public class LevelReader 
	{
		
//-------------------------------------------------------------------------------------------------
	//public properties
	
//--------------------------------------------------------------------------------------------------
	//protected properties

//--------------------------------------------------------------------------------------------------
	//private properties
		
		private var m_filepath:String;
		private var m_file:FileReference;
		
//-------------------------------------------------------------------------------------------------
	//public functions
		
	//constructor
		public function LevelReader(input:String = "")
		{
			this.m_filepath = input;
			this.m_file = null;
		}//start out with null
		
	//getters and setters
	
		public function get filepath():String
		{
			return this.m_filepath;
		}
		
		public function get file():FileReference
		{
			return this.m_file;
		}
		
		public function set filepath(value:String):void
		{
			
		}
		
		public function set file(value:FileReference):void
		{
			try
			{
			this.filepath = value.name;
			}
			catch(err:IllegalOperationError)
			{
				this.filepath = "";
				//trace("error getting file name")
			}
		}
		
	//reading functions
	
		public function readfile():Vector.<Vector.<HexTile>>//signal to brows for a read file
		{
			return null;//new Vector.<Vector.<HexTile>>();
			
		}
		
		public static function readfileFS(fVal:String):Vector.<Vector.<HexTile>>
		{
			return null;
		}
		
		public static function readfileFF(fVal:FileReference):Vector.<Vector.<HexTile>>
		{
			return null;
		}
	
	//random map functions: 
	
		public static function randMap(height:int, width:int, asteroidCenterX:int, asteroidCenterY:int, aRadSq:Number, emitter:Emitter):Vector.<Vector.<HexTile>>
		{
			if (height < 0)
			{
				return null;
			}
			if (width < 0)
			{
				width = height;
			}
			if (aRadSq < 1)
			{
				return null;
			}
			
			var r:int, c:int;
			var rVal:Vector.<Vector.<HexTile>> = new Vector.<Vector.<HexTile>>(height)
			var row:Vector.<HexTile>;
			for (r = 0; r < height; r++)
			{
				row = new Vector.<HexTile>(width);
				rVal[r] = row;
				for (c = 0; c < width; c++)
				{
					row[c] = new HexTile(null, emitter, LevelReader.getTileType(c, r, aRadSq, asteroidCenterX, asteroidCenterY), c, r);
				}
			}
			
			return rVal;
		}
		
		private static function getTileType(column:int, row:int, aRadSq:Number, asteroidCenterX:int, asteroidCenterY:int):int
		{
			
			
			var xDiff:int = HexGrid.columnToX(column) - asteroidCenterX;
			var yDiff:int = HexGrid.columnRowToY(column, row) - asteroidCenterY;
			if(Math.random() < 0.95 && xDiff * xDiff + yDiff * yDiff <= aRadSq)
			{
				return HexTile.FILLED;
			}
			else
			{
				return HexTile.SPACE;
			}
		}
	

//-------------------------------------------------------------------------------
	//protected functions
	
	
//-------------------------------------------------------------------------------
	//private functions
	
	
		
	}

}