package {
	
	import flash.automation.MouseAutomationAction;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	// the instructions screen
	public class Instructions extends Renderable
	{
		public function Instructions()
		{
			super(Game.instance, "Assets/Art/Instructions.swf");
		}
		
		public function addToStage()
		{
			Game.instance.addChild(this.baseClip);
		}
		
		override public function AddCustomListeners()
		{
			this.assetClip.Back.addEventListener(MouseEvent.MOUSE_DOWN, backClicked);
			this.assetClip.Back.addEventListener(MouseEvent.MOUSE_OVER, optionHoveredOver);
		}
		
		public function optionHoveredOver(event:MouseEvent):void
		{
			Game.instance.optionsHoverSound.play();
		}

		public function backClicked(event:MouseEvent):void
		{
			Game.instance.optionsDeselectSound.play();
			Game.instance.removeChild(this.baseClip);
			Game.instance.mainMenu = new MainMenu();
			Game.instance.mainMenu.addToStage();
		}
	}
}
