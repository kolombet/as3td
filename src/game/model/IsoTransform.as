package game.model
{
	import flash.geom.Point;
	
	import shared.math.Vec2;
	
	public class IsoTransform
	{
		public static function fromP(p:Point):Point
		{
			var result:Point = Pools.point.object;
			result.x = p.x - p.y;
			result.y = (p.x + p.y) >> 1;
			return result;
		}
		
		public static function toP(p:Point):Point
		{
			var result:Point = Pools.point.object;
			result.x = (p.x >> 1) + p.y;
			result.y = p.y - (p.x >> 1);
			return result;
		}
		
		public static function from(p:Vec2):Vec2
		{
			var result:Vec2 = Pools.vec2.object;
			result.x = p.x - p.y;
			result.y = (p.x + p.y) >> 1;
			return result;
		}
		
		public static function to(p:Vec2):Vec2
		{
			var result:Vec2 = Pools.vec2.object;
			result.x = (p.x >> 1) + p.y;
			result.y = p.y - (p.x >> 1);
			return result;
		}
	}
}

