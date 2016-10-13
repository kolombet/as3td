package game.model.mode
{
	import flash.geom.Point;
	
	import game.App;
	import game.model.IsoTransform;
	import game.model.PlayState;
	import game.model.Pools;
	import game.model.ShadowTowerData;
	import game.model.towers.BaseTowerData;
	import game.model.utils.Console;
	
	import grid.TileData;
	import grid.TileType;
	
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class BuildTowerMode extends BaseMode
	{
		private var _scene:Sprite;
		private var _state:PlayState;
		private var _currentPoint:Point;
		private var _towerFactory:Function;
		private var _shadowTowerData:ShadowTowerData;
		
		public function BuildTowerMode()
		{
		}
		
		public function onStageTouch(evt:TouchEvent):void
		{
			var touch:Touch = evt.getTouch(_scene);
			if (touch)
			{
				switch (touch.phase)
				{
					case TouchPhase.BEGAN:
						if (_currentPoint == null)
							return;
						tryToBuild(_shadowTowerData.buildTile);
						break;
					
					case TouchPhase.ENDED:
						break;
					
					case TouchPhase.MOVED:
						break;
					
					case TouchPhase.HOVER:
						_currentPoint = touch.getLocation(_scene);
						var p:Point = IsoTransform.toP(_currentPoint);
						_shadowTowerData.findNearestLocation(p.x, p.y);
						Pools.point.object = _currentPoint;
						break;
				}
			}
		}
		
		
		private function tryToBuild(tile:TileData):void
		{
			if (tile != null && tile.tileType == TileType.BUILD)
			{
				var tower:BaseTowerData = _towerFactory(_state);
				var res:Boolean = _state.towerManager.buildTowerByTile(tile, tower);
				if (res == true)
				{
					Console.debug("builded tower");
					_state.activateNormal();
				}
				else
				{
					Console.debug("not builded");
				}
			}
		}
		
		override public function activate(state:PlayState, data:Object = null):void
		{
			_state = state;
			_towerFactory = data as Function;
			_scene = App.getScene();
			_scene.addEventListener(TouchEvent.TOUCH, onStageTouch);
			_shadowTowerData = new ShadowTowerData(_state, _towerFactory);
		}
		
		override public function deactivate():void
		{
			_scene.removeEventListener(TouchEvent.TOUCH, onStageTouch);
		}
		
		public function get shadowTowerData():ShadowTowerData
		{
			return _shadowTowerData;
		}
	}
}
