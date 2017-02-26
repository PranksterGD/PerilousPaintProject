package 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.Timer;
	
	public class Ball extends UpdateObject  
	{
		// current velocity of the ball
		public var velocity:Point;
		
		//location of the ball on the updateObjects list
		public var ballId:Number;
		
		// number of collion points on the ball
		private const collisionAccuracy:int = 25;
		// list of collision points from the last update
		// these are used to draw collision lines
		private var lastCollisionPoints:Vector.<Point>;
		// all of the normals that affect the ball at a collision point
		// only gets used if a collision happens
		private var collisionNormals:Vector.<Point>;
		
		// length of the collision cooldown in milliseconds
		private const collisionCooldown:int = 100;
		//time the animation should play
		private const hitAnimationTime:int = 400;
		// true if the ball can collide with the environment
		// gets set to false after a collision to prevent movement through colliders
		private var canCollide:Boolean;
		// times the ball once it hits a collider,
		// once the timer has completed the ball can collide again
		private var colTimer:Timer;
		//timer for the animation
		private var animTimer:Timer;
		
		// number of bounces against non-painted surfaces before being destroyed
		private const maxUnpaintedBounces:int = 1;
		private var currentUnpaintedBounces:int;
		// number of bounces against painted surfaces before being destroyed
		private const maxPaintedBounces:int = 10;
		private var currentPaintedBounces:int;
		// the number of pixels (in a square) that are checked to determine if paint is hit
		private const paintHitThreshold:Number = 10;
		
		static private var animationIsPlaying:Boolean;
		
		public function Ball(ballId:Number)
		{
			animationIsPlaying = false;
			
			velocity = new Point();
			this.ballId = ballId;
		
			// create collision points
			lastCollisionPoints = new <Point>[];
			var step:Number = 2 * Math.PI / collisionAccuracy;
			var currentAngle:Number = 0;
			for (var i = 0; i < collisionAccuracy; i++)
			{
				lastCollisionPoints.push(new Point(this.x + Math.cos(currentAngle) * this.width / 2, this.y + Math.sin(currentAngle) * this.width / 2));
				currentAngle += step;
			}
			
			currentUnpaintedBounces = maxUnpaintedBounces;
			currentPaintedBounces = maxPaintedBounces;
			
			// init timer
			colTimer = new Timer(collisionCooldown, 1);
			colTimer.addEventListener(TimerEvent.TIMER_COMPLETE, ResetCol);
			canCollide = true;
		}
		
		// called after collision cooldown has elapsed
		public function ResetCol(e:TimerEvent)
		{
			canCollide = true;
		}
		
		public function stopHitAnimation(event:TimerEvent)
		{
			Game.instance.level.currentTarget.hit.visible = false;
			// move the ghost to the next location
			Game.instance.level.updateCurrentTarget(Game.instance.level.ghostHitCount + 1);
			animationIsPlaying = false;
		}
		
		override public function Update(deltaTime:Number)
		{
			var i:int;
			var step:Number;
			var currentAngle:Number;
	
			// test collision with target, if hit the level is won
			if (Game.instance.level.currentTarget.idle.hitTestObject(this) && animationIsPlaying == false )
			{	
				// run animations	
				animationIsPlaying = true;
				Game.instance.level.currentTarget.hit.visible = true;
				Game.instance.level.currentTarget.idle.visible = false;
				animTimer = new Timer(hitAnimationTime, 1);
				animTimer.start();
				animTimer.addEventListener(TimerEvent.TIMER_COMPLETE, stopHitAnimation);
				
				//play sound
				Game.instance.hitGhostFanFareSound.play();
				Game.instance.paintHitGhostSound.play();
				// update ghost hit counter, remove ball from stage and update list and update the shot counter
				Game.instance.level.ghostHitCount++;
				if (Game.instance.level.ghostHitCount == Game.instance.level.ghostHitWinNumber)
				{
					Game.instance.level.winLevel();
				}
				else
				{
					//removes the ball from the stage and from the updateobject list
					RemoveBall();
					Game.instance.level.shotsLeft += Game.instance.level.extraShotsLeft;
					if (Game.instance.level.outOfShots == true)
					{
						Game.instance.level.outOfShots == false;
						Game.instance.level.assetClip.player.onUnpause();
					}
					Game.instance.level.assetClip.shotsLeftText.text = ("X " +Game.instance.level.shotsLeft);	
				}
			}
			
			// test collision with props, paint on hit
			for (i = 0; i < Game.instance.level.props.length; i++)
			{
				var prop:Prop = Game.instance.level.props[i];
				if (!prop.hasBeenPainted && prop.hitTestObject(this))
				{
					Game.instance.level.paintManager.FillPaintBlock(PaintObject(prop));
					// play splatter sound
					Game.instance.impactSound.play();
					prop.hasBeenPainted = true;
					
					if (prop is StoryProp)
					{
						switch(prop.parent.name)
						{
							// set story prop flags
							case "storyprop1":
								Game.instance.level.storyProp1Hit = true;
								break;
							case "storyprop2":
								Game.instance.level.storyProp2Hit = true;
								break;
							case "storyprop3":
								Game.instance.level.storyProp3Hit = true;
								break;
						}
						Game.instance.itemFindSound.play();
					}
				}
			}
			
			
			// collide with objects in the world
			collisionNormals = new <Point>[];
			var hasCollided:Boolean = false;
			for (i = 0; i < Game.instance.level.collisionObjects.length; i++)
			{
				// no point iterating the loop if the ball cannot collide
				if (!canCollide)
				{
					break;
				}
				
				// first pass - if no collision with the collider's bounding box, go to next collider
				var colObject = Game.instance.level.collisionObjects[i];
				if (!colObject.hitTestObject(this))
				{
					continue;
				}
				
				// second pass - check line intersection of ball movement lines with collider lines
				step = 2 * Math.PI / collisionAccuracy;
				currentAngle = 0;
				// form and iterate through each of the ball movement lines
				for (var j = 0; j < collisionAccuracy; j++)
				{
					var ballPath:Line = new Line(lastCollisionPoints[j], new Point(this.x + Math.cos(currentAngle) * this.width / 2, this.y + Math.sin(currentAngle) * this.width / 2));
					// check each movement line against each collider line
					for (var k = 0; k < colObject.lines.length; k++)
					{
						// get intersection of movement line and collider line
						var collisionPoint:Point = Line.Intersect(ballPath.a, ballPath.b, colObject.lines[k].a, colObject.lines[k].b);
						// collisionPoint is set when there is a intersection (and therefore a collision)
						if (collisionPoint != null)
						{
							// if there is a new collision, spawn a paint splatter
							if (!hasCollided)
							{
								if (Game.instance.level.paintManager.PointHasPaint(collisionPoint, paintHitThreshold))
								{
									if (--currentPaintedBounces <= 0)
									{
										RemoveBall();
									}
									else
									{
										Game.instance.bounceSound.play();
									}
								}
								else
								{
									if (--currentUnpaintedBounces <= 0)
									{
										RemoveBall();
									}
									else
									{
										Game.instance.bounceSound.play();
									}
								}
								Game.instance.level.paintManager.AddPaintSplatter(collisionPoint);
								// play splatter sound
								Game.instance.impactSound.play();
								hasCollided = true;
							}
							collisionNormals.push(colObject.lines[k].Normal());
						}
					}
					
					currentAngle += step;
				}
			}
			
			// collision resolution
			if (collisionNormals.length > 0)
			{
				// if there was a collision, start the collision cooldown timer and disable collision
				colTimer.start();
				canCollide = false;
			}
			
			// construct an aggregate normal from all of collision point normals hit
			var finalNormal:Point = new Point();
			for (i = 0; i < collisionNormals.length; i++)
			{
				finalNormal = finalNormal.add(collisionNormals[i]);
			}
			finalNormal.normalize(1);
			
			// reflect velocity across normal (no speed is lost)
			var vec:Point = velocity.clone();
			var n:Point = finalNormal.clone();
			var vDotN:Number = vec.x * finalNormal.x + vec.y * finalNormal.y;
			n.normalize(2 * vDotN);
			velocity = vec.subtract(n);
			
			// update collision points
			step = 2 * Math.PI / collisionAccuracy;
			currentAngle = 0;
			for (i = 0; i < collisionAccuracy; i++)
			{
				lastCollisionPoints[i].x = this.x + Math.cos(currentAngle) * this.width / 2; 
				lastCollisionPoints[i].y = this.y + Math.sin(currentAngle) * this.width / 2;
				currentAngle += step;
			}
			
			// apply velocity
			this.x += velocity.x * 0.016;
			this.y += velocity.y * 0.016;
		}
		
		private function RemoveBall()
		{
			for (var i = 0; i < Game.instance.level.updateObjects.length; i++)
			{
				if (Game.instance.level.updateObjects[i] == this)
				{
					Game.instance.level.removeFromStage(this);
					Game.instance.level.updateObjects.removeAt(i);
				}
			}
		}
	}
}