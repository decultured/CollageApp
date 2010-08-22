package Collage.Clips.WordCloudClip
{
	import Collage.Clip.*;
	import Collage.DataEngine.*;
	import Collage.Utilities.Logger.*;
	import mx.events.PropertyChangeEvent;
	import mx.collections.ArrayList;
	
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	
	import com.endlesspaths.components.GradientColorEntry;
	
	public class WordCloudClip extends DataClip
	{
		//[Bindable][Savable] public var loaded:Boolean = "";
		[Bindable][Savable] public var maxSize:Number = 36;
		[Bindable][Savable] public var minSize:Number = 10;
		[Bindable][Savable] public var maxSizeValue:Number = 1;
		[Bindable][Savable] public var minSizeValue:Number = 0;

		[Bindable][Savable] public var selectedColors:ArrayList = new ArrayList();
		
		[Bindable][Savable] public var maxColorValue:Number = 100;
		[Bindable][Savable] public var minColorValue:Number = 0;
		
		[Bindable][Savable] public var horizontalAlignment:String = "center";
		[Bindable][Savable] public var verticalAlignment:String = "middle";
		
		[Bindable][Savable] public var text:String = "";
		[Bindable][Savable] public var colorValue:String = "";
		[Bindable][Savable] public var sizeValue:String = "";

		public function WordCloudClip()
		{
			super(WordCloudClipSkin, WordCloudClipEditor);
			type = "wordcloud";
			rotatable = false;

			// Initialize Gradient
			selectedColors.addItem(new GradientColorEntry(1.0, 0xff0000, 0.0));
			selectedColors.addItem(new GradientColorEntry(1.0, 0xaaaaaa, 0.5));
			selectedColors.addItem(new GradientColorEntry(1.0, 0x00ff00, 1.0));
			
			selectedColors.addEventListener(CollectionEvent.COLLECTION_CHANGE, CollectionUpdated);
			
			_QueryDefinition.queryTitle = "Word Cloud";
			_QueryDefinition.queryDescription = "Data setup for the Word Cloud";
			_QueryDefinition.minRowsReturned = 2;
			_QueryDefinition.maxRowsReturned = 250;
			var newQFD:QueryFieldDefinition = new QueryFieldDefinition(_QueryDefinition);
			newQFD.internalName = "text";
			newQFD.title = "Words";
			newQFD.groupable = true;
			newQFD.description = "This field defines the text for each label in the cloud.";
			newQFD.AddAllowedType("string");
			_QueryDefinition.AddFieldDefinition(newQFD);
			newQFD = new QueryFieldDefinition(_QueryDefinition);
			newQFD.internalName = "colorValue";
			newQFD.title = "Color Modifier";
			newQFD.description = "This field defines the number range for coloring the labels of the chart.";
			newQFD.AddAllowedType("numeric");
			_QueryDefinition.AddFieldDefinition(newQFD);
			newQFD = new QueryFieldDefinition(_QueryDefinition);
			newQFD.internalName = "sizeValue";
			newQFD.title = "Size Modifier";
			newQFD.description = "This field defines the number range for sizing the labels of the chart.";
			newQFD.AddAllowedType("numeric");
			_QueryDefinition.AddFieldDefinition(newQFD);
			query.postSortInternalName = "text";
		}

		override protected function QueryCompleteHandler(event:Event):void
		{
			maxSizeValue = Number.NEGATIVE_INFINITY;
			minSizeValue = Number.POSITIVE_INFINITY;
			maxColorValue = Number.NEGATIVE_INFINITY;
			minColorValue = Number.POSITIVE_INFINITY;
			
			Logger.LogDebug("Adjusting Value Ranges", this);
			
			for (var rowIdx:int = 0; rowIdx < query.resultRows.length; rowIdx++) {
				var rowObj:Object = query.resultRows.getItemAt(rowIdx);
				if (!rowObj) continue;

				//Logger.Log("Color Name: " + colorValue + "Color Val: " + rowObj[colorValue] + " Size Name: " + sizeValue + " Size Val: " + rowObj[sizeValue], this);
					
				if (rowObj[colorValue]) {
					if (rowObj[colorValue] > maxColorValue) maxColorValue = rowObj[colorValue];
					else if (rowObj[colorValue] < minColorValue) minColorValue = rowObj[colorValue];
				}
				
				if (rowObj[sizeValue]) {
					if (rowObj[sizeValue] > maxSizeValue) maxSizeValue = rowObj[sizeValue];
					else if (rowObj[sizeValue] < minSizeValue) minSizeValue = rowObj[sizeValue];
				}
			}
			
			return;
		}
		
		protected function CollectionUpdated(event:CollectionEvent):void {
			var change:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
			change.kind = CollectionEventKind.RESET;
			query.resultRows.dispatchEvent(change);
			
			Logger.LogDebug('Collection Updated!!!!!!!!1');
		}
		
		protected override function ModelChanged(event:PropertyChangeEvent):void
		{
			switch( event.property )
			{
				case "text":
					return;
			}

			super.ModelChanged(event);
		}
		
		public override function LoadFromObject(dataObject:Object):Boolean
		{
			var result:Boolean = super.LoadFromObject(dataObject);
			QueryCompleteHandler(null);
			
			return result;
		}
	}
}
