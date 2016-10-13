package game.model.mode
{
	import game.model.PlayState;
	
	public class BaseMode implements IMode
	{
		public function BaseMode()
		{
		}
		
		public function activate(state:PlayState, data:Object = null):void
		{
		}
		
		public function deactivate():void
		{
		}
	}
}
