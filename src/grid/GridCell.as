package grid
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import game.model.Config;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class GridCell extends Sprite
	{
		private var g:Graphics;
		private var bitmap:Bitmap;
		private var canvas:Shape;
		private var t:Texture;
		private var image:Image;
		
		public function GridCell()
		{
			canvas = new Shape();
			g = canvas.graphics;
		}
		
		public function getTexture():Texture
		{
			return t;
		}
		
		public function drawEmptyTile():void
		{
			drawTile(0x0000ff);
		}
		
		public function drawOccupiedTile():void
		{
			drawTile(0xff00ff);
		}
		
		public function drawTile(borderColor:uint = 0xff00ff, fill:Boolean = false, fillColor:uint = 0xff0000):void
		{
			var w:int = Config.ISO_TILE_WIDTH;
			var h:int = Config.ISO_TILE_HEIGHT;
			
			if (fill)
			{
				g.beginFill(fillColor, .5);
			}
			g.lineStyle(1, borderColor, .5);
			
			var p1:Point = new Point(w / 2, 0);
			var p2:Point = new Point(w, h / 2);
			var p3:Point = new Point(w / 2, h);
			var p4:Point = new Point(0, h / 2);
			
			g.moveTo(p1.x, p1.y);
			g.lineTo(p2.x, p2.y);
			g.lineTo(p3.x, p3.y);
			g.lineTo(p4.x, p4.y);
			g.lineTo(p1.x, p1.y);
			if (fill)
			{
				g.endFill();
			}
			
			bitmap = new Bitmap(new BitmapData(w, h, true));
			bitmap.bitmapData.fillRect(new Rectangle(0, 0, w, h), 0x00000000);
			bitmap.bitmapData.draw(canvas);
			t = Texture.fromBitmap(bitmap);
		}
	}
}
