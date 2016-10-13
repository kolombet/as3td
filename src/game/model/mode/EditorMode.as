package game.model.mode
{
	import flash.geom.Point;
	
	import game.App;
	import game.model.IsoTransform;
	import game.model.PlayState;
	import game.model.Pools;
	
	import grid.TileData;
	
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class EditorMode extends BaseMode
	{
		private var _scene:Sprite;
		private var _state:PlayState;
		private var _currentPoint:Point;
		
		public function EditorMode()
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
						break;
					
					case TouchPhase.ENDED:
						if (_currentPoint == null)
							return;
						var isoCoords:Point = IsoTransform.toP(_currentPoint);
						var tile:TileData = _state.map.getTileByCoords(isoCoords.x, isoCoords.y);
						Pools.point.object = isoCoords;
						if (tile != null)
						{
							_state.map.switchTile(tile);
						}
						break;
					
					case TouchPhase.MOVED:
						break;
					
					case TouchPhase.HOVER:
						_currentPoint = touch.getLocation(_scene);
						break;
				}
			}
		}
		
		override public function activate(state:PlayState, data:Object = null):void
		{
			_state = state;
			_scene = App.getScene();
			_scene.addEventListener(TouchEvent.TOUCH, onStageTouch);
		}
		
		override public function deactivate():void
		{
			_scene.removeEventListener(TouchEvent.TOUCH, onStageTouch);
		}
	}
}
