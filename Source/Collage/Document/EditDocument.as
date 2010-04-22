package Collage.Document
{
	import mx.controls.Alert;
	import Collage.Clips.*;
	import com.roguedevelopment.objecthandles.*;
	import com.roguedevelopment.objecthandles.decorators.AlignmentDecorator;
	import com.roguedevelopment.objecthandles.decorators.DecoratorManager;

	public class EditDocument extends Document
	{
		public var objectHandles:ObjectHandles;
		protected var decoratorManager:DecoratorManager;

		public function EditDocument():void
		{
			super();
		}
		
		public function InitializeForEdit():void
		{
			InitObjectHandles();
		}

		public override function NewDocument():void
		{
/*			var childArray:Array = getChildren();
			for (var i:uint = 0; i < childArray.length; i++) {
				if (childArray[i] && childArray[i] is ClipView)
					_ObjectHandles.unregisterComponent(childArray[i]);
			}
*/
			//DrawGrid();
			super.NewDocument();
		}

		public function InitObjectHandles():void
		{
			objectHandles = new ObjectHandles(this, null, new Flex4HandleFactory(), new Flex4ChildManager());
//			decoratorManager = new DecoratorManager( objectHandles, drawingLayer );
//			decoratorManager.addDecorator( new AlignmentDecorator() );
		}		

		public function AddObjectHandles(newClip:Clip):void
		{
		}

		public override function AddClip(clipModel:ClipModel):ClipModel
		{
			var newClip:ClipModel = super.AddClip(clipModel);
			if (!newClip) {
				return null;
			}
			
			objectHandles.registerComponent(newClip, newClip.view);
			objectHandles.selectionManager.addToSelected(newClip);
			return newClip;
		}
		
		public function DeleteSelected():void
		{
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