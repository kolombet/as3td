package game.model.managers
{
	import game.model.BaseCreepData;
	import game.model.IDestroyable;
	import game.model.PlayState;
	import game.model.bullets.BasicBulletData;
	import game.model.bullets.effects.IEffect;
	
	import org.osflash.signals.Signal;
	
	import starling.animation.IAnimatable;
	
	public class BulletManager implements IDestroyable, IAnimatable
	{
		private var _state:PlayState;
		private var _collection:Vector.<BasicBulletData>;
		private var _onBulletSpawned:Signal = new Signal(BasicBulletData);
		private var _onBulletDestroyed:Signal = new Signal(BasicBulletData);
		
		public function BulletManager(state:PlayState)
		{
			_state = state;
			_collection = new Vector.<BasicBulletData>();
		}
		
		public function advanceTime(time:Number):void
		{
			for (var i:int = 0; i < _collection.length; i++)
			{
				_collection[i].advanceTime(time);
			}
		}
		
		public function spawn(target:BaseCreepData, effect:IEffect, startX:Number, startY:Number):void
		{
			var data:BasicBulletData = new BasicBulletData(_state, target, effect, startX, startY);
			_collection.push(data);
			_onBulletSpawned.dispatch(data);
			data.onDestroyed.addOnce(onBulletDestroyHandler);
		}
		
		public function onBulletDestroyHandler(data:BasicBulletData):void
		{
			_collection.removeAt(_collection.indexOf(data));
			_onBulletDestroyed.dispatch(data);
			data.destroy();
		}
		
		public function get collection():Vector.<BasicBulletData>
		{
			return _collection;
		}
		
		public function get onBulletSpawned():Signal
		{
			return _onBulletSpawned;
		}
		
		public function get onBulletDestroyed():Signal
		{
			return _onBulletDestroyed;
		}
		
		public function destroy():void
		{
			_state = null;
			for (var i:int = 0; i < _collection.length; i++)
			{
				_collection[i].destroy();
				_collection[i] = null;
			}
			_onBulletDestroyed.removeAll();
			_onBulletDestroyed = null;
			_onBulletSpawned.removeAll();
			_onBulletSpawned = null;
		}
	}
}
