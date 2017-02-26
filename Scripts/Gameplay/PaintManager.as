package
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	public class PaintManager extends UpdateObject
	{
		// list of display objects that can have paint drawn on them
		private var paintBlocks:Vector.<PaintBlock>;
		// list of paint splatters that are active in the game
		private var paintSplatters:Vector.<PaintSplatter>;
		
		// the color of the details of the objects
		public const detailColor:uint = 0xFFFFFFFF;
		
		public function PaintManager()
		{
			paintBlocks = new <PaintBlock>[];
			paintSplatters = new <PaintSplatter>[];
		}
		
		// adds a paint object to the paint manager, creating the data necessary to paint on it
		public function AddPaintBlock(paintObj:PaintObject, detailObj:DetailObject = null)
		{
			// duplicates the block to use as a mask
			var paintClass:Class = Object(paintObj).constructor;
			var maskObj:PaintObject = new paintClass();
			
			// creates a new paint block (this will also add it to the stage)
			paintBlocks.push(new PaintBlock(paintObj, maskObj, detailObj));
		}
		
		// creates a paint splatter at the point specified
		public function AddPaintSplatter(p:Point)
		{
			paintSplatters.push(new PaintSplatter(p));
		}
		
		override public function Update(deltaTime:Number)
		{
			for (var i = 0; i < paintSplatters.length; i++)
			{
				paintSplatters[i].Update(deltaTime);
			}
		}
		
		// gets the paint blocks of the bounding boxes hit within a radius (threshold) of a point(p).
		public function GetPaintBlocksWithinTheshold(p:Point, threshold:Number):Vector.<PaintBlock>
		{
			var v:Vector.<PaintBlock> = new Vector.<PaintBlock>();
			for (var i = 0; i < paintBlocks.length; i++)
			{
				var block:MovieClip = paintBlocks[i].refObject;
				var blockBounds:Rectangle = block.getBounds(Game.instance.stage);
				var dx = Math.max(Math.min(p.x, blockBounds.x + blockBounds.width), blockBounds.x);
				var dy = Math.max(Math.min(p.y, blockBounds.y + blockBounds.height), blockBounds.y);
				var dist = (p.x - dx) * (p.x - dx) + (p.y - dy) * (p.y - dy);
				if (dist < (threshold * threshold))
				{
					v.push(paintBlocks[i]);
				}
			}
			
			return v;
		}
		
		// checks if a radius (threshold) of a point (p) has paint (a non-transparent bitmap color)
		public function PointHasPaint(p:Point, threshold:Number):Boolean
		{
			var v:Vector.<PaintBlock> = GetPaintBlocksWithinTheshold(p, threshold);
			for (var i = 0;  i < v.length; i++)
			{
				var bMap:Bitmap = v[i].bitmap;
				
				// clamp point to bitmap
				var posX:Number = Math.max(bMap.x, Math.min(p.x, bMap.x + bMap.width - 1));
				var posY:Number = Math.max(bMap.y, Math.min(p.y, bMap.y + bMap.height - 1));
				for (var y = 0; y < threshold; y++)
				{
					for (var x = 0; x < threshold; x++)
					{
						var xIndex = posX + x - threshold / 2 - bMap.x;
						var yIndex = posY + y - threshold / 2 - bMap.y;
						// throw out points not in the bitmap
						if (xIndex < 0 || xIndex > bMap.width - 1 || yIndex < 0 || yIndex > bMap.height - 1)
						{
							continue;
						}
						// check if the color of the pixel is not full transparent black (which is the default)
						if (bMap.bitmapData.getPixel32(xIndex, yIndex) > 0)
						{
							return true;
						}
					}
				}
			}
			
			return false;
		}
		
		// fills a paint block with a random color
		public function FillPaintBlock(obj:PaintObject)
		{
			for (var i = 0; i < paintBlocks.length; i++)
			{
				if (paintBlocks[i].refObject is Prop && Prop(paintBlocks[i].refObject) == obj)
				{
					var block:PaintBlock = paintBlocks[i];
					block.bitmapData.floodFill(0, 0, 0xFF << 24 | (Math.random() * 0xFFFFFF));
					if (paintBlocks[i].detailObject != null)
					{
						block.bitmap.bitmapData.threshold(block.detailBitmapData, new Rectangle(0, 0, block.detailBitmapData.width, block.detailBitmapData.height), new Point(0, 0), ">", 0xFF000000, detailColor);
					}
					break;
				}
			}
		}
	}
}

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.Stage;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

