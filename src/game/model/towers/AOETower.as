package game.model.towers
{
	import game.model.Config;
	import game.model.PlayState;
	import game.model.bullets.effects.BulletEffects;
	
	public class AOETower extends BaseTowerData
	{
		//
		//Пушка 2:
		// Наносит одинаковый урон всем целям в радиусе атаки.
		// Урон = 2
		// Радиус атаки = 2.5
		// Скорострельность = 1.5
		// Стоимость = 85
		
		public function AOETower(state:PlayState)
		{
			super(state, BulletEffects.damageAOE);
			_radius = 4 * Config.TILE_SIZE;
			_shootSpeed = 4;
			_price = 85;
		}
	}
}
