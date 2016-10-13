package game
{
	import game.model.Config;
	import game.model.towers.AOETower;
	import game.model.towers.BaseTowerData;
	import game.model.towers.BasicTower;
	import game.model.towers.FrostTower;
	
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.AssetManager;
	
	/**
	 * ...
	 * @author kir
	 */
	public class Resources
	{
		private static const JSON:String = ".json";
		private static const COMPLETED:Number = 1;
		
		[Embed(source="../../atlas/creeps.xml", mimeType="application/octet-stream")]
		private static const AtlasXml:Class;
		[Embed(source="../../atlas/creeps.png")]
		private static const AtlasTexture:Class;
		
		private static var _instance:Resources;
		
		private var _atlas:TextureAtlas;
		private var _assets:AssetManager;
		private var _onLoadHandler:Function;
		
		public function Resources():void
		{
			if (_instance)
			{
				throw new Error("Singleton error");
			}
			_instance = this;
		}
		
		public function init():void
		{
			createAtlas();
		}
		
		public function loadLevel(levelID:int, onLoad:Function):void
		{
			_onLoadHandler = onLoad;
			_assets = new AssetManager();
			_assets.enqueue(Config.BASE_URL + Config.LEVEL_RES + levelID + JSON);
			_assets.enqueue(Config.BASE_URL + Config.WAVE_RES + levelID + JSON);
			_assets.loadQueue(onProgress);
			_assets.addEventListener(Event.IO_ERROR, onError);
			_assets.addEventListener(Event.PARSE_ERROR, onError);
		}
		
		private function onError(event:Event):void
		{
			throw new Error("Level resource not found: " + event.data.toString());
		}
		
		public function getMonsterAnimation(mname:String, type:String):MovieClip
		{
			var isRotated:Boolean = false;
			
			if (type.charAt(type.length - 1) == "R")
			{
				isRotated = true;
				type = type.replace("R", "L");
			}
			var movie:MovieClip = new MovieClip(_atlas.getTextures("creeps/"+ mname + "/" + type + "/"), 10);
			movie.pivotX = movie.width / 2;
			movie.pivotY = movie.height / 2;
			if (isRotated)
			{
				movie.scaleX = -1;
			}
			movie.loop = true;
			return movie;
		}
		
		public function getTower1():Image
		{
			return getCenterImage("towers/tower1");
		}
		
		public function getTower2():Image
		{
			return getCenterImage("towers/tower2");
		}
		
		public function getTower3():Image
		{
			return getCenterImage("towers/tower3");
		}
		
		public function getTowerByData(towerData:BaseTowerData):Image
		{
			var img:Image;
			if (towerData is BasicTower)
			{
				img = App.resources.getTower1();
				img.pivotY += img.height/3;
			}
			else if (towerData is AOETower)
			{
				img = App.resources.getTower2();
			}
			else if (towerData is FrostTower)
			{
				img = App.resources.getTower3();
			}
			img.scale = .6;
			return img;
		}
		
		public function getTileTexture(color:String, isEmpty:Boolean):Texture
		{
			var path:String = "tiles/";
			var emptyName:String = "Empty";
			path = path + color + (isEmpty ? emptyName : "");
			return _atlas.getTexture(path);
		}
		
		public function getBulletFire():Image
		{
			var image:Image = getCenterImage("bullets/shot3");
			image.scale = .2;
			return image;
		}
		
		public function getBulletAoeFire():Image
		{
			var image:Image = getCenterImage("bullets/shot3");
			return image;
		}	
			
		public function getBulletFrost():Image
		{
			var image:Image = getCenterImage("bullets/shot4");
			image.scale = .2;
			return image;
		}
		
		/***********
		 * Private
		 ***********/
		private function createAtlas():void
		{
			var texture:Texture = Texture.fromEmbeddedAsset(AtlasTexture);
			var xml:XML = XML(new AtlasXml());
			_atlas = new TextureAtlas(texture, xml);
		}
		
		private function onProgress(value:Number):void
		{
			if (value == COMPLETED)
			{
				_onLoadHandler();
			}
		}
		
		private function getCenterImage(path:String):Image
		{
			var image:Image = new Image(_atlas.getTexture(path));
			image.pivotX = image.width / 2;
			image.pivotY = image.height / 2;
			return image;
		}
		
		private function getBottomCenterImage(path:String):Image
		{
			var image:Image = new Image(_atlas.getTexture(path));
			image.pivotX = image.width / 2;
			image.pivotY = image.height;
			return image;
		}
		
		public function get assets():AssetManager
		{
			return _assets;
		}
	}
}