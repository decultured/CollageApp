package Collage.Utilities.Geom
{
	import Collage.Utilities.Logger.*;

	import mx.collections.ArrayList;
	import flash.events.*;
	import flash.utils.*;
	import flash.geom.*;
	import flash.net.*;

	public class PolygonUtil
	{
		public var rings:ArrayList = new ArrayList();
		public var projectedRings:ArrayList = new ArrayList();
		public var polyBounds:Rectangle = new Rectangle();

		public var aspectRatio:Number = 1;
		
		public function PolygonUtil():void
		{
		}
		
		public function Reset():void
		{
		}
		
		public function LoadFromPathString(_pathData:String):void
		{
			
		}
		
		public function BuildPathString(_scale:Number, _aspectRatio:Number, _bounds:Rectangle):String
		{
			var pathString:String = "";
			var ring:ArrayList;
			var coord:Point;
			var finalCoord:Point;
			
			if (!_aspectRatio)
				_aspectRatio = 1;
			
			for (var rIdx:uint = 0; rIdx < rings.length; rIdx++) {
				ring = rings.getItemAt(rIdx) as ArrayList;
				for (var cIdx:uint = 0; cIdx < ring.length; cIdx ++) {
					coord = ring.getItemAt(cIdx) as Point;
					
					finalCoord = new Point();
					finalCoord.x = ((coord.x - _bounds.x) / _bounds.width) * _scale;
					finalCoord.y = (1 -((coord.y - _bounds.y) / _bounds.height)) * (_scale / _aspectRatio);

					if (cIdx == 0) {
						pathString += "M " + finalCoord.x.toFixed(0) + " " + finalCoord.y.toFixed(0) + " "; 
					} else {
						pathString += "L " + finalCoord.x.toFixed(0) + " " + finalCoord.y.toFixed(0) + " "; 
					}
				}
				pathString += "Z ";
			}
			return pathString;
		}
		
		public function FindBounds():void
		{
			var ring:ArrayList;
			var coord:Point;
			
			var minX:Number = Number.POSITIVE_INFINITY;
			var maxX:Number = Number.NEGATIVE_INFINITY;
			var minY:Number = Number.POSITIVE_INFINITY;
			var maxY:Number = Number.NEGATIVE_INFINITY;

			for (var rIdx:uint = 0; rIdx < rings.length; rIdx++) {
				ring = rings.getItemAt(rIdx) as ArrayList;
				for (var cIdx:uint = 0; cIdx < ring.length; cIdx ++) {
					coord = ring.getItemAt(cIdx) as Point;
					minX = Math.min(minX, coord.x);
	                maxX = Math.max(maxX, coord.x);
	                minY = Math.min(minY, coord.y);
	                maxY = Math.max(maxY, coord.y);
				}
			}

			polyBounds.x = minX;
			polyBounds.y = minY;
			polyBounds.width = maxX - minX;
			polyBounds.height = maxY - minY;
			if (!polyBounds.width) polyBounds.width = 0.01;
			if (!polyBounds.height) polyBounds.height = 0.01;
			aspectRatio = polyBounds.width / polyBounds.height;
		}
	}
}