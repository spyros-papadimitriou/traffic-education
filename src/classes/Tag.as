package classes 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class Tag extends Sprite 
	{
		// Γραφικά
		[Embed(source="/assets/tag.png")]
		private var TagBackground:Class
		
		public var tf:TextField;
		private var textFormat:TextFormat;
		
		public function Tag() 
		{
			var bg:DisplayObject = new TagBackground();
			
			textFormat = new TextFormat("customFont", 15, 0x000000, true);
			textFormat.align = "center";
			
			tf = new TextField();
			tf.width = bg.width - 16;
			tf.height = 62;
			//tf.border = true;
			tf.selectable = false;
			tf.x = 8;
			tf.y = 55;
			tf.multiline = true;
			tf.wordWrap = true;
			tf.embedFonts = true;
			tf.defaultTextFormat = textFormat;
			tf.setTextFormat(textFormat);
			
			addChild(bg);
			addChild(tf);
		} // end constructor
		
		public function setText(txt:String):void
		{
			tf.text = txt;
			tf.y = 55 + (tf.height - tf.textHeight) / 2;
		}
		
	} // end class

} // end package