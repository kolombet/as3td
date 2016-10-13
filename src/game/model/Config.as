package game.model
{
	public class Config
	{
		public static const TILE_SIZE:int = 32;
		public static const TILE_SIZE_HALF:int = 16;
		public static const ISO_TILE_HEIGHT:int = 32;
		public static const ISO_TILE_WIDTH:int = 64;
		public static const TICK_TIME:Number = .1; 
		public static const BASE_URL:String = "resources/";
		public static const LEVEL_RES:String = "level_";
		public static const WAVE_RES:String = "wave_";
		public static const BACKGROUND_RES:String = BASE_URL + "background_";
		public static const RES_FORMAT:String = ".png";
		public static const START_LIVES_COUNT:int = 5;
		public static const START_MONEY_COUNT:int = 100;
		public static const WAVE_DELAY:int = 5;
		public static const BULLET_SPEED:int = 3;
		public static const MIN_BULLET_DESTROY_DISTANCE:int = 5;
		public static const SCENE_SHIFT:int = 637;
		
		public function Config()
		{
		}
	}
}
