package game.model.bullets.effects
{
	import game.model.BaseCreepData;
	
	public interface IEffect
	{
		function execute(target:BaseCreepData):void
	}
}
