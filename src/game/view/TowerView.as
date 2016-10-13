package game.view
{
	
	import flash.geom.Point;
	
	import game.App;
	import game.model.IGameObj;
	import game.model.IsoTransform;
	import game.model.Pools;
	import game.model.towers.BaseTowerData;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class TowerView extends Sprite implements IGameView
	{
		private var _towerData:BaseTowerData;
		
		public function TowerView(towerData:BaseTowerData)
		{
			_towerData = towerData;
			var img:Image = App.resources.getTowerByData(_towerData);
			addChild(img);
		}
		
		public function advanceTime(time:Number):void
		{
			var p:Point = IsoTransform.fromP(_towerData.coords);
			this.x = p.x;
			this.y = p.y;
			Pools.point.object = p;
		}
		
		public function getData():IGameObj
		{
			return _towerData;
		}
		
		public function destroy():void
		{
			_towerData = null;
			removeChildren();
		}
	}
}
