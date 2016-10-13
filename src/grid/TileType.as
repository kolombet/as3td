package grid
{
	public class TileType
	{
		/**
		 * Empty tile. Creeps can pass
		 */
		public static const FREE:int = 0;
		/**
		 * Creeps can't pass
		 */
		public static const BLOCKED:int = 1;
		/**
		 * Player can build tower here + Creeps can't pass
		 */
		public static const BUILD:int = 2;
		/**
		 * Tower build blocked + Creeps can't pass
		 */
		public static const BUILD_BLOCKED:int = 3;
		
		public function TileType()
		{
		}
		
		/**
		 * returns next tile type
		 * @param type - current type
		 * @return - new type
		 */
		public static function getNext(type:int):int
		{
			if (type < 2)
			{
				type++;
			}
			else
			{
				type = 0;
			}
			return type;
		}
	}
}
