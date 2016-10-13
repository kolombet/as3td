package game.view
{
	import feathers.controls.ImageLoader;
	
	import flash.utils.Dictionary;
	
	import game.model.BaseCreepData;
	import game.model.Config;
	import game.model.IDestroyable;
	import game.model.IGameObj;
	import game.model.PlayState;
	import game.model.ShadowTowerData;
	import game.model.bullets.BasicBulletData;
	import game.model.mode.BaseMode;
	import game.model.mode.BuildTowerMode;
	import game.model.mode.EditorMode;
	import game.model.towers.BaseTowerData;
	
	import grid.GridView;
	
	import starling.animation.IAnimatable;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	
	public class GameView implements IAnimatable, IDestroyable
	{
		private var _topView:Sprite;
		private var _scene:Sprite;
		private var _state:PlayState;
		private var _gridView:GridView;
		private var _viewsD:Dictionary;
		private var _viewsV:Vector.<IGameView>;
		private var _background:ImageLoader;
		private var _gameUI:GameUI;
		private var _currentMode:BaseMode;
		private var _gameObjectsLayer:Sprite;
		private var _shadowTower:ShadowTowerView;
		
		public function GameView(topView:Sprite)
		{
			_topView = topView;
			_viewsD = new Dictionary(true);
			_viewsV = new Vector.<IGameView>();
			_scene = new Sprite();
			_gameObjectsLayer = new Sprite();
			_background = new ImageLoader();
			_gridView = new GridView();
			_gameUI = new GameUI();
			
			_topView.addChild(_scene);
			_scene.addChild(_background);
			_scene.addChild(_gridView);
			_scene.addChild(_gameObjectsLayer);
			_topView.addChild(_gameUI);
		}
		
		private function onModeActivated(mode:BaseMode):void
		{
			_currentMode = mode;
			if (mode is EditorMode || mode is BuildTowerMode)
			{
				_gridView.visible = true;
			}
			else
			{
				_gridView.visible = false;
			}
			_gridView.setMode(mode);
			_gridView.updateGrid(_state.map);
			
			if (_shadowTower != null)
			{
				objectRemoved(_shadowTower.getData());
				_shadowTower = null;
			}
			if (mode is BuildTowerMode)
			{
				var m:BuildTowerMode = mode as BuildTowerMode;
				objectAdded(m.shadowTowerData);
			}
		}
		
		private function onMapDataChanged():void
		{
			if (_currentMode is EditorMode || _currentMode is BuildTowerMode)
			{
				_gridView.updateGrid(_state.map);
			}
		}
		
		private function objectAdded(obj:IGameObj):void
		{
			var view:IGameView;
			if (obj is BaseTowerData)
			{
				view = new TowerView(obj as BaseTowerData);
			}
			else if (obj is BaseCreepData)
			{
				view = new CreepView(obj as BaseCreepData);
			}
			else if (obj is BasicBulletData)
			{
				view = new BulletView(obj as BasicBulletData);
			}
			else if (obj is ShadowTowerData)
			{
				view = new ShadowTowerView(obj as ShadowTowerData);
				_shadowTower = view as ShadowTowerView;
			}
			_viewsV.push(view);
			_viewsD[obj] = view;
			_gameObjectsLayer.addChild(view as DisplayObject);
		}
		
		private function objectRemoved(obj:IGameObj):void
		{
			if (_viewsD == null)
				return;
			var view:IGameView = _viewsD[obj];
			view.destroy();
			_viewsV.removeAt(_viewsV.indexOf(view));
			delete _viewsD[obj];
			_gameObjectsLayer.removeChild(view as DisplayObject)
		}
		
		public function clear():void
		{
			_state = null;
		}
		
		public function get scene():Sprite
		{
			return _scene;
		}
		
		public function advanceTime(time:Number):void
		{
			for (var i:int = 0; i < _viewsV.length; i++)
			{
				_viewsV[i].advanceTime(time);
			}
		}
		
		private function depthSort():void
		{
			_gameObjectsLayer.sortChildren(sort);
			function sort(first:Object, second:Object):int
			{
				var f:IGameView = first as IGameView;
				var s:IGameView = second as IGameView;
				return (f.getData().depth > s.getData().depth) ? 1 : -1;
			}
		}
		
		public function load(state:PlayState):void
		{
			_state = state;
			
			_state.towerManager.onTowerSpawned.add(objectAdded);
			_state.creepManager.onCreepSpawned.add(objectAdded);
			_state.creepManager.onCreepKilled.add(objectRemoved);
			_state.creepManager.onCreepPassed.add(objectRemoved);
			_state.bulletManager.onBulletSpawned.add(objectAdded);
			_state.bulletManager.onBulletDestroyed.add(objectRemoved);
			_state.map.onMapDataChanged.add(onMapDataChanged);
			_state.modeActivated.add(onModeActivated);
			_state.tick.add(depthSort);
			
			_background.x = - Config.SCENE_SHIFT;
			_scene.x = Config.SCENE_SHIFT;
			
			_gameUI.init(state);
			
			_state.activateNormal();
			
			var backgroundURL:String = state.map.backgroundURL;
			if (backgroundURL && backgroundURL.length > 0)
			{
				_background.source = backgroundURL;
			}
		}
		
		public function destroy():void
		{
			_state.towerManager.onTowerSpawned.remove(objectAdded);
			_state.creepManager.onCreepSpawned.remove(objectAdded);
			_state.creepManager.onCreepKilled.remove(objectRemoved);
			_state.creepManager.onCreepPassed.remove(objectRemoved);
			_state.bulletManager.onBulletSpawned.remove(objectAdded);
			_state.bulletManager.onBulletDestroyed.remove(objectRemoved);
			_state.map.onMapDataChanged.remove(onMapDataChanged);
			_state.modeActivated.remove(onModeActivated);
			_state.tick.add(depthSort);
			
			_topView.removeChildren();
			_scene.removeChildren();
			_gameObjectsLayer.removeChildren();
			_gameUI.removeChildren();
			_topView = null;
			_scene = null;
			_state = null;
			_gridView.destroy();
			_gridView = null;
			for (var i:int = 0; i < _viewsV.length; i++)
			{
				_viewsV[i].destroy();
				delete _viewsV[i];
			}
			_viewsD = null;
			_viewsV = null;
			_background.dispose();
			_gameUI = null;
			_currentMode = null;
			_gameObjectsLayer = null;
		}
	}
}
