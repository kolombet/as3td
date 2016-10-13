package game.model.bullets.effects
{
	import game.model.BaseCreepData;
	
	public class SlowEffect implements IEffect
	{
		private var _freezeDuration:Number;
		private var _freezeModifier:Number;
		
		public function SlowEffect(freezeDuration:Number, freezeModifier)
		{
			_freezeDuration = freezeDuration;
			_freezeModifier = freezeModifier;
		}
		
		public function execute(target:BaseCreepData):void
		{
			target.applyFreeze(_freezeDuration, _freezeModifier);
		}
	}
}
