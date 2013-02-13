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
	
		public static const LEVEL_HEADER_CODE:String = "HEADER";
		public static const LEVEL_FOOTER_CODE:String = "FOOTER";
		public static const LEVEL_END_CODE:String = "END";
		
		public static const HEADER_SIZE_CODE:String = "SIZE";
		public static const HEADER_ROBOT_CODE:String = "ROBOT";
		public static const HEADER_ASTEROID_CODE:String = "ASTEROID"
		public static const HEADER_RESOURCE_MAX_CODE:String = "MAX";
		public static const HEADER_RESOURCE_GOAL_CODE:String = "GOAL";
		public static const HEADER_REOURCE_START_CODE:String = "STARTR";
		
		public static const RESOURCE_GAS_CODE:String = "GAS";
		public static const RESOURCE_ENERGY_CODE:String = "ENERGY";
		
		public static const FOOTER_DATA_CODE:String = "DATA"
		
		public static const NEST1_DELIM:String = ":-:";
		public static const NEST2_DELIM:String = ":*:";
		public static const NEST3_DELIM:String = ":^:";
		public static const ITEM_PROP_DELIM:String = ".";
		public static const HF_DELIM:String = "&&&";
	
//--------------------------------------------------------------------------------------------------
	//protected properties

//--------------------------------------------------------------------------------------------------
	//private properties
		
		private var m_file:FileReference;
		
