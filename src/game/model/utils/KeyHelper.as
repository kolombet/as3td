package game.model.utils
{
	import flash.display.Stage;
	import flash.events.KeyboardEvent;

	public class KeyHelper
	{
		/**
		 * Useful for quick add keyboard keyboard combination
		 */
		private static var _stage:Stage;

		public static function init(stage:Stage):void
		{
			_stage = stage
		}

		public static function add(key:uint, action:Function):void
		{
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDowned);

			function onKeyDowned(e:KeyboardEvent):void
			{
				if (e.keyCode == key)
				{
					action();
				}
			}
		}
	}
}