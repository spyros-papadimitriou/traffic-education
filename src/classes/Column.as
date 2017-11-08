package classes 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class Column extends Sprite 
	{
		// Γραφικά
		[Embed(source="/assets/column.png")]
		private var BackgroundColumn:Class
		
		public function Column() 
		{
			var background:DisplayObject = new BackgroundColumn();
			addChild(background);
		} // end constructor
		
	} // end class

} // end package