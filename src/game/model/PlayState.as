package game.model
{
	import flash.geom.Point;
	
	import game.*;
	import game.model.managers.BulletManager;
	import game.model.managers.CreepManager;
	import game.model.managers.TowerManager;
	import game.model.managers.WaveManager;
	import game.model.mode.BaseMode;
	import game.model.mode.BuildTowerMode;
	import game.model.mode.EditorMode;
	import game.model.mode.NormalMode;
	import game.model.utils.Console;
	
	import grid.MapData;
	import grid.PassModel;
	
	import mx.utils.UIDUtil;
	
	import org.osflash.signals.Signal;
	
	import starling.animation.IAnimatable;
	import starling.animation.Juggler;
	import starling.core.Starling;
	
	public class PlayState implements IAnimatable, IDestroyable
	{
		private var _passModel:PassModel;
		private var _map:MapData;
		private var _previousTick:int = 0;
		private var _currentTick:int = 0;
		private var _towerManager:TowerManager;
		private var _creepManager:CreepManager;
		private var _bulletManager:BulletManager;
		private var _waveManager:WaveManager;
		private var _currentMode:BaseMode;
		private var _lives:int;
		private var _money:int;
		private var _modeActivated:Signal = new Signal(BaseMode);
		private var _onMoneyChanged:Signal = new Signal(Number);
		private var _onLivesChanged:Signal = new Signal(Number);
		private var _onGameEnded:Signal = new Signal();
		private var _onLevelWin:Signal = new Signal();
		private var _levelID:int;
		private var _isDestroyed:Boolean = false;
		private var _uid:String;
		private var _tick:Signal = new Signal();
		
		public function PlayState(levelID:int) {
			_uid = UIDUtil.createUID();
			_levelID = levelID;
			_lives = Config.START_LIVES_COUNT;
			_money = Config.START_MONEY_COUNT;
			_towerManager = new TowerManager(this);
			_creepManager = new CreepManager(this);
			_bulletManager = new BulletManager(this);
			_waveManager = new WaveManager(this);
			var waveData:Object = App.resources.assets.getObject(Config.WAVE_RES + _levelID);
			_waveManager.load(waveData.data);
			
			_map = new MapData(this);
			var mapData:Object = App.resources.assets.getObject(Config.LEVEL_RES + _levelID);
			_map.load(mapData);
			
			_passModel = new PassModel();
			_passModel.init(_map.data);
			_map.calculateRoads(_passModel);
		}
		
		public function init():void
		{
			activateNormal();
			_creepManager.onCreepPassed.add(onCreepPassedHandler);
			Console.log("Level started: " + _levelID + " uid: " + _uid);
		}
		
		private function onCreepPassedHandler(creep:BaseCreepData):void
		{
			lives--;
			if (lives <= 0)
			{
				Starling.juggler.delayCall(function():void {
					_onGameEnded.dispatch();
				}, .1);
			}
		}
		
		public function advanceTime(time:Number):void
		{
			if (_isDestroyed)
				return;
			
			_towerManager.advanceTime(time);
			_creepManager.advanceTime(time);
			_bulletManager.advanceTime(time);
			_waveManager.advanceTime(time);
			
			_currentTick = Starling.juggler.elapsedTime / Config.TICK_TIME;
			if (_previousTick != _currentTick)
			{
				_previousTick = _currentTick;
				onTick();
			}
		}
		
		private function onTick():void
		{
			_tick.dispatch();
		}
		
		public function get map():MapData
		{
			return _map;
		}
		
		public function get passModel():PassModel
		{
			return _passModel;
		}
		
		public function get towerManager():TowerManager
		{
			return _towerManager;
		}
		
		public function set map(value:MapData):void
		{
			_map = value;
		}
		
		public function get creepManager():CreepManager
		{
			return _creepManager;
		}
		
		public function get bulletManager():BulletManager
		{
			return _bulletManager;
		}
		
		public function activateEditor():void
		{
			activateMode(EditorMode)
		}
		
		public function activateNormal():void
		{
			activateMode(NormalMode);
		}
		
		public function activateBuild(towerFactory:Function):void
		{
			activateMode(BuildTowerMode, towerFactory);
		}
		
		public function activateMode(Mode:Class, data:Object = null):void
		{
			deactivatePrevMode();
			_currentMode = new Mode();
			_currentMode.activate(this, data);
			_modeActivated.dispatch(_currentMode);
		}
		
		private function deactivatePrevMode():void
		{
			if (_currentMode != null)
			{
				_currentMode.deactivate();
				_currentMode = null;
			}
		}
		
		public function get modeActivated():Signal
		{
			return _modeActivated;
		}
		
		public function get currentMode():BaseMode
		{
			return _currentMode;
		}
		
		public function get money():int
		{
			return _money;
		}
		
		public function set money(value:int):void
		{
			_money = value;
			_onMoneyChanged.dispatch(_money);
		}
		
		public function get lives():int
		{
			return _lives;
		}
		
		public function set lives(value:int):void
		{
			_lives = value;
			_onLivesChanged.dispatch(_lives);
			if (_lives < 0)
			{
				_onGameEnded.dispatch();
			}
		}
		
		public function get onMoneyChanged():Signal
		{
			return _onMoneyChanged;
		}
		
		public function get onLivesChanged():Signal
		{
			return _onLivesChanged;
		}
		
		public function get onGameEnded():Signal
		{
			return _onGameEnded;
		}
		
		public function get levelID():int
		{
			return _levelID;
		}
		
		public function get waveManager():WaveManager
		{
			return _waveManager;
		}
		
		public function destroy():void
		{
			Console.log("Destroying game world " + _uid);
			_creepManager.onCreepPassed.remove(onCreepPassedHandler);
			_isDestroyed = true;
			_passModel.destroy();
			_passModel = null;
			_map.destroy();
			_map = null;
			_towerManager.destroy();
			_towerManager = null;
			_creepManager.destroy();
			_creepManager = null;
			_bulletManager.destroy();
			_bulletManager = null;
			_waveManager.destroy();
			_waveManager = null;
			_currentMode.deactivate();
			_currentMode = null;
			_modeActivated.removeAll();
			_modeActivated = null;
			_onMoneyChanged.removeAll();
			_onMoneyChanged = null;
			_onLivesChanged.removeAll();
			_onLivesChanged = null;
			_onGameEnded.removeAll();
			_onGameEnded = null;
			_onLevelWin.removeAll();
			_onLevelWin = null;
		}
		
		public function get uid():String
		{
			return _uid;
		}
		
		public function get onLevelWin():Signal
		{
			return _onLevelWin;
		}
		
		public function get tick():Signal
		{
			return _tick;
		}
	}
}
