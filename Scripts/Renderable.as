

package {
	
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;

	public class Renderable {
		
		protected var baseClip:MovieClip; // primary movie clip that all others attach to
		protected var parentClip:MovieClip; // parent of the base clip
		public var assetClip:MovieClip; // used to load external assets	
		private var incX:int;
		private var incY:int;
		public var loadComplete:Boolean;
				
		public function Renderable(argParentClip:MovieClip, argAssetPath:String) {	
			this.parentClip = argParentClip;
			
			// Create the base clip on the parent
			this.baseClip = new MovieClip();
			//this.parentClip.addChild(this.baseClip);
			
			// Create a loader and load the provided asset path
			var loader:Loader = new Loader();
			loader.load(new URLRequest(argAssetPath));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.CompletedExternalAssetLoad);
		}
		
		private function CompletedExternalAssetLoad(event:Event):void {
			// Assign the movie clip for the asset and center it on the base clip	
			this.assetClip = MovieClip(event.target.content);
			this.baseClip.addChild(this.assetClip);
			loadComplete = true;
			
			// Remove the event listener that triggered this call back
			event.target.removeEventListener(Event.COMPLETE, this.CompletedExternalAssetLoad);
			
			AddCustomListeners();
		}
		
		// override to add extra functionality after level is loaded
		public function AddCustomListeners()
		{
			
		}
	}     
}
