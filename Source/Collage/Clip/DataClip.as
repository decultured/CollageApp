package Collage.Clip
{
	import mx.events.PropertyChangeEvent;
	import Collage.DataEngine.*;
	import Collage.Application.*;
	import flash.utils.*;
	import Collage.Clip.Skins.*;
	import Collage.Utilities.Logger.*;
	
	public class DataClip extends Clip
	{
		protected var _QueryDefinition:QueryDefinition;
		[Bindable]public var query:DataQuery = new DataQuery();

        [Bindable]public var datasetID:String = null;
		[Bindable]public var datasetFields:Object = new Object();

		public function DataClip(_clipViewSkin:Class, _clipEditorSkin:Class, _smallClipEditorSkin:Class = null):void
		{
			super(_clipViewSkin, _clipEditorSkin, _smallClipEditorSkin);
			_QueryDefinition = new QueryDefinition(this);
			query.addEventListener(DataQuery.FIELDS_CHANGED, QueryFieldsChangedHandler);
		}

		public function ClearFields():void
		{
			datasetFields = new Object;
		}
		
		public function SetField(internalName:String, fieldName:String):void
		{
			datasetFields[internalName] = fieldName;
		}
		
		protected function QueryFieldsChangedHandler(event:Event):void
		{
			for (var key:String in query.fields)
			{
				if (!this.hasOwnProperty(key))
					continue;

				var field:DataQueryField = query.fields[key] as DataQueryField;
				
				var oldVal:String = null;
				if (field.alias)
					this[key] = field.alias;
				else
					this[key] = field.name;
				Logger.LogDebug("dataClip Key: " + key + " val: " + this[key]);
				
//				var evt:PropertyChangeEvent = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
//				evt.property = key;
				dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, key, oldVal, this[key]));
			}
		}

		protected override function ModelChanged(event:PropertyChangeEvent):void
		{
			switch( event.property )
			{
				case "":
					return;
			}

			super.ModelChanged(event);
		}
		
		public function OpenDataWizard():void {
			var dataWizard:DataClipWizard = new DataClipWizard();
			dataWizard.clip = this;
			dataWizard.query = query;
			dataWizard.queryDefinition = _QueryDefinition; 
			dataWizard.setStyle("skinClass", DataClipWizardSkin);
			dataWizard.setStyle("top", "0");
			dataWizard.setStyle("bottom", "0");
			dataWizard.setStyle("left", "0");
			dataWizard.setStyle("right", "0");

			CollageApp.instance.OpenPopup(dataWizard, "datawizard");
		}
		
		public override function SaveToObject(onlyTheme:Boolean = true):Object
		{
			var typeDef:XML = describeType(this);
			var newObject:Object = new Object();
			for each (var metadata:XML in typeDef..metadata) {
				if (metadata["@name"] != "Savable")
					continue;
				if (onlyTheme) {
					var isTheme:Boolean = false;
					for each (var args:XML in metadata..arg) {
						if (args["@key"] == "theme" && args["@value"] == "true") {
							isTheme = true;
							break;
						}
					}
					if (!isTheme)
						continue;
				}
				if (this.hasOwnProperty(metadata.parent()["@name"])) {
					newObject[metadata.parent()["@name"]] = this[metadata.parent()["@name"]];
				}
			}

			return newObject;
		}

		public override function LoadFromObject(dataObject:Object):Boolean
		{
			if (!dataObject) return false;

			for(var obj_k:String in dataObject) {
				try {
					if(this.hasOwnProperty(obj_k))
						this[obj_k] = dataObject[obj_k];
				} catch(e:Error) { }
			}
			return true;
		}
	}
}
