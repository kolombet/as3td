package grid
{
	import game.model.Config;
	import game.model.IDestroyable;
	import game.model.ISaveLoadable;
	import game.model.PlayState;
	import game.model.utils.Console;
	import game.model.utils.Save;
	
	import org.osflash.signals.Signal;
	
	public class MapData implements ISaveLoadable, IDestroyable
	{
		private var _state:PlayState;
		private var _backgroundURL:String;
		private var _size:int;
		private var _data:Vector.<Vector.<TileData>>;
		private var _base:TileData;
		private var _spawnPoints:Vector.<TileData>;
		private var _roads:Vector.<Vector.<TileData>>;
		private var _onMapDataChanged:Signal = new Signal();
		
		/**
		 * @param size размер карты
		 */
		public function MapData(state:PlayState)
		{
			_state = state;
			backgroundURL = Config.BACKGROUND_RES + _state.levelID + Config.RES_FORMAT;
			Console.log("map url: " + backgroundURL);
		}
		
		public function getTileByCoords(x:Number, y:Number):TileData
		{
			var xTile:int = x / Config.TILE_SIZE;
			var yTile:int = y / Config.TILE_SIZE;
			var tile:TileData;
			if (xTile > 0 && xTile < _data.length)
			{
				var column:Vector.<TileData> = _data[xTile];
				if (yTile > 0 && yTile < column.length)
				{
					tile = column[yTile];
				}
			}
			return tile;
		}
		
		public function switchTile(tile:TileData):void
		{
			if (tile == null)
			{
				return;
			}
			tile.tileType = TileType.getNext(tile.tileType);
			_onMapDataChanged.dispatch();
		}
		
		public function save():Object
		{
			var obj:Object = {};
			obj.size = _size;
			obj.data = Save.save2dTileData(_data);
			obj.base = _base.save();
			obj.spawnPoints = Save.saveVectTileData(_spawnPoints);
			return obj;
		}
		
		public function load(data:Object):void
		{
			this._size = data.size;
			this._data = Save.load2dTileData(_state, data.data);
			_base = new TileData(_state);
			_base.load(data.base);
			this._spawnPoints = Save.loadVectTileData(_state, data.spawnPoints);
			
			//roadCheck();
		}
		
		public function calculateRoads(passModel:PassModel):void
		{
			_roads = new Vector.<Vector.<TileData>>();
			for (var i:int = 0; i < _spawnPoints.length; i++)
			{
				var path:Vector.<TileData> = _state.passModel.getPath(spawnPoints[i], base);
				_roads.push(path);
			}
		}
		
		/**
		 * Private
		 */
		private function generateDummyData(size:int):Vector.<Vector.<TileData>>
		{
			var tileGridData:Vector.<Vector.<TileData>> = new Vector.<Vector.<TileData>>(size, true);
			for (var x:int = 0; x < size; x++)
			{
				var column:Vector.<TileData> = new Vector.<TileData>();
				for (var y:int = 0; y < size; y++)
				{
					var tile:TileData = TileData.create(_state, x, y);
					column[y] = tile;
				}
				tileGridData[x] = column;
			}
			return tileGridData;
		}
		
		private function drawZone(sx:int, sy:int, sizeX:int, sizeY:int = 0):void
		{
			if (sizeY == 0)
			{
				sizeY = sizeX;
			}
			
			for (var x:int = sx; x < sx + sizeX; x++)
			{
				for (var y:int = sy; y < sy + sizeY; y++)
				{
					_data[x][y].tileType = TileType.BUILD;
				}
			}
		}
		
		private function roadCheck():void
		{
			for (var x:int = 0; x < this._data.length; x++)
			{
				var column:Vector.<TileData> = this._data[x];
				for (var y:int = 0; y < column.length; y++)
				{
					if (column[y].tileType == TileType.BUILD)
					{
						var isNearRoad:Boolean = checkIsNearRoad(column[y]);
						if (isNearRoad)
						{
							column[y].tileType = TileType.BUILD_BLOCKED;
						}
					}
				}
			}
		}
		
		private function checkIsNearRoad(targetTile:TileData):Boolean
		{
			var checks:Array = [
				checkIsRoad(targetTile.gridX + 1, targetTile.gridY - 1),
				checkIsRoad(targetTile.gridX + 1, targetTile.gridY),
				checkIsRoad(targetTile.gridX + 1, targetTile.gridY + 1),
				checkIsRoad(targetTile.gridX, targetTile.gridY + 1),
				checkIsRoad(targetTile.gridX - 1, targetTile.gridY + 1),
				checkIsRoad(targetTile.gridX - 1, targetTile.gridY),
				checkIsRoad(targetTile.gridX - 1, targetTile.gridY - 1),
				checkIsRoad(targetTile.gridX, targetTile.gridY - 1)
			];
			for (var i:int = 0; i<checks.length; i++)
			{
				if (checks[i] == true)
				{
					return true;
				}
			}
			return false;
		}
		
		private function checkIsRoad(tileX:int, tileY:int):Boolean
		{
			if (tileX < 0 || tileY < 0 || tileX >= _size || tileY >= _size)
					return false;
			return data[tileX][tileY].tileType == TileType.FREE;
		}
		
		public function get backgroundURL():String
		{
			return _backgroundURL;
		}
		
		public function set backgroundURL(value:String):void
		{
			_backgroundURL = value;
		}
		
		public function get size():int
		{
			return _size;
		}
		
		public function get data():Vector.<Vector.<TileData>>
		{
			return _data;
		}
		
		public function get base():TileData
		{
			return _base;
		}
		
		public function get spawnPoints():Vector.<TileData>
		{
			return _spawnPoints;
		}
		
		public function get onMapDataChanged():Signal
		{
			return _onMapDataChanged;
		}
		
		/**
		 * DEV
		 */
		private function initDummy():void
		{
			_data = generateDummyData(_size);
			drawZone(5, 10, 5);
			drawZone(5, 5, 5);
			drawZone(10, 5, 5);
			drawZone(20, 3, 5, 20);
			
			_base = _data[13][3];
			_base.tileType = TileType.FREE;
			
			_spawnPoints = new Vector.<TileData>();
			_spawnPoints.push(_data[18][27]);
			_spawnPoints.push(_data[25][19]);
		}
		
		public function get roads():Vector.<Vector.<TileData>>
		{
			return _roads;
		}
		
		public function destroy():void
		{
			_state = null;
			for (var x:int = 0; x < _data.length; x++)
			{
				var column:Vector.<TileData> = data[x];
				for (var y:int = 0; y < column.length; y++)
				{
					column[y].destroy();
				}
			}
			_data = null;
			_base.destroy();
			_base = null;
			for each (var tile:TileData in _spawnPoints)
			{
				tile.destroy();
			}
			_spawnPoints = null;
			for (var i:int = 0; i < roads.length; i++)
			{
				var cur:Vector.<TileData> = roads[i];
				for (var j:int = 0; j < cur.length; j++)
				{
					cur[j].destroy();
				}
			}
			_roads = null;
			_onMapDataChanged.removeAll();
			_onMapDataChanged = null
		}
	}
}
