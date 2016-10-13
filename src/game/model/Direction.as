package game.model
{
	public class Direction
	{
		public static const R:String = "R";
		public static const TR:String = "TR";
		public static const T:String = "T";
		public static const TL:String = "TL";
		public static const L:String = "L";
		public static const DL:String = "DL";
		public static const D:String = "D";
		public static const DR:String = "DR";
		
		public static var directionList:Array = [L, TL, T, TR, R, DR, D, DL];
		
		public function Direction()
		{
		}
		
		public static function getList():Array
		{
			return directionList;
		}
	}
}
