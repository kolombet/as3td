package game.model
{
	public class WaveData implements IDestroyable
	{
		public var id:int;
		public var count:int;
		public var health:int;
		public var speed:int;
		public var spawnDelay:int;
		public var reward:int;
		
		public function WaveData()
		{
		}
		
		public function init(data:Object):void
		{
			this.id = data.id;
			this.count = data.count;
			this.health = data.health;
			this.speed = data.speed;
			this.spawnDelay = data.spawnDelay;
			this.reward = data.reward;
		}
		
		public function destroy():void
		{
			
		}
	}
}
