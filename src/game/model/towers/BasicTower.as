package game.model.towers
{
	import game.model.Config;
	import game.model.PlayState;
	import game.model.bullets.effects.BulletEffects;
	
	public class BasicTower extends BaseTowerData
	{
		/*
		 Пушка 1:
		  Атакует одну цель, выбирает находящуюся ближе всего к выходу.
		  Урон = 4
		  Радиус атаки = 4 тайла
		  Скорострельность = 1.5 выстр/сек
		  Стоимость = 100
		 */
		
		public function BasicTower(state:PlayState)
		{
			super(state, BulletEffects.single);
			_radius = 4 * Config.TILE_SIZE;
			_shootSpeed = 1.5;
			_price = 100;
		}
		
		override public function advanceTime(time:Number):void
		{
			super.advanceTime(time);
		}
	}
}
