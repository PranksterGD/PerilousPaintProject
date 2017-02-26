package {
	
	import flash.automation.MouseAutomationAction;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.media.SoundTransform;
	import flash.media.SoundMixer;
	
	// the main menu screen
	public class MainMenu extends Renderable 
	{
		public function MainMenu()
		{
			super(Game.instance, "Assets/Art/MainMenu.swf");
		}
		
		public function addToStage()
		{
			Game.instance.addChild(this.baseClip);
		}
		
		override public function AddCustomListeners()
		{
			this.assetClip.CreditsButton.addEventListener(MouseEvent.MOUSE_DOWN, creditsClicked);
			this.assetClip.CreditsButton.addEventListener(MouseEvent.MOUSE_OVER, optionHoveredOver);
			
			this.assetClip.InstructionsButton.addEventListener(MouseEvent.MOUSE_DOWN, instructionsClicked);
			this.assetClip.InstructionsButton.addEventListener(MouseEvent.MOUSE_OVER, optionHoveredOver);
			
			this.assetClip.StartButton.addEventListener(MouseEvent.MOUSE_DOWN, StartClicked);
			this.assetClip.StartButton.addEventListener(MouseEvent.MOUSE_OVER, optionHoveredOver);
			
			this.assetClip.ChooseLevelButton.addEventListener(MouseEvent.MOUSE_DOWN, ChooseLevelClicked);
			this.assetClip.ChooseLevelButton.addEventListener(MouseEvent.MOUSE_OVER, optionHoveredOver);
			
			this.assetClip.SoundButton.addEventListener(MouseEvent.MOUSE_DOWN, soundClicked);
			this.assetClip.SoundButton.addEventListener(MouseEvent.MOUSE_OVER, optionHoveredOver);
		}
		
		public function optionHoveredOver(event:MouseEvent):void
		{
			Game.instance.optionsHoverSound.play();
		}
		
		public function soundClicked(event:MouseEvent):void
		{
			Game.instance.soundActive *=-1;
			if (Game.instance.soundActive ==-1)
			{
				SoundMixer.soundTransform = new SoundTransform(0);	
			}
			else
			{
				SoundMixer.soundTransform = new SoundTransform(1);
			}
		}
		
		public function creditsClicked(event:MouseEvent):void
		{
			Game.instance.optionsSelectSound.play();
			Game.instance.removeChild(this.baseClip);
			Game.instance.options = new Options();
			Game.instance.options.addToStage();
		}
		
		public function instructionsClicked(event:MouseEvent):void
		{
			Game.instance.optionsSelectSound.play();
			Game.instance.removeChild(this.baseClip);
			Game.instance.instructions = new Instructions();
			Game.instance.instructions.addToStage();
		}
		
		public function StartClicked(event:MouseEvent):void
		{
			Game.instance.optionsSelectSound.play();
			Game.instance.removeChild(this.baseClip);
			Game.instance.level = new Level(1);
			Game.instance.level.addToStage();
		}	
		
		public function ChooseLevelClicked(event:MouseEvent):void
		{
			Game.instance.optionsSelectSound.play();
			Game.instance.removeChild(this.baseClip);
			Game.instance.chooseLevel = new ChooseLevel();
			Game.instance.chooseLevel.addToStage();
		}
	}
}
