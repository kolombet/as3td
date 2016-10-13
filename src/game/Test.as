package game
{
	import flash.geom.Point;
	
	import game.model.IsoTransform;
	
	public class Test
	{
		public function Test()
		{
			//testTransform1();
			//testTransform2();
		}
		
		public function testTransform1():void
		{
			var p0:Point = new Point(27, 37);
			var p:Point = IsoTransform.fromP(p0);
			var p2:Point = IsoTransform.toP(p);
			if (p0.x != p2.x || p0.y != p2.y)
			{
				throw new Error("error");
			}
		}
		
		public function testTransform2():void
		{
			var p0:Point = new Point(27, 37);
			var p:Point = IsoTransform.toP(p0);
			var p2:Point = IsoTransform.fromP(p);
			if (p0.x != p2.x || p0.y != p2.y)
			{
				throw new Error("error");
			}
		}
	}
}
