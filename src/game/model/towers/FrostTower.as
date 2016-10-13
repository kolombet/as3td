package game.model.towers
{
	import game.model.Config;
	import game.model.PlayState;
	import game.model.bullets.effects.BulletEffects;
	
	public class FrostTower extends BaseTowerData
	{
		//Пушка 3:
		//Атакует одну цель, выбирает находящуюся ближе всего к выходу. Выстрел по врагу замедляет его скорость передвижения. Эффект не накладывается больше одного раза.
		// Замедление = 25%
		// Длительность эффекта = 2 сек.
		// Радиус атаки = 1.5 тайла
		// Скорострельность = 0.5 выстр/сек
		// Стоимость = 50
		public function FrostTower(state:PlayState)
		{
			super(state, BulletEffects.slow);
			_radius = 1.5 * Config.TILE_SIZE;
			_shootSpeed = .5;
			_price = 50;
		}
		
	}
}
