package {
	
	import flash.accessibility.AccessibilityProperties;
	import flash.automation.MouseAutomationAction;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.events.TransformGestureEvent;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	public class Level extends Renderable
	{
		// game objects
		// list of objects that need to be updated every frame
		public var updateObjects:Vector.<UpdateObject>;
		// list of objects that can collide with the ball
		public var collisionObjects:Vector.<Collider>;
		public var props:Vector.<Prop>;
		// manages paint creation in game
		public var paintManager:PaintManager;
		//current target
		public var currentTarget:Ghost;
		//timer for appear animation
		private const appearAnimationTime:int = 500;
		// status flags
		public var paused:Boolean;
		public var winState:Boolean;
		public var loseState:Boolean;
		public var noBallsOnStage:Boolean;
		public var noBallsOnUpdateList:Boolean;
		public var outOfShots:Boolean;
		public var storyProp1Hit:Boolean;
		public var storyProp2Hit:Boolean;
		public var storyProp3Hit:Boolean;
		
		// the current level number
		public var levelNumber:Number;
		// number of shots left for the player
		private const maxShots:int = 50;
		// number of times player has to hit the ghost to win the game
		public const ghostHitWinNumber = 3;
		// number of extra shots you get after hitting the ghost once
		public const extraShotsLeft = 5;
		
		public var shotsLeft:int;
		public var ghostHitCount;
		//animation timer
		private var animTimer:Timer;
		
		public var storyProp1:Renderable;
		public var storyProp2:Renderable;
		public var storyProp3:Renderable;
		public var findPropText:Renderable;
		
		public function Level(num:Number)
		{
			levelNumber = num;
			
			updateObjects = new <UpdateObject>[];
			collisionObjects = new <Collider>[];
			props = new <Prop>[];
			
			shotsLeft = maxShots;
			ghostHitCount = 0;
			
			winState = false;
			noBallsOnStage = false;
			loseState = false;
			outOfShots = false;
			storyProp1Hit = false;
			storyProp2Hit = false;
			storyProp3Hit = false;
			noBallsOnUpdateList = false;
			
			super(Game.instance, "Assets/Levels/Level" + levelNumber + ".swf");
			

		}
		
		public function updateCurrentTarget(currentTargetNumber:int)
		{
			switch(currentTargetNumber)
			{
				case 2:
					   Game.instance.ghostReappearSound.play();
					   currentTarget = this.assetClip.target2;
					   this.assetClip.target1.visible = false;
					   currentTarget.visible = true;
					   currentTarget.idle.visible = false;
					   currentTarget.appear.visible = true;
					   currentTarget.hit.visible = false;
					   animTimer = new Timer(appearAnimationTime, 1);
					   animTimer.start();
					   animTimer.addEventListener(TimerEvent.TIMER_COMPLETE, hideAnimations);
					   break;
					   
				case 3:
						Game.instance.ghostReappearSound.play();
						currentTarget = this.assetClip.target3;
						this.assetClip.target2.visible = false;
					    this.assetClip.target1.visible = false;
					    currentTarget.visible = true;
					    currentTarget.idle.visible = false;
					    currentTarget.appear.visible = true;
					    currentTarget.hit.visible = false;
					    animTimer = new Timer(appearAnimationTime, 1);
					    animTimer.start();
					    animTimer.addEventListener(TimerEvent.TIMER_COMPLETE, hideAnimations);
						break;
			}
			
		}
		
		public function hideAnimations(event:TimerEvent):void
		{
			currentTarget.idle.visible = true;
			currentTarget.appear.visible = false;
			currentTarget.hit.visible = false;
		}
	
		// adds self to the game's base movieclip, or adds a specified clip to the level's base movieclip
		public function addToStage(clip:MovieClip = null)
		{
			if (clip == null)
			{
				Game.instance.addChild(this.baseClip);
			
			}
			else
			{
				this.assetClip.addChild(clip);
			}
		}
		
		public function removeFromStage(clip:MovieClip=null)
		{
			if (clip == null)
			{
				Game.instance.removeChild(this.baseClip);
			}
			else
			{	
			 this.assetClip.removeChild(clip);
				
		    }
		}
		
		override public function AddCustomListeners()
		{
			Game.instance.stage.addEventListener(KeyboardEvent.KEY_DOWN, pauseGame);
			
			storyProp1 = new Renderable(Game.instance, "Assets/Art/SpecialStoryProp/Flas and swfs/Level"+Game.instance.level.levelNumber+"/Sticky1.swf");
			storyProp2 = new Renderable(Game.instance, "Assets/Art/SpecialStoryProp/Flas and swfs/Level"+Game.instance.level.levelNumber+"/Sticky2.swf")
			storyProp3 = new Renderable(Game.instance, "Assets/Art/SpecialStoryProp/Flas and swfs/Level" + Game.instance.level.levelNumber + "/Sticky3.swf")
			findPropText = new Renderable(Game.instance, "Assets/Art/youfound.swf");
			//animations and current target
			currentTarget = this.assetClip.target1;
			this.assetClip.target1.hit.visible = false;
			this.assetClip.target1.appear.visible = false;
			this.assetClip.target2.visible = false;
			this.assetClip.target3.visible = false;
			
			// add paint manager
			paintManager = new PaintManager();
			updateObjects.push(paintManager);
			
			var i, j, childObj, paintObj, detailObj;
			// detect level objects
			for (i = 0; i < Game.instance.level.assetClip.numChildren; i++)
			{
				var obj = Game.instance.level.assetClip.getChildAt(i);;
				// anything that needs to be updated
				if (obj is UpdateObject)
				{
					updateObjects.push(UpdateObject(obj));
				}
				// obstacles in the level
				if (obj is LevelObstacle)
				{
					for (j = 0; j < obj.numChildren; j++)
					{
						detailObj = null;
						childObj = obj.getChildAt(j);
						if (childObj is Collider)
						{
							collisionObjects.push(Collider(childObj));
						}
						if (childObj is PaintObject)
						{
							paintObj = PaintObject(childObj);
						}
						if (childObj is DetailObject)
						{
							detailObj = DetailObject(childObj);
						}
					}
					paintManager.AddPaintBlock(paintObj, detailObj);
				}
				// props
				if (obj is LevelProp)
				{
					for (j = 0; j < obj.numChildren; j++)
					{
						detailObj = null;
						childObj = obj.getChildAt(j);
						if (childObj is Prop)
						{
							paintObj = PaintObject(childObj);
							props.push(Prop(childObj));		
						}
						if (childObj is DetailObject)
						{
							detailObj = DetailObject(childObj);
						}
					}
					paintManager.AddPaintBlock(paintObj, detailObj);
				}
			}
		}
		
		public function resumeEventListener()
		{
			Game.instance.stage.addEventListener(KeyboardEvent.KEY_DOWN, pauseGame);
		}
		
		public function pauseGame(keyEvent:KeyboardEvent):void
		{
			if (keyEvent.keyCode == Keyboard.SPACE) 
			{ 
				// add pause to stage
				paused = true;
				Game.instance.pause.addToStage();
				Game.instance.pause.AddCustomListeners();
				
				// remove player
				Game.instance.stage.removeEventListener(KeyboardEvent.KEY_DOWN, pauseGame);
				this.assetClip.player.cleanUp();			
			}
		}
		
		public function Update(deltaTime:Number)
		{
		
			noBallsOnStage = true;
			noBallsOnUpdateList = true;
			if (paused || winState || loseState)
			{
				return;
			}
				
			for (var i = 0; i < updateObjects.length; i++)
			{
				updateObjects[i].Update(deltaTime);
			}
			
			for (i = 0; i < updateObjects.length; i++)
			{
				var obj = updateObjects[i];
				// check if ball is outside of screen
				if (obj is Ball)
				{
					noBallsOnUpdateList = false;
					var ballobj = obj;
					if ((obj.x >= 0 && obj.x <= Game.instance.stage.stageWidth && obj.y >= 0 && obj.y <= Game.instance.stage.stageHeight))
					{
						noBallsOnStage = false;
					}
				}
			}
			
			if (ballobj==null && shotsLeft == 0)
			{
				loseLevel();
			}
		}
		
		// called when player shoots a ball
		public function updateShots()
		{
			shotsLeft--;
			this.assetClip.shotsLeftText.text = ("X " +shotsLeft);
			if (shotsLeft == 0)
			{
				outOfShots = true;
				this.assetClip.player.cleanUp();
			}	
		}
		
		public function winLevel()
		{
			// add win screen
			Game.instance.ghostDefeatedSound.play();
			Game.instance.winSound.play();
			this.winState = true;
			Game.instance.winScreen.addToStage();
			Game.instance.winScreen.AddCustomListeners();
			
			// remove player and level
			this.assetClip.player.cleanUp();
			Game.instance.removeChild(this.baseClip);
		}
		
		public function loseLevel()
		{
			// add lose screen
			Game.instance.loseSound.play();
			Game.instance.ghostWinSound.play();
			this.loseState = true;
			Game.instance.loseScreen.addToStage();
			Game.instance.loseScreen.AddCustomListeners();
			
			// remove level
			Game.instance.removeChild(this.baseClip);
		}
	}
}



