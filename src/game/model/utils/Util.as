package game.model.utils
{
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import game.model.IGameObj;
	
	import shared.math.Vec2;
	
	public class Util
	{
		public function Util()
		{
		}
		
		public static function distanceVect(obj1:IGameObj, obj2:IGameObj):Vec2
		{
			return new Vec2(obj1.x - obj2.x, obj1.y - obj2.y);
		}
		
		public static function vecLength(_x:Number, _y:Number):Number
		{
			return Math.sqrt(_x * _x + _y * _y);
		}
		
		public static function outFile(fileName:String, str:String):void
		{
			var byteArray:ByteArray = new ByteArray();
			byteArray.writeUTFBytes(str);
			
			var fileRef:FileReference = new FileReference();
			fileRef.save(byteArray, fileName);
		}
	}
}
