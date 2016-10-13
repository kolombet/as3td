package game.view
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import game.App;
	import game.model.IGameObj;
	import game.model.IsoTransform;
	import game.model.BaseCreepData;
	import game.model.Direction;
	import game.model.Pools;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	
	public class CreepView extends Sprite implements IGameView
	{
		private static const GNOME:String = "gnome";
		private static const ORK:String = "ork";
		private var _creepData:BaseCreepData;
		private var _animations:Dictionary;//<MovieClip>
		private var _playingAnimation:String;
		private var _mName:String;
		
		
		public function CreepView(data:BaseCreepData)
		{
			_mName = (Math.random() > .5) ? GNOME : ORK;
			_creepData = data;
			_animations = new Dictionary();
			
			var animations:Array = Direction.getList();
			for (var i:int = 0; i < animations.length; i++)
			{
				createAnimation(animations[i]);
			}
			
			playAnimation("TL");
		}
		
		private function playAnimation(type:String):void
		{
			if (_playingAnimation)
			{
				var prevAnim:MovieClip = _animations[_playingAnimation];
				prevAnim.stop();
				prevAnim.visible = false;
				Starling.juggler.remove(prevAnim);
			}
			
			var anim:MovieClip = _animations[type];
			anim.visible = true;
			anim.play();
			Starling.juggler.add(anim);
			_playingAnimation = type;
		}
		
		private function hideAll():void
		{
			for each (var animation:MovieClip in _animations)
			{
				animation.stop();
				animation.visible = false;
				Starling.juggler.remove(animation);
			}
		}
		
		public function createAnimation(type:String):void
		{
			var animation:MovieClip = App.resources.getMonsterAnimation(_mName, type);
			animation.visible = false;
			addChild(animation);
			_animations[type] = animation;
		}
		
		public function drawFooting():void
		{
			var footing:Quad = new Quad(4, 4, 0x00ff00);
			footing.x = -2;
			footing.y = -2;
			addChild(footing);
		}
		
		public function destroy():void
		{
			_creepData = null;
			
			for each (var anim:MovieClip in _animations)
			{
				this.removeChild(anim);
				anim.dispose();
			}
			super .dispose();
		}
		
		public function advanceTime(time:Number):void
		{
			if (_creepData == null)
				return;
			
			if (_creepData.rotationName && _playingAnimation != _creepData.rotationName)
			{
				playAnimation(_creepData.rotationName);
			}
			var p:Point = IsoTransform.fromP(new Point(_creepData.x, _creepData.y));
			this.x = p.x;
			this.y = p.y;
			Pools.point.object = p;
		}
		
		public function getData():IGameObj
		{
			return _creepData;
		}
	}
}
