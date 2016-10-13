package game.model.towers
{
	import flash.geom.Point;
	
	import game.model.BaseCreepData;
	import game.model.Config;
	import game.model.IDestroyable;
	import game.model.IGameObj;
	import game.model.PlayState;
	import game.model.bullets.effects.IEffect;
	import game.model.towers.strategy.ITowerStrategy;
	import game.model.towers.strategy.StrategyNearestToBase;
	
	import grid.TileData;
	
	import starling.core.Starling;
	
	public class BaseTowerData implements IGameObj, IDestroyable
	{
		protected var _type:String;
		protected var _radius:Number;
		protected var _shootSpeed:Number;
		protected var _price:int;
		protected var _shootCooldown:Number = 0;
		protected var _towerState:String;
		protected var _state:PlayState;
		protected var _currentEnemy:BaseCreepData;
		protected var _x:Number;
		protected var _y:Number;
		protected var _findEnemyStrategy:ITowerStrategy;
		protected var _effect:IEffect;
		protected var _size:Number;
		protected var _targetTile:TileData;
		
		public function BaseTowerData(state:PlayState, effect:IEffect)
		{
			_effect = effect;
			_state = state;
			_findEnemyStrategy = new StrategyNearestToBase();
			_towerState = TowerState.IDLE;
			_size = Config.TILE_SIZE * 3;
		}
		
		public function advanceTime(time:Number):void
		{
			if (_shootCooldown > 0)
			{
				_shootCooldown -= time;
				return;
			}
			_currentEnemy = _findEnemyStrategy.find(this);
			if (_currentEnemy != null)
			{
				_towerState = TowerState.ATTACK
			}
			else
			{
				_towerState = TowerState.IDLE;
			}
			
			if (_towerState == TowerState.ATTACK)
			{
				if (_shootCooldown <= 0)
				{
					_shootCooldown += _shootSpeed;
					_state.bulletManager.spawn(_currentEnemy, _effect, _x, _y);
				}
			}
		}
		
		public function get y():Number
		{
			return _y;
		}
		
		public function get x():Number
		{
			return _x;
		}
		
		public function set x(value:Number):void
		{
			_x = value;
		}
		
		public function set y(value:Number):void
		{
			_y = value;
		}
		
		public function get coords():Point
		{
			return new Point(_x, _y);
		}
		
		public function get state():PlayState
		{
			return _state;
		}
		
		public function get type():String
		{
			return _type;
		}
		
		public function get radius():Number
		{
			return _radius;
		}
		
		public function get size():Number
		{
			return _size;
		}
		
		public function get price():int
		{
			return _price;
		}
		
		public function destroy():void
		{
			_towerState = null;
			_state = null;
			_currentEnemy = null;
			_findEnemyStrategy = null;
			_effect = null;
		}
		
		public function set targetTile(value:TileData):void
		{
			_targetTile = value;
		}
		
		public function get targetTile():TileData
		{
			return _targetTile;
		}
		
		public function get depth():int
		{
			return _targetTile.getDepth();
		}
	}
}
