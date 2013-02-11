package entropy 
{
	import entropy.HexTile;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	import org.flintparticles.common.emitters.Emitter;
	import entropy.LevelReader;
	
	public class HexGrid extends Sprite
	{
		private var m_asteroidCenterX:int;
		private var m_asteroidCenterY:int;
		private var m_asteroidRadiusSquared:Number;
		
		private var m_hexes:Vector.<Vector.<HexTile>>;
		private var m_width:int;
		private var m_height:int;
		
		public function HexGrid(emitter:Emitter, width:int, height:int = -1, asteroidRadius:Number = -1, data:Vector.<Vector.<HexTile>> = null)
		{
			super();
			
			if (width < 1)
			{	throw new ArgumentError("Width cannot be less than 1!"); }
			m_width = width;
			if (height < 1)
			{	height = width; }
			m_height = height;
			
			m_asteroidCenterX = m_width >> 1;
			m_asteroidCenterY = columnRowToY(m_asteroidCenterX, m_height >> 1);
			m_asteroidCenterX = columnToX(m_asteroidCenterX);
			
			if(asteroidRadius < 1) {
				asteroidRadius = Math.min(m_asteroidCenterX, m_asteroidCenterY);
			}
			m_asteroidRadiusSquared = asteroidRadius * asteroidRadius;
			
			if (data === null || data.length < 1 || data[0].length < 1)
			{
				m_hexes = LevelReader.randMap(m_height, m_width, m_asteroidCenterX, m_asteroidCenterY, m_asteroidRadiusSquared, emitter);
			}
			else
			{
				m_hexes = data;
			}
			
			var r:int, c:int;
			for (r = 0; r < height; r++)
			{
				for (c = 0; c < width; c++)
				{
					(this.m_hexes[r][c]).grid = this;//set the grid property of the hexagons
					this.addChild(this.m_hexes[r][c]);
				}
			}
		}
		/*
		private function getTileType(column:int, row:int):int
		{
			var xDiff:int = columnToX(column) - m_asteroidCenterX;
			var yDiff:int = columnRowToY(column, row) - m_asteroidCenterY;
			if(Math.random() < 0.95 && xDiff * xDiff + yDiff * yDiff <= m_asteroidRadiusSquared)
			{
				return HexTile.FILLED;
			}
			else
			{
				return HexTile.SPACE;
			}
		}
		*/
		
		/**
		 * @return The x coordinate of a tile in the given column.
		 */
		public static function columnToX(column:int):Number
		{
			return column * HexTile.TILE_X_OFFSET;
		}
		
		/**
		 * @return The y coordinate of a tile in the given column and row.
		 */
		public static function columnRowToY(column:int, row:int):Number
		{
			//(column & 1) == 1 checks if column is odd,
			//and odd-numbered columns are slightly lower
			return (row + ((column & 1) == 1 ? 0.5 : 0)) * HexTile.TILE_HEIGHT;
		}
		
		public function getHex(column:int, row:int):HexTile
		{
			if(column < 0 || column >= m_width || row < 0 || row >= m_height)
			{
				return null;
			}
			return m_hexes[row][column];
		}
		
		public static function getHex(vect:Vector.<Vector.<HexTile>>, column:int, row:int):HexTile
		{
			if (vect.length < 1 || vect[0].length < 1 || column < 0 || column >= vect.length || row < 0 || row > vect[0].length)
			{
				return null;
			}
			return vect[row][column];
			
		}
		
		public function getHexAbove(column:int, row:int):HexTile
		{
			return this.getHex(column, row - 1);
		}
		public function getHexAboveLeft(column:int, row:int):HexTile
		{
			if((column & 1) == 1)
			{
				return this.getHex(column - 1, row);
			}
			return this.getHex(column - 1, row - 1);
		}
		public function getHexAboveRight(column:int, row:int):HexTile
		{
			if((column & 1) == 1)
			{
				return this.getHex(column + 1, row);
			}
			return this.getHex(column + 1, row - 1);
		}
		public function getHexBelow(column:int, row:int):HexTile
		{
			return this.getHex(column, row + 1);
		}
		public function getHexBelowLeft(column:int, row:int):HexTile
		{
			if((column & 1) == 1)
			{
				return this.getHex(column - 1, row + 1);
			}
			return this.getHex(column - 1, row);
		}
		public function getHexBelowRight(column:int, row:int):HexTile
		{
			if((column & 1) == 1)
			{
				return this.getHex(column + 1, row + 1);
			}
			return this.getHex(column + 1, row);
		}
		//-------------------------------------------------
		//now the static versions of above
		public static function getHexAbove(vect:Vector.<Vector.<HexTile>>, column:int, row:int):HexTile
		{
			return HexGrid.getHex(vect, column, row - 1);
		}
		public static function getHexAboveLeft(vect:Vector.<Vector.<HexTile>>, column:int, row:int):HexTile
		{
			if((column & 1) == 1)
			{
				return HexGrid.getHex(vect, column + 1, row);
			}
			return HexGrid.getHex(vect, column + 1, row - 1);
		}
		public static function getHexAboveRight(vect:Vector.<Vector.<HexTile>>, column:int, row:int):HexTile
		{
			if((column & 1) == 1)
			{
				return HexGrid.getHex(vect, column + 1, row);
			}
			return HexGrid.getHex(vect, column + 1, row - 1);
		}
		public static function getHexBelow(vect:Vector.<Vector.<HexTile>>, column:int, row:int):HexTile
		{
			return HexGrid.getHex(vect, column, row + 1);
		}
		public static function getHexBelowLeft(vect:Vector.<Vector.<HexTile>>, column:int, row:int):HexTile
		{
			if((column & 1) == 1)
			{
				return HexGrid.getHex(vect, column - 1, row + 1);
			}
			return HexGrid.getHex(vect, column - 1, row);
		}
		public static function getHexBelowRight(vect:Vector.<Vector.<HexTile>>, column:int, row:int):HexTile
		{
			if((column & 1) == 1)
			{
				return HexGrid.getHex(vect, column + 1, row + 1);
			}
			return HexGrid.getHex(vect, column + 1, row);
		}
		
		
	}
}