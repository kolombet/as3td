package game.model.bullets.effects
{
	import game.model.BaseCreepData;
	
	public class SingleDamage implements IEffect
	{
		private var _damage:Number;
		
		public function SingleDamage(damage:Number)
		{
			_damage = damage;
		}
		
		public function execute(target:BaseCreepData):void
		{
			target.hit(_damage);
		}
	}
}
