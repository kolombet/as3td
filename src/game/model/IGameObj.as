package game.model
{
	import starling.animation.IAnimatable;
	
	public interface IGameObj extends IAnimatable
	{
		//function advanceTime(time:Number):void;
		function get x():Number;
		
		function get y():Number;
		
		function get depth():int;
		
		function destroy():void;
	}
}
