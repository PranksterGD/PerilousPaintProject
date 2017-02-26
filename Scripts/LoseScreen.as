package {
	
	import flash.automation.MouseAutomationAction;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	// the game over screen
	public class LoseScreen extends Renderable 
	{
		public function LoseScreen()
		{
			super(Game.instance, "Assets/Art/LoseScreen.swf");
		}
		
		public function addToStage()
		{
			Game.instance.addChild(this.baseClip);
		}
		
		override public function AddCustomListeners()
		{
			this.assetClip.QuitButton.addEventListener(MouseEvent.MOUSE_DOWN, QuitClicked);
			this.assetClip.QuitButton.addEventListener(MouseEvent.MOUSE_OVER, optionHoveredOver);
			
			this.assetClip.TryAgainButton.addEventListener(MouseEvent.MOUSE_DOWN, TryAgainClicked);
			this.assetClip.TryAgainButton.addEventListener(MouseEvent.MOUSE_OVER, optionHoveredOver);
			
		}
		
		public function optionHoveredOver(event:MouseEvent):void
		{
			Game.instance.optionsHoverSound.play();
		}
		
		public function QuitClicked(event:MouseEvent):void
		{
			Game.instance.optionsSelectSound.play();
			Game.instance.removeChild(this.baseClip);
			Game.instance.mainMenu.addToStage();
			Game.instance.mainMenu.AddCustomListeners();
		}
		
		public function TryAgainClicked(event:MouseEvent):void
		{
			Game.instance.optionsSelectSound.play();
			Game.instance.removeChild(this.baseClip);
			Game.instance.level = new Level(Game.instance.level.levelNumber);
			Game.instance.level.addToStage();
		}	
	}
}
