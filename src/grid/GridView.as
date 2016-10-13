package grid
{
	import flash.geom.Point;
	
	import game.App;
	import game.model.IDestroyable;
	import game.model.IsoTransform;
	import game.model.Config;
	import game.model.Pools;
	import game.model.mode.BaseMode;
	import game.model.utils.Console;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class GridView extends Sprite implements IDestroyable
	{
		private var _cells:Vector.<Vector.<Image>>;
		private var _mode:BaseMode;
		
		public function GridView()
		{
		}
		
		public function setMode(mode:BaseMode):void
		{
			_mode = mode;
		}
		
		/**
		 * Update images to match cell content
		 */
		public function updateGrid(map:MapData):void
		{
			if (_cells == null)
			{
				init(map);
				return;
			}
			for (var x:int = 0; x < map.size; x++)
			{
				for (var y:int = 0; y < map.size; y++)
				{
					var tile:TileData = map.data[x][y];
					var tileView:Image = _cells[x][y];
					var texture:Texture = App.cells.getByTileType(tile.tileType, _mode);
					var isVisible:Boolean = (texture != null);
					tileView.visible = isVisible;
					if (texture != null)
					{
						tileView.texture = texture;
					}
					_cells[x][y] = tileView;
				}
			}
		}
		
		/**
		 * Create images for all tiles.
		 */
		private function init(map:MapData):void
		{
			var columns:Vector.<Vector.<Image>> = new Vector.<Vector.<Image>>();
			for (var x:int = 0; x < map.size; x++)
			{
				var row:Vector.<Image> = new Vector.<Image>();
				for (var y:int = 0; y < map.size; y++)
				{
					var tile:TileData = map.data[x][y];
					var tileView:Image;
					var texture:Texture = App.cells.getByTileType(tile.tileType, _mode);
					tileView = drawTile(tile, texture);
					row.push(tileView);
				}
				columns.push(row)
			}
			_cells = columns;
		}
		
		private function drawTile(tile:TileData, texture:Texture):Image
		{
			var isVisible:Boolean = true;
			if (texture == null) 
			{
				isVisible = false;
				texture = App.cells.emptyCellTexture;
			}
			Console.info("draw tile " + tile.gridX + " x " + tile.gridY);
			var tileView:Image = new Image(texture);
			tileView.visible = isVisible;
			tileView.pivotX = Config.TILE_SIZE;
			tileView.pivotY = Config.TILE_SIZE_HALF;
			var p:Point = Pools.point.object;
			p.x = tile.cx;
			p.y = tile.cy;
			p = IsoTransform.fromP(p);
			tileView.x = p.x;
			tileView.y = p.y;
			Pools.point.object = p;
			
			addChild(tileView);
			return tileView;
		}
		
		public function destroy():void
		{
			_mode = null;
			for (var i:int = 0; i< _cells.length; i++)
			{
				for (var j:int =0; j< _cells[i].length; j++)
				{
					_cells[i][j].dispose();
					_cells[i][j] = null;
				}
			}
			_cells = null;
		}
	}
}
