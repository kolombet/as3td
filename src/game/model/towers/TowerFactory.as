package game.model.towers
{
	import game.model.PlayState;
	
	public class TowerFactory
	{
		public function TowerFactory()
		{
		}
		
		public static function createBasicTower(state:PlayState):BaseTowerData
		{
			return new BasicTower(state);
		}
		
		public static function createAOETower(state:PlayState):BaseTowerData
		{
			return new AOETower(state);
		}
		
		public static function createFrostTower(state:PlayState):BaseTowerData
		{
			return new FrostTower(state);
		}
		
		public static function generate(state:PlayState, type:String):BaseTowerData
		{
			if (type == TowerType.BASIC)
			{
				return new BasicTower(state);
			}
			else if (type == TowerType.AOE)
			{
				return new AOETower(state);
			}
			else if (type == TowerType.FROST)
			{
				return new FrostTower(state);
			}
			else
			{
				throw new Error("wrong tower type");
			}
		}
	}
}
