package game.model.bullets.effects
{
	import flash.geom.Point;
	
	import game.model.BaseCreepData;
	import game.model.utils.Console;
	
	public class AOEDamage implements IEffect
	{
		private var _explosionRadius:Number;
		private var _explosionDamage:Number;
		
		public function AOEDamage(explosionRadius:Number, explosionDamage:Number):void
		{
			_explosionRadius = explosionRadius;
			_explosionDamage = explosionDamage;
		}
		
		//find all creeps in range
		public function execute(target:BaseCreepData):void
		{
			var creeps:Vector.<BaseCreepData> = target.state.creepManager.collection;
			var targetPoint:Point = new Point(target.x, target.y);
			for (var i:int = 0; i < creeps.length; i++)
			{
				var range:Number = creeps[i].calculateRangeTo(targetPoint);
				if (range <= _explosionRadius)
				{
					Console.log("victim: " + creeps[i].id);
					creeps[i].hit(_explosionDamage);
				}
			}
		}
	}
}
