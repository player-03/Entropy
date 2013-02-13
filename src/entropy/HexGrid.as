package entropy 
{
	import entropy.HexTile;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
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
		
		public var energyGauge:EnergyGauge;
		
		public function HexGrid(emitter:GasEmitter, energyGauge:EnergyGauge,
						width:int, height:int = -1, asteroidRadius:Number = -1, data:Vector.<Vector.<uint>> = null)
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
			
			this.energyGauge = energyGauge;
			
			if(asteroidRadius < 1) {
				asteroidRadius = Math.min(m_asteroidCenterX, m_asteroidCenterY);
			}
			m_asteroidRadiusSquared = asteroidRadius * asteroidRadius;
			
			var gasRadiusSquared:Number = (asteroidRadius - HexTile.TILE_WIDTH) * (asteroidRadius - HexTile.TILE_WIDTH);
			
			
			if (data === null || data.length < 1 || data[0].length < 1)
			{
				data = LevelReader.randMap(m_height, m_width, m_asteroidCenterX, m_asteroidCenterY,
					m_asteroidRadiusSquared, gasRadiusSquared);
			}
			var r:int, c:int;
			m_hexes = new Vector.<Vector.<HexTile>>(m_height);
			for(r = 0; r < m_height; r++) {
				m_hexes[r] = new Vector.<HexTile>(m_width);
				for(c = 0; c < m_width; c++) {
					m_hexes[r][c] = new HexTile(this, emitter, data[r][c], c, r);
					addChild(m_hexes[r][c]);
				}
			}
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(e:MouseEvent):void {
			var clickedHex:HexTile = getHexAtCoordinates(mouseX, mouseY);
			
			if(clickedHex != null) {
				//TODO: Move this to the player class.
				switch(clickedHex.type) {
					case HexTile.FILLED:
						if(energyGauge.energyLevel >= 12) {
							energyGauge.energyLevel -= 12;
							clickedHex.type = HexTile.EXCAVATED;
						}
						break;
					case HexTile.EXCAVATED:
						if(energyGauge.energyLevel >= 4) {
							energyGauge.energyLevel -= 4;
							clickedHex.type = HexTile.VALVE_CLOSED;
						}
						break;
					case HexTile.VALVE_OPEN:
						clickedHex.type = HexTile.VALVE_CLOSED;
						break;
					case HexTile.VALVE_CLOSED:
						clickedHex.type = HexTile.VALVE_OPEN;
						break;
					default:
				}
			}
		}
		
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
		
		/**
		 * @return The hexTile at specified row and column
		 */
		public function getHex(column:int, row:int):HexTile
		{
			if(column < 0 || column >= m_width || row < 0 || row >= m_height)
			{
				return null;
			}
			return m_hexes[row][column];
		}
		
		/**
		 * @return the hexTile that exists at the row and column corresponding to local x y coordinates
		 */
		public function getHexAtCoordinates(x:Number, y:Number):HexTile {
			//huge hack
			x += HexTile.TILE_X_OFFSET;
			y += HexTile.TILE_HEIGHT / 2;
			
			//the int() function behaves differently for negative values,
			//so deal with those preemptively
			if(x < 0 || y < 0) {
				return null;
			}
			
			//kinda weird names; these correspond to the column and row,
			//PLUS fractions of one column/row
			var column:Number = x / HexTile.TILE_X_OFFSET;
			var row:Number = y / HexTile.TILE_HEIGHT - (int(column) & 1 == 1 ? 0.5 : 0);
			
			//also isolate the fractions
			var columnFraction:Number = column - int(column);
			var rowFraction:Number = row - int(row);
			
			//if the point falls in the overlapping zone
			if(columnFraction < HexTile.TILE_X_OVERLAP) {
				//if the point is above the halfway point
				if(rowFraction < 0.5) {
					//the dividing line stretches between the local points
					//(TILE_X_OVERLAP, 0) and (0, 0.5)
					if(rowFraction / HexTile.TILE_X_OVERLAP
							+ columnFraction / 0.5 < 1) {
						return getHexAboveLeft(int(column), int(row));
					}
				}
				
				//if the point is below the halfway point
				else {
					//the dividing line stretches between the local points
					//(0, 0.5) and (TILE_X_OVERLAP, 1)
					if((1 - rowFraction) / HexTile.TILE_X_OVERLAP
							+ columnFraction / 0.5 < 1) {
						return getHexBelowLeft(int(column), int(row));
					}
				}
			}
			
			return getHex(int(column), int(row));
		}
		
		private var tileBuffer:Vector.<HexTile> = new Vector.<HexTile>(6);
		public function getHexesAround(column:int, row:int):Vector.<HexTile>
		{
			tileBuffer[0] = getHexAbove(column, row);
			tileBuffer[1] = getHexAboveLeft(column, row);
			tileBuffer[2] = getHexBelowLeft(column, row);
			tileBuffer[3] = getHexBelow(column, row);
			tileBuffer[4] = getHexBelowRight(column, row);
			tileBuffer[5] = getHexAboveRight(column, row);
			return tileBuffer;
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
	}
}