class PaintBlock extends MovieClip
{
	// the actual art symbol in the level that is used as reference
	public var refObject:PaintObject;
	// the mask object that creates the shape of the paint
	public var maskObject:PaintObject;
	// the object that has the detail bitmap on it
	public var detailObject:DetailObject;
	// the bitmap that the paint is drawn on
	public var bitmap:Bitmap;
	// the data of the bitmap
	public var bitmapData:BitmapData;
	// the detail map that prevents paint from being applied
	public var detailBitmapData:BitmapData;
	// transparency of the alpha of props
	private const propAlpha:Number = 0.6;
	
	public function PaintBlock(refObject:PaintObject, maskObject:PaintObject, detailObject:DetailObject = null)
	{
		this.refObject = refObject;
		this.maskObject = maskObject;
		this.detailObject = detailObject;
		
		// initialize bitmap
		bitmapData = new BitmapData(maskObject.width, maskObject.height, true, 0x00000000);
		bitmap = new Bitmap(bitmapData);
		bitmap.mask = maskObject;
		
		if (detailObject != null)
		{
			// get the reference bitmap from the detail object symbol
			var bounds:Rectangle = detailObject.getBounds(detailObject);
			var refBitmap = new BitmapData(int(bounds.width + 0.5), int(bounds.height + 0.5), true, 0);
			refBitmap.draw(detailObject, new Matrix(1, 0, 0, 1, -bounds.x, -bounds.y));
			
			// resize the bitmap data into the size of the game object
			var m:Matrix = new Matrix();
			var scaleX:Number = refObject.width / refBitmap.width;
			var scaleY:Number = refObject.height / refBitmap.height;
			m.scale(scaleX, scaleY);
			detailBitmapData = new BitmapData(refBitmap.width * scaleX, refBitmap.height * scaleY, true, 0);
			detailBitmapData.draw(refBitmap, m, null, null, null, true);
			
			// set the detail object invisible, it's only being used as a reference
			this.detailObject.visible = false;
		}
		
		// fade props to make them visually different than obstacles
		if (refObject is Prop)
		{
			bitmap.alpha = propAlpha;
		}
		
		// center mask and bitmap on ref object
		var maskPos:Point;
		maskPos = refObject.localToGlobal(new Point(refObject.x, refObject.y));
		maskObject.x = maskPos.x;
		maskObject.y = maskPos.y;
		bitmap.x = refObject.getBounds(Game.instance.stage).x;
		bitmap.y = refObject.getBounds(Game.instance.stage).y;
		
		// add block to the stage
		Game.instance.level.assetClip.addChild(this);
		this.addChild(bitmap);
		this.addChild(maskObject);
	}
}

class PaintSplatter
{
	// splatter art config settings
	private const numSplatters:int = 8;
	private const minVel:Number = 100;
	private const maxVel:Number = 130;
	private const minAccel:Number = 200;
	private const maxAccel:Number = 600;
	private const minSize:Number = 10;
	private const maxSize:Number = 20;
	private const minDecayRate:Number = 30;
	private const maxDecayRate:Number = 50;
	private const minNumUpdates:Number = 3;
	private const maxNumUpdates:Number = 7;
	private const minDrawTime:Number = 0.05;
	private const maxDrawTime:Number = 0.1;
	
	// the color of the splatter
	private var color:uint;
	
