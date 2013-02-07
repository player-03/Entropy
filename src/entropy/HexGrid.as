package entropy 
{
	import entropy.HexagonZone;//use the hexagon zone enums for type?
	import flash.display.DisplayObject;
	
	public class HexGrid extends DisplayObject//we want to be able to display all the things in this class
	{
//PUBLIC_MEMBERS------------------------------------------------------------------------------------------------------------------------------------------------		
		public static const POINTONX:int = 0;//enum describing that a point of the hexagon is on the x axis, the default option
		public static const POINTONY:int = POINTONX+1;//a point on the hexagon is on the y axis, the alternate orientation
		public static const NUM_ORIENTATIONS = POINTONY+1;
		public static const DOWNLEFT:int = 0;//enum describes zigzagging on the x axis in case of default orientation and y axis in case of second orientation
		//in downleft the second hexagon will be below center of the first (x axis) and left of center of the first (y axis)
		public static const UPRIGHT:int = DOWNLEFT + 1;//above center of the first (x axis) and right of center of the first (y axis)
		public static const NUM_RELPOS = UPRIGHT + 1;

		private var m_hexes:Vector.<Vector.<HexagonZone>>;//data
		private var m_width:int;
		private var m_height:int;//dimensions of the data
		private var m_orientation:int;//what sort of hexagon
		private var m_relPos:int;//which zigzag
		
//PUBLIC_FUNCTIONS--------------------------------------------------------------------------------------------------------------------------------------------------
	//CONSTRUCTORS:------------------------------------------------------------------------------------------------
		
		//default
		public function HexGrid(width:int, height:int = width, radius = 23, orientation:int = POINTONX, relPos:int = DOWNLEFT)//default is a square grid, with default orientation
		{
			super();//declare the display object
			//simply start out with an array of standard hexagon zones
			m_orientation = ( (orientation >= 0 && orientation < NUM_ORIENTATIONS) ? orientation : POINTONX);
			m_relPos = (  (relPos >= 0 && relPos < NUM_RELPOS) ? relPos : DOWNLEFT);
			
			if (width < 1)
			{	throw new ArgumentError("Width cannot be less than 1!"); }
			m_width = width;
			if (height < 1)
			{	throw new ArgumentError("Height cannot be less than 1!"); }
			m_height = height;
			
			//start down horizontal if on x, start down vertical if on y
			var tempDir1:int = ( (m_orientation == POINTONX ) ? m_width : m_height );
			var tempDir2:int = ( (m_orientation == POINTONX ) ? m_height : m_width );
			m_hexes = this.buildEmptyVector(tempDir1, tempDir2);
			//now we need to position each of the hexagons appropriately
			for (var i1:int = 0; i1 < tempDir1; i1++)
			{
				for (var i2:int = 0; i2 < tempDir2; i2++ )
				{
					var tempx:Number = 0;//x should start 0, 
					var tempy:Number = 0;
					m_hexes[tempDir1][tempDir2] = new HexagonZone(tempx, tempy, 23);
					
				}
			}
			
			//now we connect the hexagons
			
			//now we register the hexagons with this thing
			for (var i1:int = 0; i1 < tempDir1; i1++)
			{
				for (var i2:int = 0; i2 < tempDir2; i2++)
				{
					this.addChild(m_hexes[tempDir1][tempDir2]);//add to the display.
				}
			}
			
		}
		//if we have a file that we are reading from
		public function HexGrid(items:Vector.<String>, width:int, height:int = width, radius:Number = 23, orientation:int = POINTONX, relPos:int = DOWNLEFT)
		{
			super();//declare the display object
		}
	//
	
	//parse the string into a list of items
		public function parseInputString(items:String):Vector.<String>
		{
			return new Vector.<String>;
		}
		
		public function 
		
		
//PROTECTED-------------------------------------------------------------------------------------------------------------------------------------------------------
		
		//helper function for constructor
		protected static function buildEmptyVector(tempDir1:int, tempDir2:int):Vector.<Vector.<HexagonZone>>
		{
			//start down horizontal if on x, start down vertical if on y
			var hexes:Vector.<Vector.<HexagonZone>> = new Vector.<Vector.<HexagonZone>>();
			for (var i:int = 0; i < tempDir1; i++)
			{
				hexes.push(new Vector.<HexagonZone>(tempDir2));//push on an empty array of appropriate size
			}
			return hexes;
		}
		
		//helper function for constructor
		protected static function adaptVector(inVect:Vector.<Vector.<HexagonZone>>, orientation:int = HexGrid.POINTONX, relPos = HexGrid.DOWNLEFT)
		{//once we have an empty vector, we need to put all the 
			//var outVect:Vector.<Vector.<HexagonZone>> = inVect.map( )//.
			
			//to byte array
			var copier:ByteArray = new ByteArray();
			copier.writeObject(inVect);
			copier.position = 0;
			var outVect:Vector.<Vector.<HexagonZone>> = copier.readObject();
			//now that we have a vector let's change it with new objects
			var relPosMult:int = (relPos == HexGrid.DOWNLEFT ) ? -1 : 1;//down and left, or up and right
			var xDif:Number = ( orientation == HexGrid.POINTONX ) ? 1 : 0.5;//if on the x we are going sideways and we want to have a bigger x distance
			var yDif:Number = ( orientation == HexGrid.POINTONX ) ? 0.5 : 1;//if on the x we are going sideways and all y difference is due to staggering
			
			
			/*
			 * here we connect the hexagons to each other
			 * /
			
		}
		
		protected static function adaptVector(inVect:Vector.<Vector.<HexagonZone>>, items:Vector.<String>, 
		
		
		/*
		protected static function hexMapCallback(item:Object, index:int, vector:Vector.<T>):T
		{
			item = vector[index].map(hexMapDeepCallback);
		}
		
		protected static function hexMapDeepCallback(item:Object, index:int, vector:Vector.<T>):T
		{
			item = T(vector[index]);
		}
		*/

//PRIVATE------------------------------------------------------------------------------------------------------------------------------------------------------
		
	//HELPER FUNCTIONS
	
	
	
	
		
	}
	
	

}