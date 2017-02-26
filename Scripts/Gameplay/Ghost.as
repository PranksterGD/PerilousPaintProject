package
{
	import flash.accessibility.Accessibility;
	import flash.display.MovieClip;
	
	// identifies that this object is a target
	public class Ghost extends MovieClip
	{
		public var hit:Hit;
		public var appear:Appear;
		public var idle:Idle;
		public function Ghost()
		{
			super();
		}
	}
}