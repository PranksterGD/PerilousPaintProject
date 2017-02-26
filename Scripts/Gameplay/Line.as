package
{
	import flash.geom.Point;
	
	// a line is a data structure that contains two points, that represent two endpoints on a line
	public class Line
	{
		// the two endpoints of the line
		public var a:Point;
		public var b:Point;
		
		public function Line(a:Point, b:Point)
		{
			this.a = a;
			this.b = b;
		}
		
		// tests for intersection with another line, returns the intersection point
		public static function Intersect(a:Point, b:Point, c:Point, d:Point):Point
		{
			if ((a.x == b.x && a.y == b.y) || (c.x == d.x && c.y == d.y)) return null;
			if (a == c || a == d || b == c || b == d) return null;
			
			b = b.clone();
			c = c.clone();
			d = d.clone();
			
			b.offset(-a.x, -a.y);
			c.offset(-a.x, -a.y);
			d.offset(-a.x, -a.y);
			
			var distAB:Number = b.length;
			var cos:Number = b.x / distAB;
			var sin:Number = b.y / distAB;
			
			c = new Point(c.x * cos + c.y * sin, c.y * cos - c.x * sin);
			d = new Point(d.x * cos + d.y * sin, d.y * cos - d.x * sin);
			
			if ((c.y < 0 && d.y < 0) || (c.y >= 0 && d.y >= 0)) return null;
			
			var ABpos:Number = d.x + (c.x - d.x) * d.y / (d.y - c.y);
			
			if (ABpos < 0 || ABpos > distAB) return null;
			
			return new Point(a.x + ABpos * cos, a.y + ABpos * sin);
		}
		
		// gets the normal to this line
		public function Normal():Point
		{
			var p:Point = b.subtract(a);
			var normal = new Point(-p.y, p.x);
			normal.normalize(1);
			
			return normal;
		}
	}
}