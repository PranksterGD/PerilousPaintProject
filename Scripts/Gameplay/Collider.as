package
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.display.GraphicsPath;
	import flash.display.IGraphicsData;
	
	public class Collider extends MovieClip
	{
		// a collider is simply a collection of lines
		public var lines:Vector.<Line>;
		
		public function Collider()
		{
			lines = new <Line>[];
			
			// construct the lines from the graphics path of the object
			var gd:Vector.<IGraphicsData> = graphics.readGraphicsData();
			var tempData:Number = 0;
			var tempPoint:Point = null;
			for (var i = 0; i < gd.length; i++)
			{
				if (gd[i] is GraphicsPath)
				{
					var gp = GraphicsPath(gd[i]);
					for (var j = 0; j < gp.data.length; j++)
					{
						// every data point is either x or y
						// therefore every 2 iterations, a new point will be added
						// if it's in between adding a point, the data is stored in a temp variable
						if (j % 2 == 0)
						{
							tempData = gp.data[j];
						}
						else
						{
							// every point added (after the first) will create a new line for the collider
							var newPoint = localToGlobal(new Point(tempData, gp.data[j]));
							if (j > 1)
							{
								lines.push(new Line(tempPoint, newPoint));
							}
							tempPoint = newPoint;
						}
					}
				}
			}
		}
	}
}