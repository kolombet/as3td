package game.model.managers
{
	import game.model.Config;
	import game.model.IDestroyable;
	import game.model.PlayState;
	import game.model.WaveData;
	import game.model.utils.Console;
	
	import org.osflash.signals.Signal;
	
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	
	public class WaveManager implements IAnimatable, IDestroyable
	{
		private var _state:PlayState;
		private var _waves:Vector.<WaveData>;
		private var _currentWave:WaveData;
		private var _creepsRemained:int;
		private var _spawnCooldown:Number;
		private var _waveDelay:Number;
		private var _waitingForWave:Boolean;
		private var _creepsToKillChanged:Signal = new Signal(int);
		private var _timeToNextWave:Signal = new Signal(Number);
		
		public function WaveManager(state:PlayState)
		{
			_state = state;
			_waves = new Vector.<WaveData>();
			_waveDelay = 0;
			_waitingForWave = false;
		}
		
		public function load(data:Object):void
		{
			var waves:Array = (data as Array);
			for (var i:int = 0; i < waves.length; i++)
			{
				var wave:WaveData = new WaveData();
				wave.init(waves[i]);
				_waves.push(wave);
			}
			
			initWave(0);
		}
		
		public function initWave(waveID:int):void
		{
			if (waveID > _waves.length)
			{
				_state.onLevelWin.dispatch();
				return;
			}
			_currentWave = _waves[waveID];
			_creepsRemained = _currentWave.count;
			_spawnCooldown = _currentWave.spawnDelay;
		}
		
		public function advanceTime(time:Number):void
		{
			if (_waitingForWave)
			{
				var creepsToKill:int = _state.creepManager.aliveCreepCount();
				if (creepsToKill > 0)
				{
					creepsToKillChanged.dispatch(creepsToKill);
					return;
				}
				
				if (_waveDelay > 0)
				{
					timeToNextWave.dispatch(_waveDelay);
					_waveDelay -= time;
				}
				else
				{
					_waitingForWave = false;
					initWave(_currentWave.id + 1);
					Console.log("init wave " + _currentWave.id);
				}
				return;
			}
			
			_spawnCooldown -= time;
			if (_spawnCooldown <= 0)
			{
				if (_creepsRemained <= 0)
				{
					_waveDelay = Config.WAVE_DELAY;
					_waitingForWave = true;
				}
				else
				{
					var spawnPoints:int = _state.map.spawnPoints.length;
					while (spawnPoints > 0 && _creepsRemained > 0)
					{
						_state.creepManager.spawnCreep(_currentWave, spawnPoints - 1);
						_creepsRemained--;
						spawnPoints--;
						_spawnCooldown = _currentWave.spawnDelay;
					}
				}
			}
		}
		
		public function get creepsToKillChanged():Signal
		{
			return _creepsToKillChanged;
		}
		
		public function get timeToNextWave():Signal
		{
			return _timeToNextWave;
		}
		
		public function destroy():void
		{
			_state = null;
			for (var i:int = 0; i<_waves.length; i++)
			{
				_waves[i].destroy();
				_waves[i] = null;
			}
			_currentWave.destroy();
			_currentWave = null;
			_creepsToKillChanged.removeAll();
			_creepsToKillChanged = null;
			_timeToNextWave.removeAll();
			_timeToNextWave = null;
		}
	}
}
