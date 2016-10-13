package game.model.utils
{
	import game.model.ISaveLoadable;
	import game.model.PlayState;
	
	import grid.TileData;
	
	public class Save
	{
		public function Save()
		{
		}
		
		public static function save2dTileData(data:Vector.<Vector.<TileData>>):Object
		{
			var result:Array = [];
			for (var x:int = 0; x < data.length; x++)
			{
				var columnToSave:Vector.<TileData> = data[x];
				var columnResult:Array = [];
				for (var y:int = 0; y < columnToSave.length; y++)
				{
					columnResult.push((columnToSave[y] as ISaveLoadable).save());
				}
				result.push(columnResult);
			}
			return result;
		}
		
		public static function load2dTileData(state:PlayState, data:Array):Vector.<Vector.<TileData>>
		{
			var result:Vector.<Vector.<TileData>> = new Vector.<Vector.<TileData>>();
			for (var x:int = 0; x < data.length; x++)
			{
				var columnToLoad:Array = data[x];
				var columnResult:Vector.<TileData> = new Vector.<TileData>();
				for (var y:int = 0; y < columnToLoad.length; y++)
				{
					var tdata:TileData = new TileData(state);
					tdata.load(columnToLoad[y]);
					columnResult.push(tdata);
				}
				result.push(columnResult);
			}
			return result;
		}
		
		public static function saveVectTileData(data:Vector.<TileData>):Object
		{
			var result:Array = [];
			for (var i:int = 0; i < data.length; i++)
			{
				var res:Object = (data[i] as ISaveLoadable).save();
				result.push(res);
			}
			return result;
		}
		
		public static function loadVectTileData(state:PlayState, data:Array):Vector.<TileData>
		{
			var result:Vector.<TileData> = new Vector.<TileData>();
			for (var i:int = 0; i < data.length; i++)
			{
				var res:TileData = new TileData(state);
				res.load(data[i]);
				result.push(res);
			}
			return result;
		}
	}
}
