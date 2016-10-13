package game.view
{
	
	import flash.geom.Point;
	
	import game.App;
	import game.model.IGameObj;
	
	import game.model.IsoTransform;
	import game.model.Pools;
	import game.model.bullets.BasicBulletData;
	import game.model.bullets.effects.AOEDamage;
	import game.model.bullets.effects.BulletEffects;
	import game.model.bullets.effects.SingleDamage;
	import game.model.bullets.effects.SlowEffect;
	
	import starling.display.Quad;
	import starling.display.Sprite;
	
	public class BulletView extends Sprite implements IGameView
	{
		private var _data:BasicBulletData;
		
		public function BulletView(data:BasicBulletData)
		{
			_data = data;
			if (_data.effect is AOEDamage)
			{
				addChild(App.resources.getBulletAoeFire());
			} 
			else if (_data.effect is SingleDamage)
			{
				addChild(App.resources.getBulletFire());
			}
			else if (_data.effect is SlowEffect)
			{
				addChild(App.resources.getBulletFrost());
			}
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
		
		public function advanceTime(time:Number):void
		{
			var p:Point = IsoTransform.fromP(_data.coords);
			this.x = p.x;
			this.y = p.y;
			Pools.point.object = p;
		}
		
		public function getData():IGameObj
		{
			return _data;
		}
		
		public function destroy():void
		{
			_data = null;
			super .dispose();
		}
	}
}
