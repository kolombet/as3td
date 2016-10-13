package grid
{
	import com.yyztom.pathfinding.astar.AStar;
	import com.yyztom.pathfinding.astar.AStarNodeVO;
	
	import flash.geom.Point;
	
	import game.model.IDestroyable;
	
	public class PassModel implements IDestroyable
	{
		private var _astar:AStar;
		private var _aStarNodes:Vector.<Vector.<AStarNodeVO>>;
		private var _grid:Vector.<Vector.<TileData>>;
		
		public function PassModel()
		{
		}
		
		public function getPath(startTile:TileData, endTile:TileData):Vector.<TileData>
		{
			var size:int = _aStarNodes[0].length;
			var path:Vector.<AStarNodeVO>;
			var startNode:AStarNodeVO = _aStarNodes[startTile.gridX][startTile.gridY];
			var endNode:AStarNodeVO = _aStarNodes[endTile.gridX][endTile.gridY];
			path = _astar.search(startNode, endNode);
			
			var pathData:Vector.<TileData> = new Vector.<TileData>();
			for (var i:int = 0; i < path.length; i++)
			{
				var p:Point = path[i].position;
				pathData.push(_grid[p.x][p.y]);
			}
			return pathData;
		}
		
		public function init(grid:Vector.<Vector.<TileData>>):void
		{
			_grid = grid;
			initNodesForAStar();
			_astar = new AStar(_aStarNodes);
		}
		
		private function initNodesForAStar():void
		{
			_aStarNodes = new Vector.<Vector.<AStarNodeVO>>();
			
			var x:uint = 0;
			var z:uint = 0;
			
			while (x < _grid.length)
			{
				_aStarNodes[x] = new Vector.<AStarNodeVO>();
				
				while (z < _grid[x].length)
				{
					var tile:TileData = _grid[x][z];
					var node:AStarNodeVO = new AStarNodeVO();
					node.h = 0;
					node.f = 0;
					node.g = 0;
					node.visited = false;
					node.parent = null;
					node.closed = false;
					node.isWall = tile.isOccupied;
					node.position = new Point(x, z);
					_aStarNodes[x][z] = node;
					
					z++;
				}
				z = 0;
				x++;
			}
		}
		
		public function destroy():void
		{
			_astar = null;
			_aStarNodes = null;
			_grid = null;
		}
	}
}
