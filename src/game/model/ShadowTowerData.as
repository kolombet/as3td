package game.model
{
	import game.model.towers.BaseTowerData;
	
	import grid.TileData;
	
	import grid.TileData;
	
	public class ShadowTowerData implements IGameObj
	{
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _state:PlayState;
		private var _buildingTowerData:BaseTowerData;
		private var _isAbleToBuild:Boolean;
		private var _buildTile:TileData;
		
		public function ShadowTowerData(state:PlayState, towerFactory:Function)
		{
			_state = state;
			_buildingTowerData = towerFactory(_state);
		}
		
		public function get depth():int
		{
			var tile:TileData = _state.map.getTileByCoords(x, y);
			if (tile == null)
			{
				return null;
			}
			return tile.getDepth();
		}
		
		public function destroy():void
		{
			_state = null;
		}
		
		public function advanceTime(time:Number):void
		{
			
		}
		
		public function get x():Number
		{
			return _x;
		}
		
		public function set x(value:Number):void
		{
			_x = value;
		}
		
		public function get y():Number
		{
			return _y;
		}
		
		public function set y(value:Number):void
		{
			_y = value;
		}
		
		public function get buildingTowerData():BaseTowerData
		{
			return _buildingTowerData;
		}
		
		public function findNearestLocation(x:Number, y:Number):void
		{
			_buildTile = _state.map.getTileByCoords(x, y);
			if (_buildTile != null && _state.towerManager.isAbleToBuildTower(_buildTile))
			{
				this.x = _buildTile.cx;
				this.y = _buildTile.cy;
				_isAbleToBuild = _state.towerManager.isAbleToBuildTower(_buildTile);
			}
			else
			{
				this.x = x;
				this.y = y;
			}
		}
		
		public function get isAbleToBuild():Boolean
		{
			return _isAbleToBuild;
		}
		
		public function get buildTile():TileData
		{
			return _buildTile;
		}
	}
}
