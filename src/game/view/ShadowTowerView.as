package game.view
{
	import flash.geom.Point;
	
	import game.App;
	import game.model.IGameObj;
	import game.model.IsoTransform;
	import game.model.Pools;
	import game.model.ShadowTowerData;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class ShadowTowerView extends Sprite implements IGameView
	{
		private var _data:ShadowTowerData;
		
		public function ShadowTowerView(shadowTowerData:ShadowTowerData)
		{
			var img:Image = App.resources.getTowerByData(shadowTowerData.buildingTowerData);
			touchable = false;
			img.touchable = false;
			addChild(img);
			
			_data = shadowTowerData;
		}
		
		public function getData():IGameObj
		{
			return _data;
		}
		
		public function advanceTime(time:Number):void
		{
			var p:Point = IsoTransform.fromP(new Point(_data.x, _data.y));
			this.x = p.x;
			this.y = p.y;
			Pools.point.object = p;
			this.alpha = (_data.isAbleToBuild) ? .6 : .2;
		}
		
		public function destroy():void
		{
			_data = null;
		}
	}
}
