package game.model.utils
{
	public class Console
	{
		private static var isLogEnabled:Boolean = false;
		private static var isInfoEnabled:Boolean = false;
		
		public function Console()
		{
		}
		
		public static function log(str:String):void
		{
			if (isLogEnabled)
			{
				debug(str);
			}
		}
		
		public static function info(str:String):void
		{
			if (isInfoEnabled)
			{
				trace(str);
			}
		}
		
		public static function debug(str:String):void
		{
			trace(str);
		}
	}
}
