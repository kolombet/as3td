package game.model.mode
{
	import game.model.PlayState;
	
	public interface IMode
	{
		function activate(state:PlayState, data:Object = null):void;
		
		function deactivate():void;
	}
}
