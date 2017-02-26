package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	public class Player extends UpdateObject
	{
		// how far from the center of the object the ball is spawned
		private const spawnDist:Number = 80;
		// the speed of the ball (Default 300)
		private const shootSpeed:Number = 600;
		private var clip:MovieClip;
		private var shootTimer:Timer;
		
		private const shootDuration:Number = 300;
		
		public function Player()
		{
			Game.instance.stage.addEventListener(MouseEvent.CLICK, OnMouseClick);
			for (var i = 0; i < this.numChildren; i++)
			{
				if (this.getChildAt(i) is Gun_Anim)
				{
					clip = MovieClip(this.getChildAt(i));
					clip.gotoAndStop(1);
				}
			}
			shootTimer = new Timer(shootDuration, 1);
			shootTimer.addEventListener(TimerEvent.TIMER_COMPLETE, StopAnimation);
		}
		
		override public function Update(deltaTime:Number)
		{
			var mouseDir:Point = new Point(stage.mouseX - this.x, stage.mouseY - this.y);
			mouseDir.normalize(1);
			// rotate the player based on mouse position
			if (stage.mouseX > 0 && stage.mouseX < stage.stageWidth)
			{
				this.rotation = 90 + Math.atan2(mouseDir.y, mouseDir.x) * 180 / Math.PI;
			}
		}
		
		public function OnMouseClick(e:Event)
		{
			ShootBall();
		}
		
		public function ShootBall()
		{
			clip.gotoAndPlay(1);
			shootTimer.start();
			
			// create ball at current rotation + spawn distance
			var b = new Ball(Game.instance.level.updateObjects.length);
			var angle = Math.PI - ((this.rotation + 90) / 180 * Math.PI);
			b.x = this.x + Math.cos(angle) * spawnDist;
			b.y = this.y - Math.sin(angle) * spawnDist;
			
			// apply velocity to ball
			b.velocity = new Point(Math.cos(angle) * shootSpeed, -Math.sin(angle) * shootSpeed);
			
			// add ball to world
			Game.instance.level.addToStage(b)
			
			Game.instance.level.updateObjects.push(b);
			Game.instance.level.updateShots();
			
			// play ball shot sound
			Game.instance.shootSound.play();
		}
		
		public function cleanUp()
		{
			Game.instance.stage.removeEventListener(MouseEvent.CLICK, OnMouseClick);
		}
		
		public function onUnpause()
		{
			Game.instance.stage.addEventListener(MouseEvent.CLICK, OnMouseClick);
		}
		
		private function StopAnimation(e:TimerEvent)
		{
			clip.gotoAndStop(1);
		}
	}
}