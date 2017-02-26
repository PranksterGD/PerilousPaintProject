package 
{
	import flash.display.MovieClip;
	
	// any object that can needs to be updated every frame
	public class UpdateObject extends MovieClip 
	{
		public function UpdateObject()
		{
			super();
		}
		
		// override this function to have actions called every frame
		public function Update(deltaTime:Number)
		{
			
		}
	}
}