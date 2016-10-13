package grid
{
	import flash.geom.Point;
	
	import game.model.Config;
	import game.model.IDestroyable;
	import game.model.ISaveLoadable;
	import game.model.PlayState;
	
	public class TileData implements ISaveLoadable, IDestroyable
	{
		private var _state:PlayState;
		/**
		 * look TileType
		 */
		private var _tileType:Number;
		/**
		 * Can creeps pass this tile
		 */
		private var _isOccupied:Boolean;
		/**
		 * X in tiles
		 */
		public var gridX:int;
		/**
		 * Y in tiles
		 */
		public var gridY:int;
		/**
		 * Center x
		 */
		public var cx:int;
		/**
		 * Center y
		 */
		public var cy:int;
	
		
		public function TileData(state:PlayState)
		{
			_state = state;
		}
		
		public static function create(_state:PlayState, gridX:int, gridY:int):TileData
		{
			var tile:TileData = new TileData(_state);
			tile.init(gridX, gridY);
			return tile;
		}
		
		public function init(gridX:int, gridY:int):TileData
		{
			this.gridX = gridX;
			this.gridY = gridY;
			calculate();
			tileType = TileType.FREE;
			return this;
		}
		
		public function calculate():void
		{
			this.gridX = gridX;
			this.gridY = gridY;
			cx = (gridX + .5) * Config.TILE_SIZE;
			cy = (gridY + .5) * Config.TILE_SIZE;
		}
		
		public function get tileType():Number
		{
			return _tileType;
		}
		
		public function set tileType(value:Number):void
		{
			if (value == _tileType)
				return;
			
			_isOccupied = (value == TileType.BUILD || value == TileType.BLOCKED);
			_tileType = value;
			if (_state.map)
			{
				_state.map.onMapDataChanged.dispatch();
			}
		}
		
		public function get isOccupied():Boolean
		{
			return _isOccupied;
		}
		
		public function save():Object
		{
			var save:Object = {};
			save.gridX = gridX;
			save.gridY = gridY;
			save.tileType = _tileType;
			return save;
		}
		
		public function load(data:Object):void
		{
			gridX = data.gridX;
			gridY = data.gridY;
			tileType = data.tileType;
			calculate();
		}
		
		public function destroy():void
		{
			_state = null;
		}
		
		public function getDepth():int
		{
			return gridX + gridY;
		}
	}
}
