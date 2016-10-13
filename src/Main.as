package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import game.*;
	
	import starling.core.Starling;
	
	public class Main extends Sprite
	{
		public static var loadProgress:TextField = new TextField();
		public static const VIEW_WIDTH:int = 1275;
		public static const VIEW_HEIGHT:int = 929;
		[SWF(width = '1275', height = '929', backgroundColor = '0x000000')]
		
		public function Main()
		{
			//var tf:TextField = new TextField();
			//tf.text = "test";
			//addChild(tf);
			
			loadProgress.text = "Loading...";
			addChild(loadProgress);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			initStarling();
		}
		
		private function initStarling():void
		{
			Starling.handleLostContext = true;
			var mStarling:Starling = new Starling(App, stage, new Rectangle(0, 0, VIEW_WIDTH, VIEW_HEIGHT));
			mStarling.stage.stageWidth = VIEW_WIDTH; 
			mStarling.stage.stageHeight = VIEW_HEIGHT;
			mStarling.showStats = true;
			mStarling.nativeStage.frameRate = 60;
			mStarling.start();
		}
	}
}
