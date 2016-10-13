package grid
{
	import game.App;
	import game.model.Config;
	import game.model.mode.BuildTowerMode;
	import game.model.mode.EditorMode;
	import game.model.mode.IMode;
	import game.model.mode.NormalMode;
	
	import starling.textures.Texture;
	
	public class CellGraphics
	{
		public var emptyCellTexture:Texture; //Green empty
		public var readyToBuildCellTexture:Texture; //Green filled
		public var blockedCellTexture:Texture; //Red filled
		public var noCellTexture:Texture; //Cell not active
		
		private static const GREEN:String = "green";
		private static const BLUE:String = "blue";
		private static const GREY:String = "grey";
		private static const RED:String = "red";
		private static const EMPTY:String = "empty";
		
		public function CellGraphics()
		{
			//drawTextures();
			getTexturesFromAtlas();
		}
		
		private function drawTextures():void
		{
			var emptyCell:GridCell = new GridCell();
			emptyCell.drawEmptyTile();
			emptyCellTexture = emptyCell.getTexture();
			
			var rtb:GridCell = new GridCell();
			rtb.drawTile(0x00ff00, true, 0x00ff00);
			readyToBuildCellTexture = rtb.getTexture();
			
			var blocked:GridCell = new GridCell();
			blocked.drawTile(0xff0000, true, 0xff0000);
			blockedCellTexture = blocked.getTexture();
			
			noCellTexture = Texture.empty(Config.ISO_TILE_WIDTH, Config.ISO_TILE_HEIGHT);
		}
		
		private function getTexturesFromAtlas():void 
		{
			emptyCellTexture = App.resources.getTileTexture(GREEN, true);
			readyToBuildCellTexture = App.resources.getTileTexture(GREEN, false);
			blockedCellTexture = App.resources.getTileTexture(RED, false);
			noCellTexture = App.resources.getTileTexture(EMPTY, false);
		}
		
		public function getByTileType(type:int, mode:IMode):Texture
		{
			if (mode is EditorMode)
			{
				return tileByTypeEditor(type)
			}
			else if (mode is BuildTowerMode)
			{
				return tileByTypeBuild(type);
			}
			//else if (mode is NormalMode)
			//{
			//	return noCellTexture;
			//}
			return null;
		}
		
		private function tileByTypeEditor(type:int):Texture
		{
			if (type == TileType.FREE)
			{
				return emptyCellTexture;
			}
			else if (type == TileType.BUILD || type == TileType.BUILD_BLOCKED)
			{
				return readyToBuildCellTexture;
			}
			else if (type == TileType.BLOCKED)
			{
				return blockedCellTexture;
			}
			else
			{
				throw new Error("wrong tile type");
			}
		}
		
		private function tileByTypeBuild(type:int):Texture
		{
			if (type == TileType.FREE)
			{
				return noCellTexture;
			}
			else if (type == TileType.BUILD)
			{
				return readyToBuildCellTexture;
			}
			else if (type == TileType.BUILD_BLOCKED)
			{
				return blockedCellTexture;
			}
			else if (type == TileType.BLOCKED)
			{
				return noCellTexture;
			}
			else
			{
				throw new Error("wrong tile type");
			}
		}
	}
}
