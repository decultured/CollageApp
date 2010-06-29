package Collage.Document
{
	import mx.controls.Alert;
	import Collage.Clip.*;
	import Collage.Clips.*;
	import flash.geom.*;
	import spark.components.Group;
	import spark.components.SkinnableContainer;
	import Collage.Document.Skins.*;
	import Collage.Application.*;
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
		[Bindable]public var appClass:CollageApp;
		
		public var toolbar:Group;
		public var smallToolbar:Group;
		
		[Bindable]public var clipOptionsEnabled:Boolean = false;
		
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

		public function OpenPageWizard():void {
			var pageWizard:EditPageWizard = new EditPageWizard();
			pageWizard.appClass = appClass;
			pageWizard.setStyle("top", "0");
			pageWizard.setStyle("bottom", "0");
			pageWizard.setStyle("left", "0");
			pageWizard.setStyle("right", "0");

			CollageApp.instance.OpenPopup(pageWizard, "pagewizard", false, new Point(300, 200));
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

			SetToolbar();

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
		
		public function SetToolbar():void
		{
			if (!toolbar || !smallToolbar)
				return;
				
			toolbar.removeAllElements();
			smallToolbar.removeAllElements();

		 	if (objectHandles.selectionManager.currentlySelected.length == 1) {
				var selectedClip:Clip = objectHandles.selectionManager.currentlySelected[0] as Clip;
				toolbar.addElement(selectedClip.CreateEditor());
				var newSmallEditor:ClipEditor = selectedClip.CreateSmallEditor();
				if (newSmallEditor) {
					smallToolbar.addElement(newSmallEditor);
					Logger.Log("Small Clip Editor Found!");
				} else {
					Logger.LogDebug("No Small Clip Editor available for this clip: " + selectedClip.type);
				}
				clipOptionsEnabled = true;
			} else if (objectHandles.selectionManager.currentlySelected.length > 1) {
				clipOptionsEnabled = true;
			} else {
				toolbar.addElement(new EditPageToolbar(this, EditPageToolbarSkin));
				smallToolbar.addElement(new EditPageToolbar(this, EditPageSmallToolbarSkin));
				clipOptionsEnabled = false;
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

		public function SelectAll():void
		{
			if (!objectHandles)
				return;
				
			objectHandles.selectionManager.clearSelection();
			for (var i:int = numElements - 1; i > -1; i--) {
				if (getElementAt(i) is ClipView) {
					var clipView:ClipView = getElementAt(i) as ClipView;
					objectHandles.selectionManager.addToSelected(clipView.model);
				}
			}
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
		}

		protected function ObjectDeselected(event:SelectionEvent):void {
			if (toolbar)
				toolbar.removeAllElements();

			for each (var clip:Clip in event.targets) {
				clip.selected = false;
			}
			SetToolbar();
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