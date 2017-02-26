package {
	
	import flash.automation.MouseAutomationAction;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	// the final win screen
	public class FinalWinScreen extends Renderable
	{
		public function FinalWinScreen()
		{
			super(Game.instance, "Assets/Art/FinalWinScreen.swf");
		}
		
		public function addToStage()
		{
			Game.instance.addChild(this.baseClip);
		}
		
		override public function AddCustomListeners()
		{
			this.assetClip.NextButton.addEventListener(MouseEvent.MOUSE_DOWN, nextClicked);
			this.assetClip.NextButton.addEventListener(MouseEvent.MOUSE_OVER, optionHoveredOver);
		}
		
		public function optionHoveredOver(event:MouseEvent):void
		{
			Game.instance.optionsHoverSound.play();
		}

		public function nextClicked(event:MouseEvent):void
		{
			Game.instance.optionsDeselectSound.play();
			Game.instance.removeChild(this.baseClip);
			Game.instance.options = new Options();
			Game.instance.options.addToStage();
		}
	}
}
