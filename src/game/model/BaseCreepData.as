package game.model
{
	import flash.geom.Point;
	
	import game.model.utils.Console;
	import game.model.utils.Util;
	
	import grid.TileData;
	
	import org.osflash.signals.Signal;
	
	import shared.math.Vec2;
	
	public class BaseCreepData implements IGameObj
	{
		private var _speed:Number = Config.TILE_SIZE;
		private var _path:Vector.<TileData>;
		private var _currentTile:TileData;
		private var _currentNode:int = 0;
		private var _rangeToBase:Number = 0;
		private var _hp:Number = 4;
		private var _id:int;
		private var _x:Number;
		private var _y:Number;
		private var _state:PlayState;
		private var _isFrozen:Boolean;
		private var _frozenDuration:Number;
		private var _frozenModifier:Number;
		private var _sector:int;
		private var _rotationName:String;
		private var _moveVector:Vec2;
		private var _onCreepKilled:Signal = new Signal(BaseCreepData);
		private var _onCreepPassed:Signal = new Signal(BaseCreepData);
		private var _reward:int;
		private var _isDead:Boolean;
		
		public function BaseCreepData(state:PlayState, wave:WaveData, creepId:int, path:Vector.<TileData>)
		{
			_moveVector = new Vec2();
			_hp = wave.health;
			_speed = wave.speed*Config.TILE_SIZE;
			_reward = wave.reward;
			_state = state;
			_id = creepId;
			_path = path;
		}
		
		public function advanceTime(time:Number):void
		{
			var frameDistance:Number = _speed * time;
			if (_isFrozen)
			{
				frameDistance = frameDistance * _frozenModifier;
				if (_frozenDuration > 0)
				{
					_frozenDuration -= time;
				}
				else
				{
					_isFrozen = false;
				}
			}
			moveToTarget(frameDistance);
		}
		
		private function moveToTarget(distance:Number):void
		{
			if (_path == null || _isDead)
				return;
			
			if (_currentNode > _path.length - 1)
			{
				_isDead = true;
				_onCreepPassed.dispatch(this);
				return;
			}
			_currentTile = _path[_currentNode];
			
			var vec:Vec2 = Pools.vec2.object;
			vec.x = _currentTile.cx - this.x;
			vec.y = _currentTile.cy - this.y;
			if (_moveVector.equals(vec) == false)
			{
				_moveVector = vec;
				if (vec.length > 0)
				{
					var faceVec:Vec2 = IsoTransform.from(vec);
					updateRotation(faceVec);
				}
			}
			
			if (vec.length > distance)
			{
				vec.normalizeSelf(distance);
			}
			else
			{
				_currentNode++;
				var remains:int = distance - vec.length;
				moveToTarget(remains);
			}
			x += vec.x;
			y += vec.y;
			Pools.vec2.object = vec;
		}
		
		private function updateRotation(vec:Vec2):void
		{
			var angle:int = vec.getDegrees();
			var sector:int = Math.round((vec.getRads()+Math.PI)/(Math.PI/4));
			if (sector > Direction.directionList.length)
				throw new Error("rot not found");
			if (_sector != sector)
			{
				_sector = sector;
				_rotationName = Direction.directionList[sector];
			}
		}
		
		public function destroy():void
		{
			_path = null;
			_onCreepKilled.removeAll();
			_onCreepPassed.removeAll();
			_onCreepKilled = null;
			_onCreepPassed = null;
		}
		
		public function calculateRangeToBase(state:PlayState):void
		{
			var base:TileData = state.map.base;
			var dx:Number = base.cx - x;
			var dy:Number = base.cy - y;
			_rangeToBase = Util.vecLength(dx, dy);
		}
		
		public function calculateRangeTo(target:Point):Number
		{
			return Util.vecLength(target.x - x, target.y - y);
		}
		
		public function get rangeToBase():int
		{
			return _rangeToBase;
		}
		
		public function get id():int
		{
			return _id;
		}
		
		public function get hp():Number
		{
			return _hp;
		}
		
		public function hit(value:int):void
		{
			if (_hp < 0 || _isDead)
				return;
			
			_hp -= value;
			Console.log("creep " + id + " hit, hp value: " + _hp);
			if (_hp <= 0)
			{
				Console.log("creep " + id + " is killed");
				_isDead = true;
				_onCreepKilled.dispatch(this);
			}
		}
		
		public function get x():Number
		{
			return _x;
		}
		
		public function set x(value:Number):void
		{
			_x = value;
		}
		
		public function get y():Number
		{
			return _y;
		}
		
		public function set y(value:Number):void
		{
			_y = value;
		}
		
		public function get state():PlayState
		{
			return _state;
		}
		
		public function applyFreeze(duration:Number, modifier:Number):void
		{
			_isFrozen = true;
			_frozenDuration = duration;
			_frozenModifier = modifier;
		}
		
		public function get rotationName():String
		{
			return _rotationName;
		}
		
		public function get onCreepKilled():Signal
		{
			return _onCreepKilled;
		}
		
		public function get onCreepPassed():Signal
		{
			return _onCreepPassed;
		}
		
		public function get reward():int
		{
			return _reward;
		}
		
		public function get depth():int
		{
			if (_currentTile == null) 
			{
				return 0;
			}
			return _currentTile.getDepth();
		}
	}
}
