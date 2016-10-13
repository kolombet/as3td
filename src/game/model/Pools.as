package game.model
{
	import flash.geom.Point;
	
	import shared.math.*;
	import de.polygonal.core.ObjectPool;
	
	public class Pools
	{
		public static var vec2:ObjectPool;
		public static var point:ObjectPool;
		
		public function Pools()
		{
			vec2 = new ObjectPool(true);
			vec2.allocate(100, Vec2);
			
			point = new ObjectPool(true);
			point.allocate(50, Point);
		}
	}
}
