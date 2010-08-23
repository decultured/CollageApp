package Collage.Clips.Map
{
	import com.endlesspaths.components.GradientColorEntry;
	import spark.components.SkinnableContainer;
	import Collage.DataEngine.*;
	import Collage.Application.*;
	import Collage.Utilities.Logger.*;
	import Collage.Utilities.Geom.*;
	import Collage.Clip.*;
	import mx.events.PropertyChangeEvent;
	import mx.collections.IList;
	import mx.collections.ArrayList;
	import mx.graphics.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.net.*;
	import flash.geom.*;

	public class MapClip extends DataClip
	{
		private var _CloudMap:CloudMap;

		[Bindable]public var objects:ArrayList = new ArrayList();
		[Bindable]public var lineOverlays:ArrayList = new ArrayList();

		[Bindable]public var mapBounds:Rectangle = new Rectangle();
		[Bindable]public var renderScale:Number = 10000;

		[Bindable]public var names:Object = new Object();

		[Bindable]public var selectedObject:int = -1;
		
		[Bindable]public var scaleX:Number = 0.001;
		[Bindable]public var scaleY:Number = 0.001;
		[Bindable]public var scaleAmount:Number = 0.5;

		[Bindable]public var nameField:String = "name";
		[Bindable]public var valueField:String = "name";

		[Bindable]public var colorGradient:ArrayList = new ArrayList();

		[Bindable]public var objectBorderColor:Number = 0xAB794A;
		[Bindable]public var objectBorderWeight:uint = 1;
		[Bindable]public var objectBorderAlpha:Number = 1;

		[Bindable]public var lineColor:Number = 0xbd5332;
		[Bindable]public var lineWeight:uint = 1;
		[Bindable]public var lineAlpha:Number = 1;

		[Bindable]public var defaultFillColor:Number = 0xc69c6d;
		[Bindable]public var defaultFillAlpha:Number = 1;
		
		[Bindable]public var hoverFillColor:Number = 0xa67c52;
		[Bindable]public var hoverFillAlpha:Number = 1;
		
		public function MapClip():void
		{
			super(MapClipSkin, MapClipEditor);
			type = "map";
			rotatable = false;
			aspectLocked = true;
			backgroundColor = 0x48FD6;
			backgroundAlpha = 0.5;
			
			// Initialize Gradient
			colorGradient.addItem(new GradientColorEntry(1.0, 0xff0000, 0.0));
			colorGradient.addItem(new GradientColorEntry(1.0, 0xaaaaaa, 0.5));
			colorGradient.addItem(new GradientColorEntry(1.0, 0x00ff00, 1.0));
			
			//colorGradient.addEventListener(CollectionEvent.COLLECTION_CHANGE, CollectionUpdated);
		}
	
		protected override function ModelChanged(event:PropertyChangeEvent):void
		{
			switch( event.property )
			{
				case "borderWeight":
				case "contentMargin":
					Resized();
					return;
			}

			super.ModelChanged(event);
		}

		public function New():void
		{
			objects.removeAll();
		}
		
		public override function Resized():void
		{
			if (!aspectRatio) aspectRatio = 1;
			
			super.Resized();
			
			var tempWidth:Number = width - ((borderWeight + contentMargin) * 2);
			
			if (tempWidth > 0)
				scaleAmount = tempWidth / 10000;
			else
				scaleAmount = 0.1;

			scaleX = scaleAmount;
			scaleY = scaleAmount;
		}
		
		public function addPolygon(pathString:String, displayName:String, namesArray:Array):void
		{
			var newObject:MapPolygon = new MapPolygon();

			newObject.pathData = pathString;
			newObject.percentWidth = 100;
			newObject.percentHeight = 100;
			
			if (displayName)
				displayName = displayName.replace(/^\s+|\s+$/g, '');
			else
				displayName = "Unknown";
			
			newObject.displayName = displayName;
			objects.addItem(newObject);
		}

		public function addPolyline(pathString:String, displayName:String, namesArray:Array):void
		{
			var newObject:MapPolyline = new MapPolyline();

			newObject.pathData = pathString;
			newObject.percentWidth = 100;
			newObject.percentHeight = 100;
			
			if (displayName)
				displayName = displayName.replace(/^\s+|\s+$/g, '');
			else
				displayName = "Unknown";
			
			newObject.displayName = displayName;
			lineOverlays.addItem(newObject);
		}
		
		public function CalculateBounds():void
		{
			var object:MapPolygon;

			var minX:Number = Number.POSITIVE_INFINITY;
			var maxX:Number = Number.NEGATIVE_INFINITY;
			var minY:Number = Number.POSITIVE_INFINITY;
			var maxY:Number = Number.NEGATIVE_INFINITY;

			for (var idx:uint = 0; idx < objects.length; idx++) {
				object = objects.getItemAt(idx) as MapPolygon;

				// ?????
				if (!object.polyUtil)
					return;					
				
				minX = Math.min(minX, object.polyUtil.polyBounds.x);
                maxX = Math.max(maxX, object.polyUtil.polyBounds.x + object.polyUtil.polyBounds.width);
                minY = Math.min(minY, object.polyUtil.polyBounds.y);
                maxY = Math.max(maxY, object.polyUtil.polyBounds.y + object.polyUtil.polyBounds.height);
			}

			mapBounds.x = minX;
			mapBounds.y = minY;
			mapBounds.width = maxX - minX;
			mapBounds.height = maxY - minY;
			if (!mapBounds.width) mapBounds.width = 0.01;
			if (!mapBounds.height) mapBounds.height = 0.01;
			aspectRatio = mapBounds.width / mapBounds.height;
			Resized();
			
			Logger.Log(minX + " " + maxX + " " + minY + " " + maxY, this);
		}
		
		public function GenerateObjects():void
		{
			var object:MapPolygon;

			var minX:Number = Number.POSITIVE_INFINITY;
			var maxX:Number = Number.NEGATIVE_INFINITY;
			var minY:Number = Number.POSITIVE_INFINITY;
			var maxY:Number = Number.NEGATIVE_INFINITY;

			for (var idx:uint = 0; idx < objects.length; idx++) {
				object = objects.getItemAt(idx) as MapPolygon;
				
				if (!object.polyUtil)
					continue;					
				
				object.pathData = object.polyUtil.BuildPathString(10000, aspectRatio, mapBounds);
			}
		}

		public function GenerateNameList():void
		{
			var object:MapPolygon;

			names = new Object();

			for (var idx:uint = 0; idx < objects.length; idx++) {
				object = objects.getItemAt(idx) as MapPolygon;
				
				names[object.displayName.toLowerCase()] = object.UID;
				
				for (var nIdx:uint = 0; nIdx < object.names.length; nIdx++) {
					names[object.names[nIdx].toLowerCase()] = object.UID;
				}
			}
		}
		
		public function SaveMapToObject(onlyTheme:Boolean = false):Object
		{
			var result:Object = new Object();
			result.polys = new Array();
			
			var poly:MapPolygon;
			for (var idx:uint = 0; idx < objects.length; idx++) {
				poly = objects.getItemAt(idx) as MapPolygon;
				if (!poly)
					continue;
					
				var polyObj:Object = new Object();
				polyObj.displayName = poly.displayName;
				polyObj.names = poly.names;
				polyObj.pathData = poly.pathData;
				result.polys.push(polyObj);
			}
			
			result.boundsX = mapBounds.x;
			result.boundsY = mapBounds.y;
			result.boundsWidth = mapBounds.width;
			result.boundsHeight = mapBounds.height;
			result.renderScale = renderScale;
			result.aspectRatio = aspectRatio;

			return result;
		}

		public function LoadMapFromObject(dataObject:Object):Boolean
		{
			New();

			if (dataObject.boundsX) mapBounds.x = dataObject.boundsX;
			if (dataObject.boundsY) mapBounds.y = dataObject.boundsY;
			if (dataObject.boundsWidth) mapBounds.width = dataObject.boundsWidth;
			if (dataObject.boundsHeight) mapBounds.height = dataObject.boundsHeight;
			if (dataObject.renderScale) renderScale = dataObject.renderScale;
			if (dataObject.aspectRatio) aspectRatio = dataObject.aspectRatio;
			
			if (!dataObject.polys || !dataObject.polys is Array)
				return false;
			
			for (var idx:uint = 0; idx < dataObject.polys.length; idx++) {
				var newPoly:MapPolygon = new MapPolygon();
				newPoly.percentWidth = 100;
				newPoly.percentHeight = 100;
				newPoly.displayName = dataObject.polys[idx].displayName;
				newPoly.names = dataObject.polys[idx].names;
				newPoly.pathData = dataObject.polys[idx].pathData;
				objects.addItem(newPoly);
			}
			
			Resized();

			return true;
		}
		
		public function SaveToCloud():void
		{
			if (!_CloudMap)
				_CloudMap = new CloudMap(CollageApp.instance, this);
			_CloudMap.Save();
		}
		
		public function OpenFromCloud(id:String = null):void
		{
			if (!_CloudMap)
				_CloudMap = new CloudMap(CollageApp.instance, this);
				
			if (id)
				_CloudMap.OpenMapByID(id);
			else
				_CloudMap.Open();
		}
		
	}
}