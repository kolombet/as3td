package game.model.managers
{
	import game.model.BaseCreepData;
	import game.model.IDestroyable;
	import game.model.PlayState;
	import game.model.WaveData;
	import game.model.utils.Console;
	
	import grid.TileData;
	
	import org.osflash.signals.Signal;
	
	import starling.animation.IAnimatable;
	
	import starling.core.Starling;
	
	public class CreepManager implements IDestroyable
	{
		private var _state:PlayState;
		private var _creepID:int = 0;
		private var _collection:Vector.<BaseCreepData>;
		private var _onCreepSpawned:Signal = new Signal(BaseCreepData);
		private var _onCreepKilled:Signal = new Signal(BaseCreepData);
		private var _onCreepPassed:Signal = new Signal(BaseCreepData);
		
		public function CreepManager(state:PlayState)
		{
			_state = state;
			_collection = new Vector.<BaseCreepData>();
		}
		
		public function advanceTime(time:Number):void
		{
			if (_collection == null)
			{
				Console.log("error");
				return;
			}
			var len:int = _collection.length;
			var uid:String = _state.uid;
			for (var i:int = 0; i < _collection.length; i++)
			{
				_collection[i].advanceTime(time);
			}
		}
		
		public function spawnCreep(wave:WaveData, pointID:int):void
		{
			var path:Vector.<TileData> = _state.map.roads[pointID];
			
			var creepData:BaseCreepData = new BaseCreepData(_state, wave, _creepID, path);
			_creepID++;
			creepData.x = path[0].cx;
			creepData.y = path[0].cy;
			_collection.push(creepData);
			_onCreepSpawned.dispatch(creepData);
			creepData.onCreepKilled.addOnce(onCreepKilledHandler);
			creepData.onCreepPassed.addOnce(onCreepPassedHandler);
		}
		
		private function onCreepKilledHandler(data:BaseCreepData):void
		{
			_state.money += data.reward;
			_onCreepKilled.dispatch(data);
			removeCreep(data);
			Console.log("killed creep id: " + data.id);
		}
		
		private function onCreepPassedHandler(data:BaseCreepData):void
		{
			_onCreepPassed.dispatch(data);
			removeCreep(data);
			Console.log("passed creep id: " + data.id)
		}
		
		private function removeCreep(data:BaseCreepData):void
		{
			if (_collection == null)
					return;
			var creepIndex:int = _collection.indexOf(data);
			_collection.splice(creepIndex, 1);
			data.destroy();
			Console.log("creeps remained: " + aliveCreepCount());
		}
		
		public function get collection():Vector.<BaseCreepData>
		{
			return _collection;
		}
		
		public function aliveCreepCount():int
		{
			return _collection.length;
		}
		
		public function destroy():void
		{
			_state = null;
			for (var i:int = 0; i < _collection.length; i++)
			{
				_collection[i].destroy();
				_collection[i] = null;
			}
			_collection = null;
			_onCreepSpawned.removeAll();
			_onCreepSpawned = null;
			_onCreepKilled.removeAll();
			_onCreepKilled = null;
			_onCreepPassed.removeAll();
			_onCreepPassed = null;
		}
		
		public function get onCreepSpawned():Signal
		{
			return _onCreepSpawned;
		}
		
		public function get onCreepKilled():Signal
		{
			return _onCreepKilled;
		}
		
		public function get onCreepPassed():Signal
		{
			return _onCreepPassed;
		}
	}
}
