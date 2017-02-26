package {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.media.H264Level;
	import flash.media.SoundTransform;
	import flash.media.SoundMixer;
	
	
	// the pause screen
	public class Pause extends Renderable
	{
		public function Pause()
		{
			super(Game.instance, "Assets/Art/Pause.swf");
		}	
		
		public function addToStage():void
		{
			Game.instance.addChild(this.baseClip);
		}
		
		override public function AddCustomListeners() 
		{
			this.assetClip.ResumeButton.addEventListener(MouseEvent.MOUSE_DOWN, ResumeClicked);
			this.assetClip.ResumeButton.addEventListener(MouseEvent.MOUSE_OVER, optionHoveredOver);
			
			this.assetClip.QuitButton.addEventListener(MouseEvent.MOUSE_DOWN, QuitClicked);
			this.assetClip.QuitButton.addEventListener(MouseEvent.MOUSE_OVER, optionHoveredOver);
			
			this.assetClip.RestartButton.addEventListener(MouseEvent.MOUSE_DOWN, RestartClicked);
			this.assetClip.RestartButton.addEventListener(MouseEvent.MOUSE_OVER, optionHoveredOver);
			
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
		
		public function ResumeClicked(event:MouseEvent):void
		{
			Game.instance.optionsSelectSound.play();
			Game.instance.removeChild(this.baseClip);
			Game.instance.level.resumeEventListener();
			if (Game.instance.level.shotsLeft != 0)
			{
			 Game.instance.level.assetClip.player.onUnpause();
			}
			Game.instance.level.addToStage();
			Game.instance.level.paused = false;
		}
		
		public function QuitClicked(event:MouseEvent):void
		{
			Game.instance.optionsSelectSound.play();
			Game.instance.removeChild(this.baseClip);
			Game.instance.level.removeFromStage();
			Game.instance.mainMenu = new MainMenu();
			Game.instance.mainMenu.addToStage();
		}
		
		public function RestartClicked(event:MouseEvent):void
		{
			Game.instance.optionsSelectSound.play();
			Game.instance.removeChild(this.baseClip);
			Game.instance.level.assetClip.player.cleanUp();
			Game.instance.level.removeFromStage();
			Game.instance.level = new Level(Game.instance.level.levelNumber);
			Game.instance.level.addToStage(); 
		}
	}
}
