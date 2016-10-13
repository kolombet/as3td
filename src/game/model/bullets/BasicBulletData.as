package game.model.bullets
{
	import flash.geom.Point;
	
	import game.model.BaseCreepData;
	import game.model.Config;
	import game.model.IGameObj;
	import game.model.PlayState;
	import game.model.bullets.effects.IEffect;
	
	import org.osflash.signals.Signal;
	
	import game.model.Pools;
	
	import shared.math.Vec2;
	
	public class BasicBulletData implements IGameObj
	{
		public var type:String;
		private var _state:PlayState;
		private var _x:Number;
		private var _y:Number;
		private var _target:BaseCreepData;
		private var _speed:Number = Config.TILE_SIZE * Config.BULLET_SPEED;
		private var _effect:IEffect;
		private var _isDead:Boolean = false;
		public var onDestroyed:Signal;
		
		public function BasicBulletData(state:PlayState, target:BaseCreepData, effect:IEffect, startX:Number, startY:Number)
		{
			_state = state;
			onDestroyed = new Signal(BasicBulletData);
			_effect = effect;
			_target = target;
			_x = startX;
			_y = startY;
		}
		
		public function get y():Number
		{
			return _y;
		}
		
		public function set y(value:Number):void
		{
			_y = value;
		}
		
		public function get x():Number
		{
			return _x;
		}
		
		public function set x(value:Number):void
		{
			_x = value;
		}
		
		public function get coords():Point
		{
			return new Point(_x, _y);
		}
		
		public function execute():void
		{
			if (_isDead)
				return;
			_effect.execute(_target);
			onDestroyed.dispatch(this);
			_isDead = true;
		}
		
		public function destroy():void
		{
			_state = null;
			_target = null;
			_effect = null;
			onDestroyed.removeAll();
			onDestroyed = null;
		}
		
		public function advanceTime(time:Number):void
		{
			if (_isDead)
				return;
			var frameDistance:Number = _speed * time;
			moveToTarget(frameDistance);
		}
		
		private function moveToTarget(distance:Number):void
		{
			var vec:Vec2 = Pools.vec2.object;
			vec.x = _target.x - this.x;
			vec.y = _target.y - this.y;
			
			var destroyDistance:int = Config.MIN_BULLET_DESTROY_DISTANCE;
			if (vec.length < destroyDistance)
				execute();
			if (vec.length > distance)
			{
				vec.normalizeSelf(distance);
			}
			else
			{
				execute();
			}
			x += vec.x;
			y += vec.y;
			Pools.vec2.object = vec;
		}
		
		public function get depth():int
		{
			return _state.map.getTileByCoords(x, y).getDepth();
		}
		
		public function get effect():IEffect
		{
			return _effect;
		}
	}
}
