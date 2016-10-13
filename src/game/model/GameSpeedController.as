package game.model
{
	import flash.ui.Keyboard;
	
	import game.model.utils.Console;
	
	import starling.core.Starling;
	import starling.events.KeyboardEvent;
	
	public class GameSpeedController
	{
		private static var values:Array = [1, 4, 5, 10];
		private static var currentItem:int = 0;
		
		public static function initialize():void
		{
			Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
			Starling.current.stage.addEventListener(KeyboardEvent.KEY_UP, stage_keyUpHandler);
		}
		
		public static function isSpeedUp():Boolean
		{
			return Starling.speedMultiplier > 1;
		}
		
		public static function speedUP():void
		{
			currentItem++;
			Starling.speedMultiplier = values[currentItem % values.length];
			Console.log("speed: " + Starling.speedMultiplier);
		}
		
		protected static function stage_keyDownHandler(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.EQUAL)
			{
				Starling.speedMultiplier++;
			}
			else if (e.keyCode == Keyboard.MINUS)
			{
				if (Starling.speedMultiplier > 0)
					Starling.speedMultiplier--;
			}
		}
		
		protected static function stage_keyUpHandler(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.NUMBER_0)
			{
				Starling.speedMultiplier = 0;
			}
			else if (e.keyCode == Keyboard.NUMBER_1)
			{
				Starling.speedMultiplier = 1;
			}
			else if (e.keyCode == Keyboard.NUMBER_2)
			{
				Starling.speedMultiplier = 2;
			}
			else if (e.keyCode == Keyboard.NUMBER_3)
			{
				Starling.speedMultiplier = 3;
			}
			else if (e.keyCode == Keyboard.NUMBER_4)
			{
				Starling.speedMultiplier = 4;
			}
		}
		
	}
	
}