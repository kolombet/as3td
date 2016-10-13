package game.view
{
	import feathers.controls.Button;
	
	import game.App;
	import game.model.IDestroyable;
	import game.model.PlayState;
	import game.model.mode.BaseMode;
	import game.model.mode.EditorMode;
	import game.model.mode.NormalMode;
	import game.model.towers.TowerFactory;
	import game.model.utils.Util;
	
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class GameUI extends Sprite implements IDestroyable
	{
		private var _state:PlayState;
		private var _moneyButton:Button;
		private var _livesButton:Button;
		private var _saveMapBtn:Button;
		private var _editorModeBtn:Button;
		private var _buildSimpleTower:Button;
		private var _buildAoeTower:Button;
		private var _buildFrostTower:Button;
		private var _normalModeBtn:Button;
		private var _restartGame:Button;
		private var _waveTimerBtn:Button;
		private var _buttons:Array;
		private var _staticButtons:Sprite;
		
		public function GameUI()
		{
			
		}
		
		public function init(state:PlayState):void
		{
			_staticButtons = new Sprite();
			_state = state;
			_moneyButton = new Button();
			setMoney(state.money);
			_livesButton = new Button();
			setLives(state.lives);
			_saveMapBtn = new Button();
			_saveMapBtn.label = "save map";
			_saveMapBtn.visible = false;
			_editorModeBtn = new Button();
			_editorModeBtn.label = "editor mode";
			_normalModeBtn = new Button();
			_normalModeBtn.label = "normal mode";
			_buildSimpleTower = new Button();
			_buildSimpleTower.label = "build tower";
			_buildAoeTower = new Button();
			_buildAoeTower.label = "build aoe tower";
			_buildFrostTower = new Button();
			_buildFrostTower.label = "build frost tower";
			_restartGame = new Button();
			_restartGame.label = "restart game";
			_waveTimerBtn = new Button();
			
			_buttons = [
				_waveTimerBtn, _moneyButton, _livesButton, _saveMapBtn, _editorModeBtn, _normalModeBtn, _buildSimpleTower,
				_buildAoeTower, _buildFrostTower, _restartGame, 
			];
			for (var i:int = 0; i < _buttons.length; i++)
			{
				var b:Button = _buttons[i];
				b.y = 50 + i * 30;
				b.addEventListener(TouchEvent.TOUCH, onTouch);
			}
			_staticButtons.addChild(_saveMapBtn);
			_staticButtons.addChild(_editorModeBtn);
			_staticButtons.addChild(_normalModeBtn);
			_staticButtons.addChild(_buildAoeTower);
			_staticButtons.addChild(_buildSimpleTower);
			_staticButtons.addChild(_buildFrostTower);
			_staticButtons.addChild(_restartGame);
			addChild(_waveTimerBtn);
			addChild(_moneyButton);
			addChild(_livesButton);
			addChild(_staticButtons);
			//_staticButtons.flatten(true);
			
			state.modeActivated.add(onModeChanged);
			state.onMoneyChanged.add(onMoneyChanged);
			state.onLivesChanged.add(onLivesChanged);
			state.waveManager.timeToNextWave.add(onTimeToNextWaveChanged);
			state.waveManager.creepsToKillChanged.add(onCreepsToKillChanged);
			state.onLevelWin.add(onGameWinHandler);
			state.onGameEnded.add(onGameEndedHandler);
		}
		
		private function onGameEndedHandler():void
		{
			_waveTimerBtn.label = "You loose";
		}
		
		private function onGameWinHandler():void
		{
			_waveTimerBtn.label = "You win";
		}
		
		private function onCreepsToKillChanged(count:int):void
		{
			_waveTimerBtn.label = "Creeps alive: " + count;
		}
		
		private function onTimeToNextWaveChanged(time:Number):void
		{
			_waveTimerBtn.label = "time to next wave: " + time.toFixed(1);
		}
		
		private function onLivesChanged(value:Number):void
		{
			setLives(value);
		}
		
		private function onMoneyChanged(value:Number):void
		{
			setMoney(value);
		}
		
		private function setLives(value:Number):void
		{
			_livesButton.label = "Lives: " + value;
		}
		
		private function setMoney(value:Number):void
		{
			_moneyButton.label = "Money: " + value;
		}
		
		private function onModeChanged(mode:BaseMode):void
		{
			_saveMapBtn.visible = (mode is EditorMode);
			_editorModeBtn.visible = !(mode is EditorMode);
			_normalModeBtn.visible = !(mode is NormalMode);
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this);
			if (touch == null)
				return;
			if (touch.phase == TouchPhase.ENDED)
			{
				if (event.target == _saveMapBtn)
				{
					saveMap();
				}
				else if (event.target == _editorModeBtn)
				{
					_state.activateEditor();
				}
				else if (event.target == _buildSimpleTower)
				{
					_state.activateBuild(TowerFactory.createBasicTower);
				}
				else if (event.target == _buildAoeTower)
				{
					_state.activateBuild(TowerFactory.createAOETower);
				}
				else if (event.target == _buildFrostTower)
				{
					_state.activateBuild(TowerFactory.createFrostTower);
				}
				else if (event.target == _normalModeBtn)
				{
					_state.activateNormal();
				}
				else if (event.target == _restartGame)
				{
					App.instance.restartLevel();
				}
				else if (event.target == _moneyButton)
				{
					_state.money += 500;
				}
				else if (event.target == _livesButton)
				{
					_state.lives += 50;
				}
			}
		}
		
		private function saveMap():void
		{
			var save:Object = _state.map.save();
			var saveStr:String = JSON.stringify(save);
			Util.outFile("level.json", saveStr);
		}
		
		public function destroy():void
		{
			_state.modeActivated.remove(onModeChanged);
			_state.onMoneyChanged.remove(onMoneyChanged);
			_state.onLivesChanged.remove(onLivesChanged);
			_state.waveManager.timeToNextWave.remove(onTimeToNextWaveChanged);
			_state.waveManager.creepsToKillChanged.remove(onCreepsToKillChanged);
			_state.onLevelWin.remove(onGameWinHandler);
			_state.onGameEnded.remove(onGameEndedHandler);
			_state = null;
			this.removeChildren();
			_staticButtons.removeChildren();
			_staticButtons = null;
			for (var i:int = 0; i < _buttons.length; i++)
			{
				_buttons[i].dispose();
				_buttons[i] = null;
			}
			
		}
	}
}
