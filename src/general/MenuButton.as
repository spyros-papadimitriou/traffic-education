package general
{
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class MenuButton extends Sprite
	{
		// Temp
		private var shape:Sprite;
		private var textFormat:TextFormat;
		public var tf:TextField;
		
		public const BLUE:uint = 1;
		public const YELLOW:uint = 2;
		public const RED:uint = 3;
		public const GREEN:uint = 4;
		public const PURPLE:uint = 5;
		public const ORANGE:uint = 6;
		
		private var _backgroundColor:uint = 1;
		
		// Γραφικά
		[Embed(source="/assets/buttons.png")]
		private var BackgroundButtons:Class
		private var _backgroundButtons:DisplayObject;
		private var _backgroudButtonsBitmapData:BitmapData;
		private var _canvasBitmapData:BitmapData;
		private var _canvasBitmap:Bitmap;
		
		public function MenuButton(txt:String = "", backgroundColor:uint = RED):void
		{	
			backgroundButtons = new BackgroundButtons();
			backgroudButtonsBitmapData = new BitmapData(backgroundButtons.width, backgroundButtons.height, true);
			backgroudButtonsBitmapData.draw(backgroundButtons);
			
			canvasBitmapData = new BitmapData(220, 74, true, 0xFFFFFF);
			canvasBitmap = new Bitmap(canvasBitmapData);
			
			textFormat = new TextFormat("customFont", 18);
			textFormat.align = "center";
			textFormat.bold = true;

			tf = new TextField();
			tf.embedFonts = true;
			tf.selectable = false;
			tf.width = canvasBitmap.width - 20;
			tf.height = canvasBitmap.height - 20;
			tf.wordWrap = true;
			tf.text = txt;
			tf.x = 10;
			tf.y = (tf.height - tf.textHeight) / 2;

			this.backgroundColor = backgroundColor;

			addChild(canvasBitmap);
			addChild(tf);

			buttonMode = true;
			mouseChildren = false;
			alpha = 0.0;
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		} // end constructor
		
		private function onEnterFrame(e:Event):void
		{
			alpha += 0.15;
			
			if (alpha >= 1.0)
			{
				alpha = 1.0;
				
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				addEventListener(Event.REMOVED_FROM_STAGE, onRemoveFromStage);
				addEventListener(MouseEvent.ROLL_OVER, onRollOver);
				addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			}
		}
		
		private function onRollOver(e:MouseEvent):void
		{
			canvasBitmapData.copyPixels(backgroudButtonsBitmapData, new Rectangle(0, (PURPLE - 1) * canvasBitmap.height, canvasBitmap.width, canvasBitmap.height), new Point(0, 0));
		}
		
		private function onRollOut(e:MouseEvent):void
		{
			canvasBitmapData.copyPixels(backgroudButtonsBitmapData, new Rectangle(0, (backgroundColor - 1) * canvasBitmap.height, canvasBitmap.width, canvasBitmap.height), new Point(0, 0));
		}
		
		private function onRemoveFromStage(e:Event):void
		{
			if (hasEventListener(MouseEvent.ROLL_OVER))
				removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
			
			if (hasEventListener(MouseEvent.ROLL_OUT))
				removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
		}
		
		// Getters and Setters	
		public function get backgroundButtons():DisplayObject 
		{
			return _backgroundButtons;
		}
		
		public function set backgroundButtons(value:DisplayObject):void 
		{
			_backgroundButtons = value;
		}
		
		public function get backgroudButtonsBitmapData():BitmapData 
		{
			return _backgroudButtonsBitmapData;
		}
		
		public function set backgroudButtonsBitmapData(value:BitmapData):void 
		{
			_backgroudButtonsBitmapData = value;
		}
		
		public function get canvasBitmapData():BitmapData 
		{
			return _canvasBitmapData;
		}
		
		public function set canvasBitmapData(value:BitmapData):void 
		{
			_canvasBitmapData = value;
		}
		
		public function get canvasBitmap():Bitmap 
		{
			return _canvasBitmap;
		}
		
		public function set canvasBitmap(value:Bitmap):void 
		{
			_canvasBitmap = value;
		}
		
		public function get backgroundColor():uint 
		{
			return _backgroundColor;
		}
		
		public function set backgroundColor(value:uint):void 
		{
			_backgroundColor = value;
			canvasBitmapData.copyPixels(backgroudButtonsBitmapData, new Rectangle(0, (value - 1) * canvasBitmap.height, canvasBitmap.width, canvasBitmap.height), new Point(0, 0));
			
			switch (value)
			{
				case BLUE:
					textFormat.color = 0x000000;
					break;
					
				case YELLOW:
					textFormat.color = 0x000000;
					break;
					
				case RED:
					textFormat.color = 0xFFFFFF;
					break;
				
				case GREEN:
					textFormat.color = 0x000000;
					break;
					
				default:
					textFormat.color = 0xFFFFFF;
					break;
			} // end switch
			
			tf.setTextFormat(textFormat);
			tf.defaultTextFormat = textFormat;
		}

	} // end class

} // end package