//-------------------------------------------------------------------------------------------------
	//public functions
		
	//constructor
		public function LevelReader(value:FileReference = null)
		{
			this.m_file = value;
		}//start out with null
		
	//getters and setters
		
		public function get file():FileReference
		{
			return this.m_file;
		}
		
		public function set file(value:FileReference):void
		{
			this.m_file = value;
		}
		
	//reading functions
	
	/*
		public function readfile():Vector.<Vector.<HexTile>>//signal to brows for a read file
		{
			return null;//new Vector.<Vector.<HexTile>>();
			
		}
	*/	
		
		
		/**
		 * 
		 * @param	fVal the string representing the footer of the read file, the map in text format
		 * @return	the map from the file
		 */
		public static function readMapFS(fVal:String, width:int = -1, height:int = -1 ):Vector.<Vector.<HexTile>>
		{
			trace("the size of the string for input is: " + fVal.length);
			trace(fVal);
			var placeHolder:Vector.<String> = new Vector.<String>();
			trace(fVal.split(NEST2_DELIM));
			placeHolder = Vector.<String>(fVal.split(NEST2_DELIM));
			var placeHolder2:Vector.<uint> = new Vector.<uint>(placeHolder.length);
			//trace("the size of the vector for conversion is: " + placeHolder.length);
			for (var i:uint = 0; i < placeHolder.length; i++)
			{
				placeHolder2[i] = uint(placeHolder[i]);
			}
			//trace("the size of the item of uints is: " + placeHolder2.length);
			return readMapFSV(placeHolder2, width, height);
		}
		
		public static function readMapFSV(fVal:Vector.<uint>, width:int = -1, height:int = -1):Vector.<Vector.<HexTile>>
		{
			//first let's get the right indices
			if (width < 1)
				width = 1;
			if (height < 1)
				height = fVal.length % width;
			while ( (height * width - width) > fVal.length)
				height--;
			trace("new height is now: " + height);
			//now let's get our hextile vector
			var rVal:Vector.<Vector.<HexTile>> = new Vector.<Vector.<HexTile>>(height);
			for (var i:uint = 0; i < rVal.length; i++)
				rVal[i] = new Vector.<HexTile>(width);
			var row:int = 0;
			var column:int = 0;
			var lim:int = fVal.length
			for (row = 0; row *width < lim && row < height; row++ )
			{
				for (column = 0; row * width + column < lim && column < width; column++)
				{
					rVal[row][column] = new HexTile(null, null, fVal[row*width+column], column, row);
				}
			}
			
			return rVal;
		}
		
		
		/**
		 * @param	fVal the file reference whose data will be read
		 * @return the map from the file
		 */
		public static function readfileFF(fVal:FileReference, width:int = -1, height:int = -1):Vector.<Vector.<HexTile>>
		{
			trace("reading file");
			var placeHolder:String = String(fVal.data);
			if (placeHolder.length < 1)
			{
				trace("placeholder is empty");
				return null;
			}
			var indexer:uint = 0;
			while (placeHolder.charAt(indexer) != HF_DELIM.charAt(0) && indexer < uint.MAX_VALUE-(HF_DELIM.length+1) && indexer < placeHolder.length - (HF_DELIM.length+1))
				indexer++;
			if (indexer == uint.MAX_VALUE-(HF_DELIM.length+1) || indexer == placeHolder.length-(HF_DELIM.length+1) || placeHolder.substring(indexer, indexer + HF_DELIM.length) != HF_DELIM)
			{
				trace("footer delim not found");
				return null;
			}
			indexer += HF_DELIM.length;
			if (placeHolder.substring(indexer, indexer + LEVEL_FOOTER_CODE.length) != LEVEL_FOOTER_CODE)
			{
				trace("footer not found");
				return null;
			}
			indexer += LEVEL_FOOTER_CODE.length;
			var indexer2:uint = FOOTER_DATA_CODE.length;
			var indexerDELIM:uint = NEST1_DELIM.length;
			if( indexerDELIM*2+indexer+indexer2 > placeHolder.length+1 || placeHolder.substring(indexer, indexer+indexerDELIM) != NEST1_DELIM || placeHolder.substring(indexer+indexerDELIM, indexer+indexerDELIM+indexer2) != FOOTER_DATA_CODE || placeHolder.substring(indexer+indexer2+indexerDELIM, indexer+indexer2+indexerDELIM*2) != NEST2_DELIM)
			{
				trace("data check error");
				return null;
			}
			var tempInd:uint = indexer;
			indexer = indexer + indexerDELIM + indexerDELIM + indexer2;//here is all the items
			//move to the next index so we don't catch an exit condition for the while loop
			//that adds 10 to indexer, now at 475 was 465
			var startIndex:uint = indexer;
			var endIndex:uint = startIndex;
			indexer2 = NEST1_DELIM.length;
			while (indexer+indexer2 < placeHolder.length + 1 && placeHolder.substring(indexer, indexer+indexer2) != NEST1_DELIM)
			{
				indexer++;
			}
			if ( indexer+indexer2+LEVEL_END_CODE.length > placeHolder.length || placeHolder.substring(indexer, indexer + indexer2) != NEST1_DELIM || placeHolder.substring(indexer+indexer2, indexer+indexer2+LEVEL_END_CODE.length) != LEVEL_END_CODE)
			{
				trace("file end not found");
				return null;
			}
			else
				endIndex = indexer;
			
			if ( !(endIndex > startIndex + 1))
			{
				return null;
			}
			else
			{
				return readMapFS(placeHolder.substring(startIndex, endIndex), width, height);	
			}
		}
		
		
	
	//random map functions: 
	
		public static function randMap(height:int, width:int,
						asteroidCenterX:int, asteroidCenterY:int,
						aRadSq:Number, gRadSq:Number, grid:HexGrid, emitter:GasEmitter):Vector.<Vector.<HexTile>>
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
			var result:Vector.<Vector.<HexTile>> = new Vector.<Vector.<HexTile>>(height)
			var row:Vector.<HexTile>;
			for (r = 0; r < height; r++)
			{
				row = new Vector.<HexTile>(width);
				result[r] = row;
				for (c = 0; c < width; c++)
				{
					row[c] = new HexTile(grid, emitter, LevelReader.getTileType(c, r, aRadSq, gRadSq, asteroidCenterX, asteroidCenterY), c, r);
				}
			}
			return result;
		}
		
		/**
		 * @return A 2-dimensional vector representing the map to be used from the member file reference
		 */
		public function fileToVector(width:int = -1, height:int = -1):Vector.<Vector.<HexTile>>
		{
			
			if (this.m_file != null && this.m_file.data != null)
			{
				return LevelReader.readfileFF(this.m_file, width, height);
			}
			else
			{
				trace("error with file thingy");
				return null;
			}
		}
		
		
	

//-------------------------------------------------------------------------------
	//protected functions
	
	
//-------------------------------------------------------------------------------
	//private functions
	
		private static function getTileType(column:int, row:int,
					aRadSq:Number, gRadSq:Number,
					asteroidCenterX:int, asteroidCenterY:int):int
		{
			var xDiff:int = HexGrid.columnToX(column) - asteroidCenterX;
			var yDiff:int = HexGrid.columnRowToY(column, row) - asteroidCenterY;
			if(xDiff * xDiff + yDiff * yDiff <= aRadSq)
			{
				if(xDiff * xDiff + yDiff * yDiff <= gRadSq) {
					if(Math.random() < 0.08) {
						return HexTile.GAS_DEPOSIT;
					} else if(Math.random() < 0.04) {
						return HexTile.VALVE_CLOSED;
					} else if(Math.random() < 0.04) {
						return HexTile.TURBINE;
					}
				}
				return HexTile.FILLED;
			}
			else
			{
				return HexTile.SPACE;
			}
		}
		
	}

}