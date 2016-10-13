package game.model
{
	public interface ISaveLoadable
	{
		function save():Object;
		
		function load(data:Object):void;
	}
}
