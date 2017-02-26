package {
	
	import flash.automation.MouseAutomationAction;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	// the options screen
	public class Options extends Renderable
	{
		public function Options()
		{
			super(Game.instance, "Assets/Art/Options.swf");
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
