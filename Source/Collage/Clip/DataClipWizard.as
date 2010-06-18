package Collage.Clip
{
	import spark.components.SkinnableContainer;
	import mx.events.PropertyChangeEvent;
	import Collage.DataEngine.*;
	import flash.utils.*;
	
	public class DataClipWizard extends SkinnableContainer
	{
		[Bindable]public var clip:DataClip;
		[Bindable]public var query:DataQuery;
		[Bindable]public var queryDefinition:QueryDefinition;
		
		public function DataClipWizard():void {
			
		}
	}
}
