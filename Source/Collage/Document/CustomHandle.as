package Collage.Document
{
	import com.roguedevelopment.objecthandles.VisualElementHandle;
	import spark.primitives.BitmapImage;
	
	public class CustomHandle extends VisualElementHandle
	{
		public var handleImage:BitmapImage = new BitmapImage;
	
		public function CustomHandle()
		{
			super();

//			addChild(handleImage);
			handleImage.source="@Embed('/Assets/icons/delete.png')";
		}
	
		override public function redraw():void
		{
/*			graphics.clear();
			if( isOver )
			{
				graphics.lineStyle(1,0x3dff40);
				graphics.beginFill(0xc5ffc0	,1);				
			}
			else
			{
				graphics.lineStyle(1,0);
				graphics.beginFill(0x51ffee,1);
			}
			
			graphics.drawCircle(0,0,6);
			graphics.endFill();
*/
		}
		
	}
}