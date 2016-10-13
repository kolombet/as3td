package game.model.towers.strategy
{
	import game.model.BaseCreepData;
	import game.model.towers.BaseTowerData;
	
	public interface ITowerStrategy
	{
		function find(tower:BaseTowerData):BaseCreepData
	}
}
