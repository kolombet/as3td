package game.view
{
	import game.model.IDestroyable;
	import game.model.IGameObj;
	
	import starling.animation.IAnimatable;
	
	public interface IGameView extends IAnimatable, IDestroyable
	{
		function getData():IGameObj
	}
}
