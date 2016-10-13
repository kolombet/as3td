package game.model.towers.strategy
{
	import game.model.BaseCreepData;
	import game.model.PlayState;
	import game.model.towers.BaseTowerData;
	import game.model.utils.Util;
	
	import shared.math.Vec2;
	
	public class StrategyNearestToBase implements ITowerStrategy
	{
		/**
		 * Nearest enemy to your base, in tower radius
		 */
		public function StrategyNearestToBase()
		{
		}
		
		public function find(tower:BaseTowerData):BaseCreepData
		{
			var state:PlayState = tower.state;
			//Find creeps in tower radius
			var creeps:Vector.<BaseCreepData> = state.creepManager.collection;
			var availableTargets:Vector.<BaseCreepData> = new Vector.<BaseCreepData>();
			for (var c:int = 0; c < creeps.length; c++)
			{
				var creep:BaseCreepData = creeps[c];
				var distance:Vec2 = Util.distanceVect(tower, creep);
				if (distance.length <= tower.radius + tower.size / 2)
				{
					availableTargets.push(creep);
				}
			}
			
			if (availableTargets.length == 0)
			{
				return null;
			}
			//Find target nearest to base
			var nearestToBase:BaseCreepData;
			for (var i:int = 0; i < availableTargets.length; i++)
			{
				availableTargets[i].calculateRangeToBase(state);
			}
			availableTargets.sort(
					function (el1:BaseCreepData, el2:BaseCreepData):Boolean
					{
						return (el1.rangeToBase > el2.rangeToBase);
					}
			);
			nearestToBase = availableTargets[0];
			return nearestToBase;
		}
	}
}
