package Collage.Clips.Map
{
	import Collage.Utilities.Logger.*;
	import Collage.Clip.*;
	import Collage.Clips.Map.Skins.*;
	import spark.components.SkinnableContainer;
	import mx.events.PropertyChangeEvent;
	import mx.collections.IList;
	import mx.collections.ArrayList;
	import mx.graphics.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.net.*;

	public class MapClip extends DataClip
	{
		[Bindable]public var objects:ArrayList = new ArrayList();
		[Bindable]public var lineOverlays:ArrayList = new ArrayList();
		//[Bindable]public var aspectRatio:Number = 2;

		[Bindable]public var leftBounds:Number = 0;
		[Bindable]public var rightBounds:Number = 0;
		[Bindable]public var topBounds:Number = 0;
		[Bindable]public var bottomBounds:Number = 0;

		[Bindable]public var selectedObject:int = -1;
		
		[Bindable]public var viewWidth:Number = 100;
		[Bindable]public var viewHeight:Number = 100;
		[Bindable]public var scaleAmount:Number = 0.5;

		[Bindable]public var nameField:String = "name";
		[Bindable]public var valueField:String = "name";

		[Bindable]public var colorGradient:ArrayList = new ArrayList();

		[Bindable]public var objectBorderColor:Number = 0x534741;
		[Bindable]public var objectBorderWeight:uint = 1;
		[Bindable]public var objectBorderAlpha:Number = 1;

		[Bindable]public var lineColor:Number = 0xbd5332;
		[Bindable]public var lineWeight:uint = 1;
		[Bindable]public var lineAlpha:Number = 1;

		[Bindable]public var fillColor:Number = 0xc69c6d;
		[Bindable]public var fillAlpha:Number = 1;
		
//		[SkinPart(required="true")]
//		[Bindable]public var polyBorderStroke:IStroke;

//		[SkinPart(required="true")]
//		[Bindable]public var polylineStroke:IStroke;

		public function MapClip():void
		{
			super(MapClipSkin, MapClipEditor);
			type = "map";
			rotatable = false;
			
			// Initialize Gradient
			var gradEntry:Object = new Object();
			gradEntry.alpha = 1.0;
			gradEntry.color = 0xff0000;
			gradEntry.ratio = 0;
			colorGradient.addItem(gradEntry);

			gradEntry = new Object();
			gradEntry.alpha = 1.0;
			gradEntry.color = 0xaaaaaa;
			gradEntry.ratio = 0.5;
			colorGradient.addItem(gradEntry);

			gradEntry = new Object();
			gradEntry.alpha = 1.0;
			gradEntry.color = 0x00ff00;
			gradEntry.ratio = 1.0;
			colorGradient.addItem(gradEntry);
		}
	
		public function New():void
		{
			objects.removeAll();
			removeAllElements();
		}
		
		public function Resize():void
		{
			viewWidth = width;
			if (!aspectRatio)
				aspectRatio = 1;
			viewHeight = viewWidth / aspectRatio;
			
			if (width > 0)
				scaleAmount = width / 10000;
			else
				scaleAmount = 0.1;

			height = viewHeight;
			contentGroup.scaleX = scaleAmount;
			contentGroup.scaleY = scaleAmount;
			
			Logger.Log("Scale Changed! " + scaleAmount, this);
		}
		
		public function addPolygon(pathString:String, displayName:String, namesArray:Array):void
		{
			var newObject:MapPolygon = new MapPolygon();

			newObject.polyBorderStroke = polyBorderStroke;
			newObject.pathData = pathString;
			newObject.percentWidth = 100;
			newObject.percentHeight = 100;
			
			if (displayName)
				displayName = displayName.replace(/^\s+|\s+$/g, '');
			else
				displayName = "Unknown";
			
			newObject.displayName = displayName;
			addElement(newObject);
		}

		public function addPolyline(pathString:String, displayName:String, namesArray:Array):void
		{
			var newObject:MapPolyline = new MapPolyline();

			newObject.polylineStroke = polylineStroke;
			newObject.pathData = pathString;
			newObject.percentWidth = 100;
			newObject.percentHeight = 100;
			
			if (displayName)
				displayName = displayName.replace(/^\s+|\s+$/g, '');
			else
				displayName = "Unknown";
			
			newObject.displayName = displayName;
			addElement(newObject);
		}
	}
}