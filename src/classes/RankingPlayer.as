package classes 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class RankingPlayer extends Sprite 
	{
		public const RED:uint = 1;
		public const BLUE:uint = 2;
		public const GREEN:uint = 3;
		public const YELLOW:uint = 4;
		
		private var _player:Player;
		private var _rank:uint = 0;
		
		// Γραφικά
		private var tileSize:uint = 180;
		[Embed(source = "/assets/flag_finish.png")]
		private var FlagImage:Class;
		[Embed(source="/assets/cars_ranking.png")]
		private var TilesetRanking:Class
		private var _tilesetImage:DisplayObject;
		private var _tilesetBitmapData:BitmapData;
		private var _canvasBitmapData:BitmapData;
		private var _canvasBitmap:Bitmap;
		
		public function RankingPlayer(player:Player, rank:uint) 
		{
			tilesetImage = new TilesetRanking();
			tilesetBitmapData = new BitmapData(tilesetImage.width, tilesetImage.height, true, 0xFFFFFF);
			tilesetBitmapData.draw(tilesetImage);
			
			canvasBitmapData = new BitmapData(tileSize, tileSize, true, 0xFFFFFF);
			canvasBitmap = new Bitmap(canvasBitmapData);
			
			this.player = player;
			this.rank = rank;
			
			addChild(canvasBitmap);
		}

		// Getters and Setters
		public function get tilesetImage():DisplayObject 
		{
			return _tilesetImage;
		}
		
		public function set tilesetImage(value:DisplayObject):void 
		{
			_tilesetImage = value;
		}
		
		public function get tilesetBitmapData():BitmapData 
		{
			return _tilesetBitmapData;
		}
		
		public function set tilesetBitmapData(value:BitmapData):void 
		{
			_tilesetBitmapData = value;
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
		
		public function get player():Player 
		{
			return _player;
		}
		
		public function set player(value:Player):void 
		{
			_player = value;
			canvasBitmapData.copyPixels(tilesetBitmapData, new Rectangle((player.color - 1) * tileSize, (player.sex - 1) * tileSize, tileSize, tileSize), new Point(0, 0));
		}
		
		public function get rank():uint 
		{
			return _rank;
		}
		
		public function set rank(value:uint):void 
		{
			_rank = value;
			switch (value)
			{
				case 1:
					x = 600;
					y = 280;
					
					var flag:DisplayObject = new FlagImage();
					flag.x = 0;
					flag.y = -60;
					addChild(flag);
					break;
					
				case 2:
					x = 400;
					y = 310;
					break;
					
				case 3:
					x = 240;
					y = 180;
					break;
					
				case 4:
					x = 10;
					y = 210;
					break;
				
				default:
					visible = false;
					break;
			}
		}
		
		
		
	} // end class

} // end package