package classes
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class Keypad extends Sprite
	{
		// Γραφικά
		private var tileSize:uint = 42;
		[Embed(source="/assets/keypad.png")]
		private var TilesetKeypad:Class
		private var _tilesetImage:DisplayObject;
		private var _tilesetBitmapData:BitmapData;
		private var _canvasBitmapData:BitmapData;
		private var _canvasBitmap:Bitmap;

		public function Keypad():void
		{
			tilesetImage = new TilesetKeypad();
			tilesetBitmapData = new BitmapData(tilesetImage.width, tilesetImage.height, true, 0xFFFFFF);
			tilesetBitmapData.draw(tilesetImage);
			
			canvasBitmapData = new BitmapData(3 * tileSize, 2 * tileSize, true, 0xFFFFFF);
			canvasBitmap = new Bitmap(canvasBitmapData);
			
			canvasBitmapData.copyPixels(tilesetBitmapData, new Rectangle(2 * tileSize, 1 * tileSize, tileSize, tileSize), new Point(0 * tileSize, 1 * tileSize), null, null, true); // Αριστερά
			canvasBitmapData.copyPixels(tilesetBitmapData, new Rectangle(3 * tileSize, 1 * tileSize, tileSize, tileSize), new Point(2 * tileSize, 1 * tileSize), null, null, true); // Δεξιά
			canvasBitmapData.copyPixels(tilesetBitmapData, new Rectangle(0 * tileSize, 1 * tileSize, tileSize, tileSize), new Point(1 * tileSize, 0 * tileSize), null, null, true); // Πάνω
			canvasBitmapData.copyPixels(tilesetBitmapData, new Rectangle(1 * tileSize, 1 * tileSize, tileSize, tileSize), new Point(1 * tileSize, 1 * tileSize), null, null, true); // Κάτω
			
			addChild(canvasBitmap);
		}
		
		public function pressKey(row:uint = 0, col:uint = 0):void
		{
			canvasBitmapData.fillRect(new Rectangle(col * tileSize, row * tileSize, tileSize, tileSize), 0xFFFFFF);

			var tilesheetCol:uint;
			
			if (row == 0 && col == 1)
				tilesheetCol = 0;
			
			if (row == 1 && col == 0)
				tilesheetCol = 2;
			
			if (row == 1 && col == 1)
				tilesheetCol = 1;
			
			if (row == 1 && col == 2)
				tilesheetCol = 3;
			
			canvasBitmapData.copyPixels(tilesetBitmapData, new Rectangle(tilesheetCol * tileSize, 1 * tileSize, tileSize, tileSize - 3), new Point(col * tileSize, row * tileSize + 3), null, null, true);
		}
		
		public function releaseKey():void
		{
			canvasBitmapData.fillRect(new Rectangle(0, 0, canvasBitmapData.width, canvasBitmapData.height), 0xFFFFFF);
			canvasBitmapData.copyPixels(tilesetBitmapData, new Rectangle(2 * tileSize, 1 * tileSize, tileSize, tileSize), new Point(0 * tileSize, 1 * tileSize), null, null, true); // Αριστερά
			canvasBitmapData.copyPixels(tilesetBitmapData, new Rectangle(3 * tileSize, 1 * tileSize, tileSize, tileSize), new Point(2 * tileSize, 1 * tileSize), null, null, true); // Δεξιά
			canvasBitmapData.copyPixels(tilesetBitmapData, new Rectangle(0 * tileSize, 1 * tileSize, tileSize, tileSize), new Point(1 * tileSize, 0 * tileSize), null, null, true); // Πάνω
			canvasBitmapData.copyPixels(tilesetBitmapData, new Rectangle(1 * tileSize, 1 * tileSize, tileSize, tileSize), new Point(1 * tileSize, 1 * tileSize), null, null, true); // Κάτω
		}
		
		// Getters and Setters
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
		
	} // end class
	
} // end package
