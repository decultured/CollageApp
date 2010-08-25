package Collage.Clips.GraphClip
{
	import Collage.Clip.*;
	import Collage.DataEngine.*;
	import Collage.Application.*;
	import Collage.Clip.DataClipWizard.*;
	import Collage.Utilities.Logger.*;
	import flash.utils.*;
	import mx.events.PropertyChangeEvent;
	
	import flare.vis.data.Data;
	import flare.vis.data.NodeSprite;
	import flare.vis.data.Data;
		
	public class GraphClip extends Clip
	{
		[Bindable]public var graphData:Data;

		protected var _NodesQueryDefinition:QueryDefinition;
		[Bindable]public var nodesQuery:DataQuery = new DataQuery();
        [Bindable][Savable]public var nodesDatasetID:String = null;
		[Bindable][Savable]public var nodesDatasetFields:Object = new Object();

		protected var _EdgesQueryDefinition:QueryDefinition;
		[Bindable]public var edgesQuery:DataQuery = new DataQuery();
        [Bindable][Savable]public var edgesDatasetID:String = null;
		[Bindable][Savable]public var edgesDatasetFields:Object = new Object();

		[Bindable][Savable] public var nodeID:String = "";
		[Bindable][Savable] public var nodeTitle:String = "";
		[Bindable][Savable] public var edgeFrom:String = "";
		[Bindable][Savable] public var edgeTo:String = "";

		public function GraphClip()
		{
			super(GraphClipSkin, GraphClipEditor);
			type = "graph";
			_NodesQueryDefinition = new QueryDefinition();
			nodesQuery.addEventListener(DataQuery.FIELDS_CHANGED, NodesQueryFieldsChangedHandler, false, 0, true);
			nodesQuery.addEventListener(DataQuery.COMPLETE, QueryCompleteHandler, false, 0, true);
			_EdgesQueryDefinition = new QueryDefinition();
			edgesQuery.addEventListener(DataQuery.FIELDS_CHANGED, EdgesQueryFieldsChangedHandler, false, 0, true);
			edgesQuery.addEventListener(DataQuery.COMPLETE, QueryCompleteHandler, false, 0, true);
			
			_NodesQueryDefinition.queryTitle = "Graph Nodes";
			_NodesQueryDefinition.queryDescription = "Data setup for the Graph's Nodes";
			_NodesQueryDefinition.minRowsReturned = 2;
			_NodesQueryDefinition.maxRowsReturned = 100;
			var newQFD:QueryFieldDefinition = new QueryFieldDefinition(_NodesQueryDefinition);
			newQFD.internalName = "nodeID";
			newQFD.title = "Node ID";
			newQFD.groupable = true;
			newQFD.description = "This field defines the node ID of the an object of the graph.  This should correspond to identifiers in the Edges query.";
			newQFD.AddAllowedType("numeric");
			_NodesQueryDefinition.AddFieldDefinition(newQFD);
			newQFD = new QueryFieldDefinition(_NodesQueryDefinition);
			newQFD.internalName = "nodeTitle";
			newQFD.title = "Title";
			newQFD.description = "This field defines the Title of each node.";
			newQFD.AddAllowedType("string");
			_NodesQueryDefinition.AddFieldDefinition(newQFD);
			
			_EdgesQueryDefinition.queryTitle = "Graph Edges";
			_EdgesQueryDefinition.queryDescription = "Data setup for the Graph's Edges";
			_EdgesQueryDefinition.minRowsReturned = 2;
			_EdgesQueryDefinition.maxRowsReturned = 500;
			newQFD = new QueryFieldDefinition(_EdgesQueryDefinition);
			newQFD.internalName = "edgeFrom";
			newQFD.title = "From ID";
			newQFD.groupable = true;
			newQFD.description = "This field defines the id of the node a link comes from.";
			newQFD.AddAllowedType("numeric");
			_EdgesQueryDefinition.AddFieldDefinition(newQFD);
			newQFD = new QueryFieldDefinition(_EdgesQueryDefinition);
			newQFD.internalName = "edgeTo";
			newQFD.title = "To ID";
			newQFD.description = "This field defines the id of the node a link connects to.";
			newQFD.AddAllowedType("numeric");
			_EdgesQueryDefinition.AddFieldDefinition(newQFD);
			
			nodesQuery.updateInterval = 0;
			edgesQuery.updateInterval = 0;
		}
		
		protected function ProcessResults():void
		{
			if (!nodesQuery.loaded || !edgesQuery.loaded || !nodesQuery.resultRows || !nodesQuery.resultRows.length || !edgesQuery.resultRows) {
				return;
			}
				
			var nodesDictionary:Object = new Object();
			var idx:uint = 0;
			var row:Object;
	        var g:Data = new Data();
			
			for (idx = 0; idx < nodesQuery.resultRows.length; idx++)
			{
				row = nodesQuery.resultRows.getItemAt(idx);
				if (row.hasOwnProperty(nodeID)) {
					var r:NodeSprite = g.addNode();
					r.x = width * 0.5;
					r.y = height * 0.5;
					if (row.hasOwnProperty(nodeTitle))
			        	r.data.label = row[nodeTitle].substring(0,10);
					nodesDictionary[row[nodeID]] = r;
					Logger.Log("New Node: " + row[nodeID]);
				}					
			}
			
			for (idx = 0; idx < edgesQuery.resultRows.length; idx++)
			{
				row = edgesQuery.resultRows.getItemAt(idx);
				if (!row.hasOwnProperty(edgeFrom) || !row.hasOwnProperty(edgeTo))
					continue;
				if (!nodesDictionary[row[edgeFrom]] || !nodesDictionary[row[edgeTo]])
					continue;
				g.addEdgeFor(nodesDictionary[row[edgeFrom]], nodesDictionary[row[edgeTo]]);
				Logger.Log("New Edge: " + row[edgeFrom] + ", " + row[edgeTo]);
			}
			graphData = g;
		}		
		
		public function ClearFields():void
		{
			nodesDatasetFields = new Object;
			edgesDatasetFields = new Object;
		}
		
		public function SetNodeField(internalName:String, fieldName:String):void
		{
			nodesDatasetFields[internalName] = fieldName;
		}

		public function SetEdgeField(internalName:String, fieldName:String):void
		{
			edgesDatasetFields[internalName] = fieldName;
		}

		protected function QueryCompleteHandler(event:Event):void
		{
			ProcessResults();
			return;
		}
		
		protected function NodesQueryFieldsChangedHandler(event:Event):void
		{
			for (var i:int = 0; i < nodesQuery.fields.length; i++)
			{
				var field:DataQueryField = nodesQuery.fields.getItemAt(i) as DataQueryField;
								
				if (!field || !field.internalName || !this.hasOwnProperty(field.internalName))
					continue;

				var oldVal:String = this[field.internalName];
				this[field.internalName] = field.resultName;
				dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, field.internalName, oldVal, this[field.internalName]));
			}
		}
		
		protected function EdgesQueryFieldsChangedHandler(event:Event):void
		{
			for (var i:int = 0; i < edgesQuery.fields.length; i++)
			{
				var field:DataQueryField = edgesQuery.fields.getItemAt(i) as DataQueryField;
								
				if (!field || !field.internalName || !this.hasOwnProperty(field.internalName))
					continue;

				var oldVal:String = this[field.internalName];
				this[field.internalName] = field.resultName;
				dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, field.internalName, oldVal, this[field.internalName]));
			}
		}
		
		public override function Refresh():void {
			nodesQuery.LoadQueryResults();
			edgesQuery.LoadQueryResults();
			Logger.LogDebug("Refresh, it works!", this);
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
		
		public function OpenNodesDataWizard():void {
			var dataWizard:DataClipWizard = new DataClipWizard();
			dataWizard.clip = this;
			dataWizard.query = nodesQuery;
			dataWizard.queryDefinition = _NodesQueryDefinition;
			dataWizard.Reset();
			dataWizard.setStyle("top", "0");
			dataWizard.setStyle("bottom", "0");
			dataWizard.setStyle("left", "0");
			dataWizard.setStyle("right", "0");

			CollageApp.instance.OpenPopup(dataWizard, "datawizard");
		}
		
		public function OpenEdgesDataWizard():void {
			var dataWizard:DataClipWizard = new DataClipWizard();
			dataWizard.clip = this;
			dataWizard.query = edgesQuery;
			dataWizard.queryDefinition = _EdgesQueryDefinition;
			dataWizard.Reset();
			dataWizard.setStyle("top", "0");
			dataWizard.setStyle("bottom", "0");
			dataWizard.setStyle("left", "0");
			dataWizard.setStyle("right", "0");

			CollageApp.instance.OpenPopup(dataWizard, "datawizard");
		}
		
		public override function SaveToObject(onlyTheme:Boolean = false):Object
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
			newObject["nodesquery"] = nodesQuery.SaveToObject();
			newObject["edgesquery"] = edgesQuery.SaveToObject();
			return newObject;
		}

		public override function LoadFromObject(dataObject:Object):Boolean
		{
			if (!dataObject) return false;

			for(var obj_k:String in dataObject) {
				try {
					if (obj_k == "nodesquery")
						nodesQuery.LoadFromObject(dataObject[obj_k]);
					else if (obj_k == "edgesquery")
						edgesQuery.LoadFromObject(dataObject[obj_k]);
					else if(this.hasOwnProperty(obj_k))
						this[obj_k] = dataObject[obj_k];
				} catch(e:Error) { }
			}
			
			Refresh();
			return true;
		}
	}
}
