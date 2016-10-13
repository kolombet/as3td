package game.model.managers
{
	import game.model.IDestroyable;
	import game.model.PlayState;
	import game.model.towers.BaseTowerData;
	import game.model.utils.Console;
	
	import grid.TileData;
	import grid.TileType;
	
	import org.osflash.signals.Signal;
	
	import starling.animation.IAnimatable;
	
	public class TowerManager implements IDestroyable, IAnimatable
	{
		private var _state:PlayState;
		private var _collection:Vector.<BaseTowerData>;
		private var _onTowerSpawned:Signal;
		
		public function TowerManager(state:PlayState)
		{
			_collection = new Vector.<BaseTowerData>();
			_onTowerSpawned = new Signal(BaseTowerData);
			_state = state;
		}
		
		public function advanceTime(time:Number):void
		{
			var uid:String = _state.uid;
			for (var i:int = 0, l:int = _collection.length; i<l; i++)
			{
				_collection[i].advanceTime(time);
			}
		}
		
		public function buildTowerByCoords(tower:BaseTowerData, coordX:int, coordY:int):Boolean
		{
			var targetTile:TileData = _state.map.data[coordX][coordY];
			if (targetTile != null)
			{
				return buildTowerByTile(targetTile, tower);
			}
			return false;
		}
		
		public function isAbleToBuildTower(targetTile:TileData):Boolean
		{
			return (targetTile.tileType == TileType.BUILD);
		}
		
		public function buildTowerByTile(targetTile:TileData, tower:BaseTowerData):Boolean
		{
			if (isAbleToBuildTower(targetTile));
			
			if (_state.money < tower.price)
			{
				Console.debug("not enough money");
				return false;
			}
			_state.money -= tower.price;
			
			targetTile.tileType = TileType.BUILD_BLOCKED;
			tower.targetTile = targetTile;
			tower.x = targetTile.cx;
			tower.y = targetTile.cy;
			_onTowerSpawned.dispatch(tower);
			_collection.push(tower);
			
			blockTile(targetTile.gridX + 1, targetTile.gridY - 1);
			blockTile(targetTile.gridX + 1, targetTile.gridY);
			blockTile(targetTile.gridX + 1, targetTile.gridY + 1);
			blockTile(targetTile.gridX, targetTile.gridY + 1);
			blockTile(targetTile.gridX - 1, targetTile.gridY + 1);
			blockTile(targetTile.gridX - 1, targetTile.gridY);
			blockTile(targetTile.gridX - 1, targetTile.gridY - 1);
			blockTile(targetTile.gridX, targetTile.gridY - 1);
			return true;
		}
		
		private function blockTile(targetX:int, targetY:int):void
		{
			var tile:TileData = _state.map.data[targetX][targetY];
			tile.tileType = TileType.BUILD_BLOCKED;
		}
		
		public function destroy():void
		{
			_state = null;
			for (var i:int = 0; i < _collection.length; i++)
			{
				_collection[i].destroy();
			}
			_onTowerSpawned.removeAll();
			_onTowerSpawned = null;
		}
		
		public function get onTowerSpawned():Signal
		{
			return _onTowerSpawned;
		}
		
		
	}
}
