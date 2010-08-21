package Collage.Clips.GraphClip
{
	import flare.animate.FunctionSequence;
	import flare.animate.Transition;
	import flare.animate.TransitionEvent;
	import flare.animate.Transitioner;
	import flare.analytics.graph.BetweennessCentrality;
	import flare.data.DataSet;
	import flare.data.DataSource;
	import flare.display.TextSprite;
	import flare.scale.ScaleType;
	import flare.util.Shapes;
	import flare.util.palette.ColorPalette;
	import flare.vis.Visualization;
	import flare.vis.controls.DragControl;
	import flare.vis.controls.ClickControl;
	import flare.vis.controls.ExpandControl;
	import flare.vis.controls.PanZoomControl;
	import flare.vis.data.Data;
	import flare.vis.data.NodeSprite;
	import flare.vis.data.DataList;
	import flare.vis.operator.OperatorList;
	import flare.vis.operator.encoder.ColorEncoder;
	import flare.vis.operator.encoder.SizeEncoder;
	import flare.vis.operator.encoder.PropertyEncoder;
	import flare.vis.operator.label.Labeler;
	import flare.vis.operator.layout.Layout;
	import flare.vis.operator.layout.NodeLinkTreeLayout;
	import flare.vis.operator.layout.ForceDirectedLayout;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	
	import mx.events.ResizeEvent;
	import spark.components.Group;
	
//	import Collage.Clips.GraphClip.util.*;

	public class GraphLayout extends Group
	{
		private var vis:Visualization;
		private var visLayout:ForceDirectedLayout;
		
 
        public function GraphLayout()
        {
            //loadData();
			addEventListener(ResizeEvent.RESIZE, Resized, false, 0, true);
        }

		public function Resized(event:ResizeEvent):void
		{
			if (!vis || !vis.bounds)
				return;
				
            vis.bounds.width = width;
			vis.bounds.height = height;
		}

        private function loadData():void
        {
//			visualize(GraphUtil.balancedTree(3,3));

            /*var ds:DataSource = new DataSource( "file://Users/jgraves/Desktop/flare-tutorial.xml", "graphml" );
            var loader:URLLoader = ds.load();
            loader.addEventListener( Event.COMPLETE, 
            	function( evt:Event ):void
            	{
	                var dataSet:DataSet = loader.data as DataSet;
    	            visualize( Data.fromDataSet( dataSet ) );
        	    }
        	);*/
        }
 
		public function Stop():void
		{
			if (vis)
				vis.continuousUpdates = false;
		}

        public function visualize( data:Data ):void
        {
			if (vis) {
				Stop();
				this.removeElement(vis);
				vis = null;
			}

        	// Add 'vis' to display list
        	vis = new Visualization( data );
            vis.bounds = new Rectangle( 0, 0, width, height);
            vis.x = 0;
            vis.y = 0;
            this.addElement(vis);
            
            // Define edge and node properties
            data.edges[ "lineWidth" ] = 1;
            data.nodes.setProperties( { fillAlpha: 1, lineAlpha: 0, shape: Shapes.CIRCLE, size: 1.5 } );
            
            // Remove all un-named operators
			vis.operators.clear();

			// Apply force-directed layout
			visLayout = new ForceDirectedLayout(true);
			
			visLayout.simulation.dragForce.drag = 1.0,
			visLayout.simulation.nbodyForce.maxDistance = 150;
			visLayout.simulation.nbodyForce.gravitation = -100;
			visLayout.defaultParticleMass	= 3,
			visLayout.defaultSpringLength	= 100,
			visLayout.defaultSpringTension	= 0.01
			
			
			vis.operators.add(visLayout);
			vis.continuousUpdates = true;
            
            // Add controls to Visualization
			vis.controls.add( new DragControl( NodeSprite ) );  
			vis.controls.add( new ClickControl( NodeSprite ) );  
            vis.update();
			
			// Displays hand-cursor
			vis.data.nodes[ "buttonMode" ] = true;
			
            // Add labels to the graph
            addLabels();

			// Color the nodes
//			colorNodes();
			colorByCentrality();
			
			// Finally, if performing a force-directed layout, set up
			// continuous updates and ease in the edge tensions.
			/*visLayout.defaultSpringTension = 0;
			var nodes:DataList = vis.data.nodes;
			var edges:DataList = vis.data.edges;
			vis.setOperator("nodes", new PropertyEncoder(visLayout.nodes, "nodes"));
			vis.setOperator("edges", new PropertyEncoder(visLayout.edges, "edges"));
			var t:Transitioner = vis.update(2);//, "nodes", "edges");
			t.$(visLayout).defaultSpringTension = 0.5;
			t.play();
			vis.continuousUpdates = true;*/
        }
        
		private function addLabels():void
		{
			var labeler:Labeler = new Labeler( "data.label" );
			labeler.textMode = TextSprite.DEVICE;
			labeler.yOffset = 20;
			labeler.textFormat.size = 8;
			vis.setOperator( "labels", labeler );
			vis.update( null, "labels" );
		}
		
		private function colorNodes():void
		{
			vis.setOperator( "size", 
				new OperatorList(
					new SizeEncoder( "data.lines", Data.NODES ),
					new ColorEncoder( "data.tutorial", Data.NODES, "fillColor", ScaleType.CATEGORIES )
				)
			);
            vis.update( 2, "size" ).play();
		}

		private function colorByCentrality():void
		{
			// The Centrality algorithm due to Ulrik Brandes, 
			// as published in the Journal of Mathematical Sociology, 25(2):163-177, 2001.
			
			// Create a named set of operaters using OperatorList 
			vis.setOperator( "centrality", 
				new OperatorList(
            		new BetweennessCentrality(),
            		new ColorEncoder( "props.centrality", Data.NODES, "props.label.color", ScaleType.LINEAR, ColorPalette.diverging(0xffff0000, 0xffffff00, 0x00ff00) )
            	)
            );
            vis.update( 2, "centrality" ).play();
		}

	}
}