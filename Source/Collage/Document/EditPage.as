package Collage.Document
{
	import mx.controls.Alert;
	import Collage.Clip.*;
	import Collage.Clips.*;
	import flash.geom.*;
	import spark.components.Group;
	import spark.components.SkinnableContainer;
	import com.roguedevelopment.objecthandles.*;
	import com.roguedevelopment.objecthandles.constraints.*;
	import com.roguedevelopment.objecthandles.decorators.AlignmentDecorator;
	import com.roguedevelopment.objecthandles.decorators.DecoratorManager;
	import mx.managers.PopUpManager;
	import Collage.Utilities.Logger.*;

	public class EditPage extends Page
	{
		public var objectHandles:ObjectHandles;
		protected var decoratorManager:DecoratorManager;
		
		public var toolbar:Group;
		public var optionsBox:Group;
		
		public function EditPage():void
		{
			super();
		}
		
		public function InitializeForEdit():void
		{
			InitObjectHandles();
		}

		public override function New():void
		{
			if (objectHandles && objectHandles.selectionManager)
				objectHandles.selectionManager.clearSelection();
			super.New();
		}

		public function InitObjectHandles():void
		{
			objectHandles = new ObjectHandles(this, null, new Flex4HandleFactory(), new Flex4ChildManager());
			objectHandles.selectionManager.addEventListener(SelectionEvent.ADDED_TO_SELECTION, ObjectSelected);
			objectHandles.selectionManager.addEventListener(SelectionEvent.REMOVED_FROM_SELECTION, ObjectDeselected);
			objectHandles.selectionManager.addEventListener(SelectionEvent.SELECTION_CLEARED, ObjectDeselected);

			objectHandles.addEventListener(ObjectChangedEvent.OBJECT_MOVED, ObjectChanged);
			objectHandles.addEventListener(ObjectChangedEvent.OBJECT_MOVING, ObjectChanged);
			objectHandles.addEventListener(ObjectChangedEvent.OBJECT_RESIZED, ObjectChanged);
			objectHandles.addEventListener(ObjectChangedEvent.OBJECT_RESIZING, ObjectChanged);
			objectHandles.addEventListener(ObjectChangedEvent.OBJECT_ROTATED, ObjectChanged);
			objectHandles.addEventListener(ObjectChangedEvent.OBJECT_ROTATING, ObjectChanged);

			var sizeConstraint:SizeConstraint = new SizeConstraint();
			sizeConstraint.minWidth = 20;
			sizeConstraint.minHeight = 20;
			
			objectHandles.addDefaultConstraint(sizeConstraint);							

			Logger.LogDebug("ObjectHandles Initialized", this);

//			decoratorManager = new DecoratorManager( objectHandles, this );
//			decoratorManager.addDecorator( new AlignmentDecorator() );
		}

		public function AddObjectHandles(newClip:Clip):void
		{
			if (newClip) {
				var handles:Array = [];

				if (newClip.verticalSizable && newClip.horizontalSizable) {
					handles.push( new HandleDescription( HandleRoles.RESIZE_UP + HandleRoles.RESIZE_LEFT, new Point(0,0), new Point(0,0)));
					handles.push( new HandleDescription( HandleRoles.RESIZE_UP + HandleRoles.RESIZE_RIGHT, new Point(100,0), new Point(0,0))); 
					handles.push( new HandleDescription( HandleRoles.RESIZE_DOWN + HandleRoles.RESIZE_RIGHT, new Point(100,100), new Point(0,0))); 
					handles.push( new HandleDescription( HandleRoles.RESIZE_DOWN + HandleRoles.RESIZE_LEFT, new Point(0,100), new Point(0,0))); 
				}
				if (newClip.verticalSizable) {
					handles.push( new HandleDescription( HandleRoles.RESIZE_UP, new Point(50,0), new Point(0,0))); 
					handles.push( new HandleDescription( HandleRoles.RESIZE_DOWN, new Point(50,100), new Point(0,0))); 
				}
				if (newClip.horizontalSizable) {
					handles.push( new HandleDescription( HandleRoles.RESIZE_LEFT, new Point(0,50), new Point(0,0))); 
					handles.push( new HandleDescription( HandleRoles.RESIZE_RIGHT, new Point(100,50), new Point(0,0))); 
				}
				if (newClip.rotatable)
					handles.push( new HandleDescription( HandleRoles.ROTATE, new Point(100,50), new Point(20,0))); 
				
				objectHandles.registerComponent(newClip, newClip.view, handles);
				DeselectAll();
				objectHandles.selectionManager.addToSelected(newClip);
			}
		}
		
		public override function ViewResized():void
		{
			super.ViewResized();
		}
		
		protected function PositionOptionsBox():void
		{
			if (!optionsBox) {
				return;
			}
			
			if (!objectHandles.selectionManager.currentlySelected.length) {
				optionsBox.visible = false;
				return;
			}
			
			var geom:DragGeometry = objectHandles.selectionManager.getGeometry();

			if (!geom) {
				optionsBox.visible = false;
				return;
			}

			optionsBox.visible = true;

			optionsBox.y = geom.y;
			optionsBox.x = geom.x;
			optionsBox.width = geom.width;
			optionsBox.height = geom.height;
			optionsBox.rotation = geom.rotation;

			if (geom.y < 30) {
			} else {
			}
		}
				
		private function SetToolbar():void
		{
			if (!toolbar)
				return;
				
			toolbar.removeAllElements();

		 	if (objectHandles.selectionManager.currentlySelected.length == 1) {
				var selectedClip:Clip = objectHandles.selectionManager.currentlySelected[0] as Clip;
				toolbar.addElement(selectedClip.CreateEditor());
			} else if (objectHandles.selectionManager.currentlySelected.length > 1) {
				
			} else {
				toolbar.addElement(new EditPageToolbar(this));
			}
		}

		private function ObjectChanged(event:ObjectChangedEvent):void{
			var num:Number = 0;
			for each (var clip:Clip in event.relatedObjects) {
				if (event.type == ObjectChangedEvent.OBJECT_MOVED) {
					clip.Moved();
				}
				else if (event.type == ObjectChangedEvent.OBJECT_RESIZED) {
					clip.Resized();
				}
				else if (event.type == ObjectChangedEvent.OBJECT_ROTATED) {
					clip.Rotated();
				}
				PositionOptionsBox();
			}
		}

		public override function AddClip(_clip:Clip):Clip
		{
			var newClip:Clip = super.AddClip(_clip);
			if (!newClip) {
				return null;
			}
			
			AddObjectHandles(newClip);
			return newClip;
		}
		
		public override function AddClipByType(type:String):Clip
		{
			return AddClip(ClipFactory.CreateByType(type));
		}
		
		public override function DeleteClip(_clip:Clip):void
		{
			if (_clip == null)
				return;
				
			objectHandles.unregisterComponent(_clip.view);
			SetToolbar();
			super.DeleteClip(_clip);
		}
		
		public function DeselectAll():void
		{
			if (!objectHandles)
				return;
				
			objectHandles.selectionManager.clearSelection();
		}
		
		protected function ObjectSelected(event:SelectionEvent):void {
			for each (var clip:Clip in event.targets) {
				clip.selected = true;
			}
			SetToolbar();
			PositionOptionsBox();
		}

		protected function ObjectDeselected(event:SelectionEvent):void {
			if (toolbar)
				toolbar.removeAllElements();

			for each (var clip:Clip in event.targets) {
				clip.selected = false;
			}
			SetToolbar();
			PositionOptionsBox();
		}

		public function DeleteSelected():void
		{
			var selectedArray:Array = new Array();

			for (var i:int = 0; i < objectHandles.selectionManager.currentlySelected.length; i++) {
				if (objectHandles.selectionManager.currentlySelected[i] != null && objectHandles.selectionManager.currentlySelected[i] is Clip)
					selectedArray.push(objectHandles.selectionManager.currentlySelected[i] as Clip);
			}

			for (i = 0; i < selectedArray.length; i++) {
				DeleteClip(selectedArray[i]);
			}

			objectHandles.selectionManager.clearSelection();
		}

		public function ToggleEditSelected():void
		{
			if (objectHandles.selectionManager.currentlySelected.length == 1) {
				(objectHandles.selectionManager.currentlySelected[0] as Clip).ToggleEditMode();
			}
		}

		public function RefreshSelected():void
		{
			if (objectHandles.selectionManager.currentlySelected.length == 1) {
				(objectHandles.selectionManager.currentlySelected[0] as Clip).Refresh();
			}
		}

		public function ToggleLockSelected():void
		{
			if (objectHandles.selectionManager.currentlySelected.length == 1) {
				(objectHandles.selectionManager.currentlySelected[0] as Clip).ToggleLocked();
			}
		}

		public function MoveSelectedForward():void
		{
		}
		
		public function MoveSelectedBackward():void
		{
		}
		
		public function MoveSelectedToFront():void
		{
		}
		
		public function MoveSelectedToBack():void
		{
		}
	} 
}