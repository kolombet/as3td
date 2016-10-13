package game.model.utils
{
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.KeyboardEvent;
	
	public class KeyboardLayoutController
	{
		/**
		 * Used to change size and coordinates of DisplayObject with keyboard
		 */
		private var _target:*;
		private var _rect:Rectangle;
		
		public function KeyboardLayoutController()
		{
		}
		
		public function init():void
		{
			Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDowned)
		}
		
		public function add(target:*):void
		{
			if (target is flash.display.DisplayObject || target is starling.display.DisplayObject)
			{
				_target = target;
				_rect = new Rectangle(target.x, target.y, target.width, target.height);
			}
			else
			{
				throw new Error("wrong target");
			}
		}
		
		private function onKeyDowned(e:KeyboardEvent):void
		{
			if (e == null || e.keyCode == NaN || _rect == null)
			{
				throw new Error();
			}
			
			var code:uint = e.keyCode;
			if (e.shiftKey)
			{
				caseSize(code);
			}
			else
			{
				caseLoc(code);
			}
			
			_target.x = _rect.x;
			_target.y = _rect.y;
			_target.width = _rect.width;
			_target.height = _rect.height;
		}
		
		function caseSize(keyCode:uint):void
		{
			switch (keyCode)
			{
				case Keyboard.UP:
					_rect.height -= 5;
					break;
				case Keyboard.DOWN:
					_rect.height += 5;
					break;
				case Keyboard.LEFT:
					_rect.width -= 5;
					break;
				case Keyboard.RIGHT:
					_rect.width += 5;
					break;
			}
		}
		
		function caseLoc(keyCode:uint):void
		{
			switch (keyCode)
			{
				case Keyboard.UP:
					_rect.y -= 5;
					break;
				case Keyboard.DOWN:
					_rect.y += 5;
					break;
				case Keyboard.LEFT:
					_rect.x -= 5;
					break;
				case Keyboard.RIGHT:
					_rect.x += 5;
					break;
			}
		}
	}
}
