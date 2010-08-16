package Collage.Clips.WordCloudClip
{

import Collage.Utilities.Logger.*;
import mx.core.ILayoutElement;
import spark.components.supportClasses.GroupBase;
import spark.layouts.supportClasses.LayoutBase;
import spark.layouts.VerticalAlign;
import spark.layouts.HorizontalAlign;

public class WordCloudLayout extends LayoutBase
{
	private var _verticalGap:Number = 20;
	private var _horizontalGap:Number = 10;
	private var _verticalAlign:String = VerticalAlign.JUSTIFY;
	private var _horizontalAlign:String = HorizontalAlign.CENTER;
	
	public function get verticalGap():Number {return _verticalGap;}
	public function set verticalGap(val:Number):void {_verticalGap = val; target.invalidateDisplayList();}

	public function get horizontalGap():Number {return _horizontalGap;}
	public function set horizontalGap(val:Number):void {_horizontalGap = val; target.invalidateDisplayList();}

	public function get verticalAlign():String {return _verticalAlign;}
	public function set verticalAlign(val:String):void {_verticalAlign = val; target.invalidateDisplayList();}

	public function get horizontalAlign():String {return _horizontalAlign;}
	public function set horizontalAlign(val:String):void {_horizontalAlign = val; target.invalidateDisplayList();}

	public function WordCloudLayout():void
	{
		super();
	}

   	override public function updateDisplayList(containerWidth:Number, containerHeight:Number):void
    {
        // The position for the current element
        var x:Number = 0;
        var y:Number = 0;

		var rowStart:uint = 0;
		var rows:Array = new Array();
		var rowID:uint = 0;

        // loop through the elements
        var layoutTarget:GroupBase = target;
        var count:int = layoutTarget.numElements;
		var largestHeight:Number = 0;
		var totalHeight:Number = 0;
        for (var i:int = 0; i < count; i++)
        {
            // Resize the element to its preferred size by passing NaN for the width and height constraints
            var element:ILayoutElement = layoutTarget.getElementAt(i);
            element.setLayoutBoundsSize(NaN, NaN);
            var elementWidth:Number = element.getLayoutBoundsWidth();
            var elementHeight:Number = element.getLayoutBoundsHeight();
			if (elementHeight > largestHeight)
				largestHeight = elementHeight;

			//element.setLayoutBoundsPosition(10000, 10000);

            if (x + elementWidth > containerWidth)
            {
				rows[rowID] = new Object();
				rows[rowID].largestHeight = largestHeight;
				rows[rowID].width = x - horizontalGap;
				rows[rowID].start = rowStart;
				rows[rowID].end = i;
				rows[rowID].y = y;

				rowStart = i;
				rowID++;
				x = 0;
                y += largestHeight + verticalGap;
				totalHeight += largestHeight + verticalGap;
				largestHeight = 0;
            }

            x += elementWidth + horizontalGap;
        }

		if (rowStart < count) {
			rows[rowID] = new Object();
			rows[rowID].largestHeight = largestHeight;
			rows[rowID].width = x - horizontalGap;
			rows[rowID].start = rowStart;
			rows[rowID].end = count;
			rows[rowID].y = y;

			totalHeight += largestHeight;
		}

		for (i = 0; i < rows.length; i++) {
			positionRow(containerWidth, containerHeight, i, rows.length, totalHeight, rows[i].y, rows[i].largestHeight, rows[i].width, rows[i].start, rows[i].end);
		}

		//positionRow(containerWidth, containerHeight, y, largestHeight, x - horizontalGap, rowStart, count);
    }

	private function positionRow(containerWidth:Number, containerHeight:Number, row:uint, numRows:uint, totalHeight:uint, y:Number, largestHeight:Number, rowWidth:Number, start:int, end:int):void
	{
		// assume HorizontalAlign.LEFT
		var x:Number = 0
		var xOffset:Number = 0
		
		if (horizontalAlign == HorizontalAlign.CENTER)
			x = (containerWidth - rowWidth) * 0.5;
		else if ((horizontalAlign == HorizontalAlign.JUSTIFY || horizontalAlign == HorizontalAlign.CONTENT_JUSTIFY) && end - 1 > start)
			xOffset = (containerWidth - rowWidth) / (end - 1 - start);
		else if (horizontalAlign == HorizontalAlign.RIGHT)
			x = containerWidth - rowWidth;

		// assume VerticalAlign.TOP
		if (verticalAlign == VerticalAlign.MIDDLE)
			y += (containerHeight - totalHeight) * 0.5;
		else if ((verticalAlign == VerticalAlign.JUSTIFY || verticalAlign == VerticalAlign.CONTENT_JUSTIFY) && numRows - 1 && row)
			y += ((containerHeight - totalHeight) / (numRows - 1)) * row;
		else if (verticalAlign == VerticalAlign.BOTTOM)
			y += containerHeight - totalHeight;
		
        for (var i:int = start; i < end; i++)
        {
            var element:ILayoutElement = target.getElementAt(i);
            element.setLayoutBoundsSize(NaN, NaN);
            var elementWidth:Number = element.getLayoutBoundsWidth();
            var elementHeight:Number = element.getLayoutBoundsHeight();

            element.setLayoutBoundsPosition(x, y + (largestHeight - elementHeight) * 0.5);
			x += elementWidth + horizontalGap + xOffset;
		}
	}
}
}