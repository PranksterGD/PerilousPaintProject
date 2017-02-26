package
{
	import adobe.utils.CustomActions;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.*
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundLoaderContext;
	import flash.utils.getTimer;
	import flash.net.URLRequest;

	public class Game extends MovieClip
	{
		// singleton reference to the class
		public static var instance:Game;
		
		// screens
		public var mainMenu:MainMenu;
		public var options:Options;
		public var instructions:Instructions;
		public var pause:Pause;
		public var chooseLevel:ChooseLevel;
		public var winScreen: WinScreen;
		public var loseScreen:LoseScreen;
		public var finalWinScreen:FinalWinScreen;
		// sounds
		public var backgroundMusic:Sound;
		public var backgroundMusicLoop:SoundChannel;
		public var shootSound:Sound;
		public var winSound:Sound;
		public var loseSound:Sound;
		public var hitGhostFanFareSound:Sound;
		public var optionsHoverSound:Sound;
		public var optionsSelectSound:Sound;
		public var optionsDeselectSound:Sound;
		public var ghostWinSound:Sound;
		public var ghostDefeatedSound:Sound;
		public var ghostHitSound:Sound;
		public var paintHitGhostSound:Sound;
		public var ghostReappearSound:Sound;
		public var impactSound:Sound;
		public var bounceSound:Sound;
		public var itemFindSound:Sound;
		public var soundActive:int;
		
		// current level
		public var level:Level;
		public  const maxLevel:int = 5 ;
		
		// last time recorded by the update function
		private var lastTime:int;
		
		public function Game()
		{ 
			instance = this;
			mainMenu = new MainMenu();
			options = new Options();
			instructions = new Instructions();
			pause = new Pause();
			chooseLevel = new ChooseLevel();
			winScreen = new WinScreen();
			loseScreen = new LoseScreen();
			finalWinScreen = new FinalWinScreen();
			
			soundActive = 1;
			
			// add the game loop
			stage.addEventListener(Event.ENTER_FRAME, Update);
			
			// create background music
			var backgroundMusicUrl: URLRequest = new URLRequest("Assets/Sound/BGMSlowest.mp3");
			backgroundMusic = new Sound(backgroundMusicUrl);
			backgroundMusicLoop = new SoundChannel();
			backgroundMusicLoop = backgroundMusic.play(0, int.MAX_VALUE);
			
			// create sounds
			var shootSoundUrl: URLRequest = new URLRequest("Assets/Sound/shootpaint.mp3");
			shootSound = new Sound(shootSoundUrl);
			
			var winSoundUrl:URLRequest = new URLRequest("Assets/Sound/winfanfare.mp3");
			winSound = new Sound(winSoundUrl);
			
			var loseSoundUrl:URLRequest = new URLRequest("Assets/Sound/losefanfare.mp3");
			loseSound = new Sound(loseSoundUrl);
			
			var hitGhostFanFareSoundUrl:URLRequest = new URLRequest("Assets/Sound/hitghostfanfare.mp3");
			hitGhostFanFareSound = new Sound(hitGhostFanFareSoundUrl);
			
			var optionsHoverSoundUrl: URLRequest = new URLRequest("Assets/Sound/optionhover.mp3");
			optionsHoverSound = new Sound(optionsHoverSoundUrl);
			
			var optionsSelectSoundUrl: URLRequest = new URLRequest("Assets/Sound/optionselect.mp3");
			optionsSelectSound = new Sound(optionsSelectSoundUrl);
			
			var optionsDeselectSoundUrl: URLRequest = new URLRequest("Assets/Sound/optiondeselect.mp3");
			optionsDeselectSound = new Sound(optionsDeselectSoundUrl);
			
			var ghostWinSoundUrl: URLRequest = new URLRequest("Assets/Sound/ghostwins.mp3");
			ghostWinSound = new Sound(ghostWinSoundUrl);
			
			var ghostDefeatedSoundUrl: URLRequest = new URLRequest("Assets/Sound/ghostdefeatedvoice.mp3");
			ghostDefeatedSound = new Sound(ghostDefeatedSoundUrl);
			
			var ghostHitSoundUrl: URLRequest = new URLRequest("Assets/Sound/ghosthitvoice.mp3");
			ghostHitSound = new Sound(ghostHitSoundUrl);
			
			var paintHitGhostSoundUrl: URLRequest = new URLRequest("Assets/Sound/hitghost.mp3");
			paintHitGhostSound = new Sound(ghostHitSoundUrl);
			
			var ghostReappearSoundUrl: URLRequest = new URLRequest("Assets/Sound/ghostreappear.mp3");
			ghostReappearSound = new Sound(ghostReappearSoundUrl);
			
			var impactSoundUrl:URLRequest = new URLRequest("Assets/Sound/hittable.mp3");
			impactSound = new Sound(impactSoundUrl);
			
			var bounceSoundUrl:URLRequest = new URLRequest("Assets/Sound/paintbounce.mp3");
			bounceSound = new Sound(bounceSoundUrl);
			
			var itemFindSoundUrl:URLRequest = new URLRequest("Assets/Sound/finditem.mp3");
			itemFindSound = new Sound(itemFindSoundUrl);
			
			// game starts at main menu
			mainMenu.addToStage();
		}
		
		public function Update(event:Event):void
		{
			// get time since the last frame
			var time:int = getTimer();
			var deltaTime:Number = (time - lastTime) / 1000;
			lastTime = time;
			
			// update the level
			if (level != null)
			{
				level.Update(deltaTime);
			}
		}
	}
}