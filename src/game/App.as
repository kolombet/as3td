package game
{
	import feathers.themes.MetalWorksDesktopTheme;
	import feathers.themes.MinimalDesktopTheme;
	
	import flash.ui.Keyboard;
	
	import game.model.GameSpeedController;
	import game.model.PlayState;
	import game.model.Pools;
	import game.model.utils.Console;
	import game.model.utils.KeyHelper;
	import game.view.GameView;
	
	import grid.CellGraphics;
	
	import starling.animation.IAnimatable;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	
	public class App extends Sprite implements IAnimatable
	{
		public static var resources:Resources;
		public static var cells:CellGraphics;
		public static var instance:App;
		
		private var state:PlayState;
		private var view:GameView;
		private var _currentLevelID:int;
		private var _isRecreating:Boolean = false;
		
		public function App()
		{
			if (instance)
			{
				throw new Error("singleton error");
			}
			instance = this;
			new MetalWorksDesktopTheme();
			
			new Pools();
			resources = new Resources();
			resources.init();
			cells = new CellGraphics();
			
			Main.loadProgress.parent.removeChild(Main.loadProgress);
			Main.loadProgress = null;
			
			_currentLevelID = 0;
			resources.loadLevel(_currentLevelID, onLevelLoaded);
			
			KeyHelper.init(Starling.current.nativeStage);
			KeyHelper.add(Keyboard.R, restartLevel);
			KeyHelper.add(Keyboard.S, increaseGameSpeed);
			
			GameSpeedController.initialize();
			Starling.juggler.add(this);
		}
		
		private function increaseGameSpeed():void
		{
			Starling.speedMultiplier = 100;
		}
		
		private function onLevelLoaded():void
		{
			Console.log("level " + _currentLevelID + " loaded");
			startLevel(_currentLevelID);
		}
		
		public function clearLevel():void
		{
			_isRecreating = true;
			if (view != null)
			{
				view.destroy();
				view = null;
			}
			if (state != null)
			{
				state.destroy();
				state = null;
			}
		}
		
		public function restartLevel():void
		{
			clearLevel();
			startLevel(_currentLevelID);
		}
		
		public function startLevel(levelID:int):void
		{
			state = new PlayState(levelID);
			state.onGameEnded.addOnce(onGameEndedHandler);
			view = new GameView(this);
			view.load(state);
			state.init();
			_isRecreating = false;
		}
		
		private function onGameEndedHandler():void
		{
			clearLevel();
			startLevel(_currentLevelID);
		}
		
		public static function getScene():Sprite
		{
			return instance.view.scene;
		}
		
		public function advanceTime(time:Number):void
		{
			if (_isRecreating == true)
				return;
			
			if (state)
			{
				state.advanceTime(time);
			}
			if (view)
			{
				view.advanceTime(time);
			}
		}
	}
}
