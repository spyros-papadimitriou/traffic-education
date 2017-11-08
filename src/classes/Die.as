package classes 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import general.Game;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class Die extends Sprite
	{
		// Temp
		private var shape:Sprite;
		private var textFormat:TextFormat;
		public var tf:TextField;

		private var _game:Game = Game.getInstance();
		private var _num:uint = 0;
		private var _arrow:DisplayObject;
		private var _timer:Timer;
		
		// Γραφικά
		[Embed(source="/assets/dice48.png")]
		private var TilesetDice:Class
		private var _tilesetImage:DisplayObject;
		private var _tilesetBitmapData:BitmapData;
		private var _canvasBitmapData:BitmapData;
		private var _canvasBitmap:Bitmap;
		
		[Embed(source="/assets/arrow.png")]
		private var ArrowBitmap:Class
		
		public function Die() 
		{
			tilesetImage = new TilesetDice();
			tilesetBitmapData = new BitmapData(tilesetImage.width, tilesetImage.height, true, 0xFFFFFF);
			tilesetBitmapData.draw(tilesetImage);
			
			canvasBitmapData = new BitmapData(48, 48, true, 0xFFFFFF);
			canvasBitmap = new Bitmap(canvasBitmapData);
			canvasBitmapData.copyPixels(tilesetBitmapData, new Rectangle(0, 2 * 48, 48, 48), new Point(0, 0), null, null, true);
			
			textFormat = new TextFormat("customFont", 18, 0x000000, true);
			textFormat.align = "center";

			tf = new TextField();
			tf.embedFonts = true;
			tf.width = 46;
			tf.height = 46;
			tf.selectable = false;
			tf.wordWrap = true;
			tf.defaultTextFormat = textFormat;
			tf.setTextFormat(textFormat);
			//tf.border = true;
			tf.text = "ΚΛΙΚ";
			tf.y = (tf.height - tf.textHeight) / 2 + 30;
			tf.alpha = 1.0;
			
			arrow = new ArrowBitmap();
			arrow.x = 48 / 2 - arrow.width / 2;
			arrow.y = 48 + 3;
			
			timer = new Timer(400);
			timer.addEventListener(TimerEvent.TIMER, timerAction);

			addChild(canvasBitmap);
			addChild(arrow);
			//addChild(tf);

		} // end constructor
		
		public function roll():void
		{
	
			num = Math.round(1 + 5 * Math.random());
			// num = 1;
		}
		
		public function timerAction(e:TimerEvent):void
		{
			if (arrow.alpha)
				arrow.alpha = 0.0;
			else
				arrow.alpha = 1.0;
		}
		
		public function setReadyToClick(value:Boolean):void
		{
			arrow.visible = value;

			if (value)
				timer.start();
			else
				timer.stop();
		}
		
		// Getters and Setters
		public function get game():Game
		{
			return this._game;
		}
		
		public function set game(value:Game):void
		{
			this._game = value;
		}

		public function get num():uint
		{
			return this._num;
		}
		
		public function set num(value:uint):void
		{
			this._num = value;
			canvasBitmapData.copyPixels(tilesetBitmapData, new Rectangle((num - 1) * 48, 2 * 48, 48, 48), new Point(0, 0), null, null, true);
		}
		
		public function get tilesetImage():DisplayObject
		{
			return this._tilesetImage;
		}
		
		public function set tilesetImage(value:DisplayObject):void
		{
			this._tilesetImage = value;
		}
		
		public function get tilesetBitmapData():BitmapData
		{
			return this._tilesetBitmapData;
		}
		
		public function set tilesetBitmapData(value:BitmapData):void
		{
			this._tilesetBitmapData = value;
		}
		
		public function get canvasBitmapData():BitmapData
		{
			return this._canvasBitmapData;
		}
		
		public function set canvasBitmapData(value:BitmapData):void
		{
			this._canvasBitmapData = value;
		}
		
		public function get canvasBitmap():Bitmap
		{
			return this._canvasBitmap;
		}
		
		public function set canvasBitmap(value:Bitmap):void
		{
			this._canvasBitmap = value;
		}
		
		public function get arrow():DisplayObject 
		{
			return _arrow;
		}
		
		public function set arrow(value:DisplayObject):void 
		{
			_arrow = value;
		}
		
		public function get timer():Timer 
		{
			return _timer;
		}
		
		public function set timer(value:Timer):void 
		{
			_timer = value;
		}
		
	} // end class

} // end package
