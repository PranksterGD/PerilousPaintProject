package {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	// the level select screen
	public class ChooseLevel extends Renderable
	{
		public function ChooseLevel()
		{
			super(Game.instance, "Assets/Art/ChooseLevel.swf");
		}	
		
		public function addToStage():void
		{
			Game.instance.addChild(this.baseClip);
		}
		
		override public function AddCustomListeners() 
		{
			this.assetClip.LevelButton1.addEventListener(MouseEvent.MOUSE_DOWN, level1Clicked);
			this.assetClip.LevelButton1.addEventListener(MouseEvent.MOUSE_OVER, optionHoveredOver);
			
			this.assetClip.LevelButton2.addEventListener(MouseEvent.MOUSE_DOWN, level2Clicked);
			this.assetClip.LevelButton2.addEventListener(MouseEvent.MOUSE_OVER, optionHoveredOver);
			
			this.assetClip.LevelButton3.addEventListener(MouseEvent.MOUSE_DOWN, level3Clicked);
			this.assetClip.LevelButton3.addEventListener(MouseEvent.MOUSE_OVER, optionHoveredOver);
			
			this.assetClip.LevelButton4.addEventListener(MouseEvent.MOUSE_DOWN, level4Clicked);
			this.assetClip.LevelButton4.addEventListener(MouseEvent.MOUSE_OVER, optionHoveredOver);
			
			this.assetClip.LevelButton5.addEventListener(MouseEvent.MOUSE_DOWN, level5Clicked);
			this.assetClip.LevelButton5.addEventListener(MouseEvent.MOUSE_OVER, optionHoveredOver);
			
			this.assetClip.BackButton.addEventListener(MouseEvent.MOUSE_DOWN, backClicked);
			this.assetClip.BackButton.addEventListener(MouseEvent.MOUSE_OVER, optionHoveredOver);
		}
		
		public function optionHoveredOver(event:MouseEvent):void
		{
			Game.instance.optionsHoverSound.play();
		}
		
		public function level1Clicked(event:MouseEvent):void
		{
			Game.instance.optionsSelectSound.play();
			Game.instance.removeChild(this.baseClip);
			Game.instance.level = new Level(1);
			Game.instance.level.addToStage();
		}
		
		public function level2Clicked(event:MouseEvent):void
		{
			Game.instance.optionsSelectSound.play();
			Game.instance.removeChild(this.baseClip);
			Game.instance.level = new Level(2);
			Game.instance.level.addToStage();
		}
		
		public function level3Clicked(event:MouseEvent):void
		{
			Game.instance.optionsSelectSound.play();
			Game.instance.removeChild(this.baseClip);
			Game.instance.level = new Level(3);
			Game.instance.level.addToStage();
		}
		
		public function level4Clicked(event:MouseEvent):void
		{
			Game.instance.optionsSelectSound.play();
			Game.instance.removeChild(this.baseClip);
			Game.instance.level = new Level(4);
			Game.instance.level.addToStage();
		}
		
		public function level5Clicked(event:MouseEvent):void
		{
			Game.instance.optionsSelectSound.play();
			Game.instance.removeChild(this.baseClip);
			Game.instance.level = new Level(5);
			Game.instance.level.addToStage();
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