	// parallel arrays for each splatter created. the data is used to modify parameters of the splatter over time
	var positions:Vector.<Point>;
	var accelerations:Vector.<Point>;
	var velocities:Vector.<Point>;
	var sizes:Vector.<Number>;
	var decayRates:Vector.<Number>;
	var numUpdates:Vector.<int>;
	var currentUpdates:Vector.<int>;
	var drawTimes:Vector.<Number>;
	var currentTimes:Vector.<Number>;
	
	
	public function PaintSplatter(p:Point)
	{
		// choose a random color for the paint splatter
		color = 0xFF << 24 | (Math.random() * 0xFFFFFF);
		
		positions = new <Point>[];
		velocities = new <Point>[];
		accelerations = new <Point>[];
		sizes = new <Number>[];
		decayRates = new <Number>[];
		numUpdates = new <int>[];
		currentUpdates = new <int>[];
		drawTimes = new <Number>[];
		currentTimes = new <Number>[];
		
		var step = 2 * Math.PI / numSplatters;
		for (var i = 0; i < numSplatters; i++)
		{
			positions.push(p);
			
			// acceleration in a random angle
			var randAngle:Number = Math.random() * 2 * Math.PI;
			var maxAccel:Number = Math.random() * (maxAccel - minAccel) + minAccel;
			accelerations.push(new Point(Math.cos(randAngle) * maxAccel, Math.sin(randAngle) * maxAccel)); 
			
			// velocity in the step angle
			var vel:Number = Math.random() * (maxVel - minVel) + minVel;
			velocities.push(new Point(Math.cos(i * step) * vel, Math.sin(i * step) * vel));
			
			// spawn size
			sizes.push(Math.random() * (maxSize - minSize) + minSize);
			
			// decay size over time
			decayRates.push(Math.random() * (maxDecayRate - minDecayRate) + minDecayRate);
			
			// total number of times to update the splatter point and draw
			numUpdates.push(int(Math.floor(Math.random() * (maxNumUpdates - minNumUpdates) + minNumUpdates)));
			// keeps track of how many updates have happened
			currentUpdates.push(0);
			
			// time between each update and draw
			drawTimes.push(Math.random() * (maxDrawTime - minDrawTime) + minDrawTime);
			// time since the last draw (set to the draw time to draw right away)
			currentTimes.push(drawTimes[i]);
		}
	}
	
	public function Update(deltaTime:Number)
	{
		for (var i = 0; i < numSplatters; i++)
		{
			// if the size is less than 2 pixels then the splatter is over
			if (sizes[i] <= 2)
			{
				continue;
			}
			
			// update the position, size, and current time of the splatter
			currentTimes[i] += deltaTime;
			velocities[i] = velocities[i].add(new Point(accelerations[i].x * deltaTime, accelerations[i].y * deltaTime));
			positions[i] = positions[i].add(new Point(velocities[i].x * deltaTime, velocities[i].y * deltaTime));
			sizes[i] -= decayRates[i] * deltaTime;
			
			// don't draw unless the draw timer has been reached
			if (currentTimes[i] < drawTimes[i])
			{
				continue;
			}
			else
			{
				// reset the draw timer
				currentTimes[i] = 0;
				// choose another random draw time
				drawTimes[i] = (Math.random() * (maxDrawTime - minDrawTime) + minDrawTime);
			}
			
			// dont draw if there are no more updates
			if (currentUpdates[i] >= numUpdates[i])
			{
				continue;
			}
			else
			{
				currentUpdates[i]++;
			}
			
			// radius of the splatter circle
			var r:Number = sizes[i];
			// diameter of the splatter circle
			var r2:Number = sizes[i] * 2;
			var currentBlocks:Vector.<PaintBlock> = Game.instance.level.paintManager.GetPaintBlocksWithinTheshold(positions[i], sizes[i]);
			for (var j = 0; j < currentBlocks.length; j++)
			{
				var bMap:Bitmap = currentBlocks[j].bitmap;
				// iterate through a square that contains the circle to be drawn in
				// start at the splatter position, offset by the radius.
				// the start position is relative to the bitmap position
				var startX:Number = positions[i].x - r - bMap.x;
				var startY:Number = positions[i].y - r - bMap.y;
				bMap.bitmapData.lock();
				for (var y = 0; y < r2; y++)
				{
					for (var x = 0; x < r2; x++)
					{
						var posX:Number = startX + x;
						var posY:Number = startY + y;
						// skip if position is not within the bitmap
						if (posX < 0 || posX > bMap.width || posY < 0 || posY > bMap.height)
						{
							continue;
						}
						else
						{
							// check distance to center of splatter, if within circle, then draw
							var dx:Number = posX + bMap.x - positions[i].x;
							var dy:Number = posY + bMap.y - positions[i].y;
							if (dx * dx + dy * dy < r * r)
							{
								if (currentBlocks[j].detailObject != null && currentBlocks[j].detailBitmapData.getPixel32(posX, posY) > 0xFF000000)
								{
									bMap.bitmapData.setPixel32(posX, posY, Game.instance.level.paintManager.detailColor);
								}
								else 
								{
									bMap.bitmapData.setPixel32(posX, posY, color);
								}
							}
						}
					}
				}
				bMap.bitmapData.unlock();
			}
		}
	}
}