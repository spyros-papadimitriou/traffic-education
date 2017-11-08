package general 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class CharacteristicButton extends Sprite 
	{
		public const buttonSize:uint = 44;

		private var textFormat:TextFormat;
		private var tf:TextField;
		private var minus:TextField;
		private var plus:TextField;
		
		private var _description:String;
		private var _enabled:Boolean;
		
		[Embed(source="/assets/button_characteristic.png")]
		private var BackgroundTf:Class;
		[Embed(source="/assets/button_minus.png")]
		private var BackgroundModify:Class;
		
		private var backgroundMinus:DisplayObject;
		private var backgroundPlus:DisplayObject;
		
		public function CharacteristicButton(description:String = "") 
		{
			var offset:uint = 5;
			
			var backroundTf:DisplayObject = new BackgroundTf();
			backgroundMinus = new BackgroundModify();
			backgroundPlus = new BackgroundModify();
			
			textFormat = new TextFormat("customFont", 16);
			textFormat.align = "center";

			minus = new TextField();
			minus.text = "-";
			minus.border = false;
			minus.embedFonts = true;
			minus.setTextFormat(textFormat);
			minus.defaultTextFormat = textFormat;
			minus.selectable = false;
			minus.width = minus.height = buttonSize;
			minus.y = (minus.height - minus.textHeight) / 2;
			minus.mouseEnabled = false;
			backgroundMinus.x = minus.x;
			
			tf = new TextField();
			this.description = description;
			tf.border = false;
			tf.embedFonts = true;
			tf.x = minus.x + minus.width + offset;
			tf.y = minus.y;
			tf.setTextFormat(textFormat);
			tf.defaultTextFormat = textFormat;
			tf.selectable = false;
			tf.width = 200;
			tf.y = minus.y;
			tf.height = minus.height;
			tf.mouseEnabled = false;
			backroundTf.x = tf.x;
			
			plus = new TextField();
			plus.text = "+";
			plus.border = false;
			plus.embedFonts = true;
			plus.x = tf.x + tf.width + offset;
			plus.y = minus.y;
			plus.setTextFormat(textFormat);
			plus.defaultTextFormat = textFormat;
			plus.selectable = false;
			plus.width = plus.height = minus.width;
			plus.mouseEnabled = false;
			backgroundPlus.x = plus.x;
			
			enabled = true;
			
			addChild(backgroundMinus);
			addChild(minus);
			addChild(backroundTf);
			addChild(tf);
			addChild(backgroundPlus);
			addChild(plus);

		} // end constructor
		
		public function buttonClicked(coordX:int, coordY:int):uint
		{
			if (!enabled)
				return 0;

			if (coordY >= 0 && coordY <= buttonSize)
				if (coordX >= 0 && coordX <= buttonSize)
					return 1; // Left button - minus
				else if (coordX >= (width - buttonSize) && coordX <= width)
					return 2; // Right button - plus
			
			return 0;
		}

		
		// Getters and Setters
		public function get description():String 
		{
			return _description;
		}
		
		public function set description(value:String):void 
		{
			_description = value;
			tf.text = description;
		}
		
		public function get enabled():Boolean
		{
			return this._enabled;
		}
				
		public function set enabled(value:Boolean):void
		{
			this._enabled = value;
			if (value)
			{
				backgroundMinus.alpha = 1.0;
				minus.alpha = 1.0;
				backgroundPlus.alpha = 1.0;
				plus.alpha = 1.0;
			} else {
				backgroundMinus.alpha = 0.0;
				minus.alpha = 0.0;
				backgroundPlus.alpha = 0.0;
				plus.alpha = 0.0;
			}
		}
		
	} // end class

} // end package
