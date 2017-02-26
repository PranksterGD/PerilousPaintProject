package {
	
	import flash.automation.MouseAutomationAction;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class WinScreen extends Renderable 
	{
		
		
		public function WinScreen()
		{
			super(Game.instance, "Assets/Art/WinScreen.swf");
			
		}
		
		public function addToStage()
		{
			Game.instance.addChild(this.baseClip);
			
			if (Game.instance.level.storyProp1Hit == true || Game.instance.level.storyProp2Hit == true || Game.instance.level.storyProp3Hit == true)
			{
				Game.instance.addChild(Game.instance.level.findPropText.assetClip);
				Game.instance.level.findPropText.assetClip.x = 0;
				Game.instance.level.findPropText.assetClip.y = 0;
				
			}

			if (Game.instance.level.storyProp1Hit == true)
			{
			Game.instance.addChild(Game.instance.level.storyProp1.assetClip);
			Game.instance.level.storyProp1.assetClip.x = -36;
			Game.instance.level.storyProp1.assetClip.y = 176;
				
			}
		
			if (Game.instance.level.storyProp2Hit == true)
			{
			Game.instance..addChild(Game.instance.level.storyProp2.assetClip);
			Game.instance.level.storyProp2.assetClip.x = 587.15;
			Game.instance.level.storyProp2.assetClip.y = 176;
				
			}
			
			if (Game.instance.level.storyProp3Hit == true)
			{
			Game.instance.addChild(Game.instance.level.storyProp3.assetClip);
			Game.instance.level.storyProp3.assetClip.x = 1189.25;
			Game.instance.level.storyProp3.assetClip.y = 176;
				
			}	
		}
		
		override public function AddCustomListeners()
		{
			this.assetClip.QuitButton.addEventListener(MouseEvent.MOUSE_DOWN, QuitClicked);
			this.assetClip.QuitButton.addEventListener(MouseEvent.MOUSE_OVER, optionHoveredOver);
			
			this.assetClip.ReplayButton.addEventListener(MouseEvent.MOUSE_DOWN, ReplayClicked);
			this.assetClip.ReplayButton.addEventListener(MouseEvent.MOUSE_OVER, optionHoveredOver);
			
			this.assetClip.NextLevelButton.addEventListener(MouseEvent.MOUSE_DOWN, NextLevelClicked);
			this.assetClip.NextLevelButton.addEventListener(MouseEvent.MOUSE_OVER, optionHoveredOver);
		}
		
		public function removeStoryProps()
		{
			if (Game.instance.level.storyProp1Hit == true || Game.instance.level.storyProp2Hit == true || Game.instance.level.storyProp3Hit == true)
			{
				Game.instance.removeChild(Game.instance.level.findPropText.assetClip);
			}
			
			if (Game.instance.level.storyProp1Hit == true)
			{
			Game.instance.removeChild(Game.instance.level.storyProp1.assetClip);
			}
			
			if (Game.instance.level.storyProp2Hit == true)
			{
			Game.instance.removeChild(Game.instance.level.storyProp2.assetClip);
			}
			
			if (Game.instance.level.storyProp3Hit == true)
			{
			Game.instance.removeChild(Game.instance.level.storyProp3.assetClip);
			}
		}	
		
		public function optionHoveredOver(event:MouseEvent):void
		{
			Game.instance.optionsHoverSound.play();
		}
		
		public function QuitClicked(event:MouseEvent):void
		{
			removeStoryProps();
			Game.instance.optionsSelectSound.play();
			Game.instance.removeChild(this.baseClip);
			Game.instance.mainMenu.addToStage();
			Game.instance.mainMenu.AddCustomListeners();
		}
		
		public function ReplayClicked(event:MouseEvent):void
		{
			removeStoryProps();
			Game.instance.optionsSelectSound.play();
			Game.instance.removeChild(this.baseClip);
			Game.instance.level = new Level(Game.instance.level.levelNumber);
			Game.instance.level.addToStage();
		}
		
		public function NextLevelClicked(event:MouseEvent):void
		{
			removeStoryProps();
			Game.instance.optionsSelectSound.play();
			Game.instance.removeChild(this.baseClip);
			if (Game.instance.level.levelNumber != Game.instance.maxLevel)
			{
			Game.instance.level = new Level(Game.instance.level.levelNumber + 1);
			Game.instance.level.addToStage();	
			}
			else
			{
				Game.instance.finalWinScreen.addToStage();
				Game.instance.finalWinScreen.AddCustomListeners();
			}
			
		}	
	}
}
