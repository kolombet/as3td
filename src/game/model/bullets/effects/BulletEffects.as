package game.model.bullets.effects
{
	import game.model.Config;
	
	public class BulletEffects
	{
		public static var single:SingleDamage = new SingleDamage(4);
		public static var damageAOE:AOEDamage = new AOEDamage(2.5*Config.TILE_SIZE, 2);
		public static var slow:SlowEffect = new SlowEffect(2, .75);
		
		public function BulletEffects()
		{
		}
	}
}
