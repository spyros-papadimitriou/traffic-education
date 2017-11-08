package classes 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	import general.Game;

	public class Map extends Sprite
	{
		public var VISIBLE_ROWS:uint = 6;
		public var VISIBLE_COLS:uint = 6;

		public const TILESHEET_ROWS:uint = 7;
		public const TILESHEET_COLS:uint = 10;
		
		public const OBJECT_ROWS:uint = 3;
		public const OBJECT_COLS:uint = 5;
		
		public const NORTH:uint = 1;
		public const EAST:uint = 2;
		public const SOUTH:uint = 3;
		public const WEST:uint = 4;

		private var _backgrounds:Array;
		private var _types:Array;
		private var _tiles:Array;
		private var _targets:Array;
		
		private var _rows:uint = 0;
		private var _cols:uint = 0;
		private var _tileWidth:uint = 0;
		private var _tileHeight:uint = 0;

		[Embed(source="/assets/tileset96.jpg")]
		private var TileSheetMapCustom:Class;
		[Embed(source="/assets/tileset96_desyllas.jpg")]
		private var TileSheetMapDesyllas:Class;
		[Embed(source="/assets/objects96.png")]
		private var TileSheetObjectsCustom:Class;
		[Embed(source="/assets/objects96_desyllas.png")]
		private var TileSheetObjectsDesyllas:Class;
		private var _canvasBitmapData:BitmapData;
		private var _canvasBitmap:Bitmap;
		
		private var _tileSheetImage:DisplayObject;
		private var _tileSheetBitmapData:BitmapData;
		private var _objectsBitmap:DisplayObject;
		private var _objectsBitmapData:BitmapData;
		
		private var _graphicsURL:URLRequest;
		private var _graphicsLoader:Loader;
		private var _game:Game = Game.getInstance();
		
		public function Map() 
		{
			game.desyllas ? objectsBitmap = new TileSheetObjectsDesyllas(): objectsBitmap = new TileSheetObjectsCustom();
			objectsBitmapData = new BitmapData(objectsBitmap.width, objectsBitmap.height, true, 0xFFFFFF);
			objectsBitmapData.draw(objectsBitmap);
		} // end constructor
		
		public function build():void
		{
			if (backgrounds == null || backgrounds[0] == null || types == null || types[0] == null)
				return;

			var tempTile:Tile = new Tile();
			tileWidth = tempTile.TILE_WIDTH;
			tileHeight = tempTile.TILE_HEIGHT;
			tiles = new Array();

			// Δημιουργία γραφικών του χάρτη
			canvasBitmapData = new BitmapData(cols * tileWidth, rows * tileHeight, false, 0xFFFFFF);
			canvasBitmap = new Bitmap(canvasBitmapData);
			addChild(canvasBitmap);

			game.desyllas ? tileSheetImage = new TileSheetMapDesyllas(): tileSheetImage = new TileSheetMapCustom();
			tileSheetBitmapData = new BitmapData(tileSheetImage.width, tileSheetImage.height, false, 0xFF0000);
			var tileSheetRow:uint = 0;
			var tileSheetCol:uint = 0;
			tileSheetBitmapData.draw(tileSheetImage);

			for (var i:uint = 0; i < rows; i++ )
			{
				for (var j:uint = 0; j < cols; j++)
				{
					tempTile = new Tile();
					tempTile.map = this;
					tempTile.background = backgrounds[i][j];
					tempTile.num = i * cols + j;
					tempTile.row = i;
					tempTile.col = j;
					tempTile.x = j * tempTile.TILE_WIDTH;
					tempTile.y = i * tempTile.TILE_HEIGHT;
					tempTile.tf.text = tempTile.num.toString() + ": " + tempTile.type.toString();

					tileSheetRow = Math.floor(backgrounds[i][j] / TILESHEET_COLS);
					tileSheetCol = backgrounds[i][j] - tileSheetRow * TILESHEET_COLS;

					canvasBitmapData.copyPixels(tileSheetBitmapData, new Rectangle(tileSheetCol * tileWidth, tileSheetRow * tileHeight, tileWidth, tileHeight), new Point(tempTile.x, tempTile.y) );

					tempTile.type = types[i][j];
					tiles.push(tempTile);
					addChild(tempTile);
				} // end for
			} // end for
		}
		
		public function getTileByNum(value:uint):Tile
		{
			return tiles[value];
		}
		
		public function getTileByMouse(mouseX:Number, mouseY:Number):Tile
		{
			var tile:Tile = new Tile();
			var row:uint = mouseY / tile.TILE_HEIGHT;
			var col:uint = mouseX / tile.TILE_WIDTH;
			var num:uint = row * cols  + col;
			
			tile = getTileByNum(num);

			return tile;
		}

		public function findTargets(currentTile:Tile, previousTile:Tile, num:uint):void
		{
			var adjacents:Array = findAdjacents(currentTile, previousTile);
			var len:uint = adjacents.length;
			
			if (len && num && (previousTile == null || (currentTile.type != currentTile.RED_LIGHT && currentTile.type != currentTile.STOP)))
			{
				for (var i:uint = 0; i < len; i++)
				{
					findTargets(adjacents[i], currentTile, num - 1);
				} // end for
			} // end if
			else
			{
				currentTile.tf.text = currentTile.type.toString() + ": Πιθανός προορισμός.";
				currentTile.target = true;
			}
		}
		
		public function findAdjacents(tile:Tile, previousTile:Tile):Array
		{
			var result:Array = new Array();
			
			// Top
			if (tile.row - 1 >= 0 && tiles[tile.num - cols] != previousTile && tiles[tile.num - cols].type != tile.NOROAD)
				result.push(tiles[tile.num - cols]);
			
			// Right
			if (tile.col + 1 < cols && tiles[tile.num + 1] != previousTile && tiles[tile.num + 1].type != tile.NOROAD)
				result.push(tiles[tile.num + 1]);
			
			// Bottom
			if (tile.row + 1 < rows && tiles[tile.num + cols] != previousTile && tiles[tile.num + cols].type != tile.NOROAD)
				result.push(tiles[tile.num + cols]);
			
			// Left
			if (tile.col - 1 >= 0 && tiles[tile.num - 1] != previousTile && tiles[tile.num - 1].type != tile.NOROAD)
				result.push(tiles[tile.num - 1]);

			return result;
		}

		// Επιστρέφει true αν δύο tiles είναι γειτονικά
		public function isAdjacent(tile1:Tile, tile2:Tile):Boolean
		{
			if (tile1.col == tile2.col)
				if (tile1.row == tile2.row - 1 || tile1.row == tile2.row + 1)
					return true;
			
			if (tile1.row == tile2.row)
				if (tile1.col == tile2.col - 1 || tile1.col == tile2.col + 1)
					return true;
			
			return false;
		}

		// Κεντράρει το χάρτη στο tile που θέλουμε (εκτός αν είναι κοντά στα όρια)
		public function goToTile(tile:Tile):void
		{
			var _x:int = -tile.col * tile.TILE_WIDTH + (VISIBLE_COLS / 2) * tile.TILE_WIDTH;
			var _y:int = -tile.row * tile.TILE_HEIGHT + (VISIBLE_ROWS / 2) * tile.TILE_HEIGHT;

			if (tile.col <= VISIBLE_COLS / 2 - 1)
				_x -= (VISIBLE_COLS / 2 - tile.col) * tile.TILE_WIDTH;
			else if (tile.col >= cols - VISIBLE_COLS / 2)
				_x += (VISIBLE_COLS / 2 - (cols - tile.col)) * tile.TILE_WIDTH;

			if (tile.row <= VISIBLE_ROWS / 2 - 1)
				_y -= (VISIBLE_ROWS / 2 - tile.row) * tile.TILE_HEIGHT;
			else if (tile.row >= rows - 4)
				_y += (VISIBLE_ROWS / 2 - (rows - tile.row)) * tile.TILE_HEIGHT;

			x = _x;
			y = _y;
		}
		
		public function addObject(tile:Tile, type:uint):void
		{
			var tileSheetRow:uint = Math.floor(backgrounds[tile.row][tile.col] / TILESHEET_COLS);
			var tileSheetCol:uint = backgrounds[tile.row][tile.col] - tileSheetRow * TILESHEET_COLS;
			canvasBitmapData.copyPixels(tileSheetBitmapData, new Rectangle(tileSheetCol * tileWidth, tileSheetRow * tileHeight, tileWidth, tileHeight), new Point(tile.x, tile.y) );
		
			tileSheetRow = Math.floor(type / OBJECT_COLS);
			tileSheetCol = type - tileSheetRow * OBJECT_COLS;
			canvasBitmapData.copyPixels(objectsBitmapData, new Rectangle(tileSheetCol * tileWidth, tileSheetRow * tileHeight, tileWidth, tileHeight), new Point(tile.x, tile.y));
		}

		public function findDirection(source:uint, target:uint):uint
		{
			if (target == source + 1)
				return EAST;
			else if (target == source - 1)
				return WEST;
			else if (target == source + cols)
				return SOUTH;
			else if (target == source - cols)
				return NORTH;
			
			return 0;
		}
		
		// Getters and Setters
		public function get backgrounds():Array
		{
			return this._backgrounds;
		}
		
		public function set backgrounds(value:Array):void
		{
			this._backgrounds = value;
		}
		
		public function get types():Array
		{
			return this._types;
		}
		
		public function set types(value:Array):void
		{
			if (value == null || value[0] == null)
				return;
			
			this._types = value;
			rows = value.length;
			cols = value[0].length;
		}
		
		public function get tiles():Array
		{
			return this._tiles;
		}
		
		public function set tiles(value:Array):void
		{
			this._tiles = value;
		}
		
		public function get targets():Array
		{
			return this._targets;
		}
		
		public function set targets(value:Array):void
		{
			if (value == null)
			{
				for each (var tile:Tile in tiles)
				{
					tile.target = false;
					tile.tf.text = tile.type.toString();
				} // end for
			}
			
			this._targets = value;
		}
		
		public function get rows():uint
		{
			return this._rows;
		}
		
		public function set rows(value:uint):void
		{
			this._rows = value;
		}
		
		public function get cols():uint
		{
			return this._cols;
		}
		
		public function set cols(value:uint):void
		{
			this._cols = value;
		}

		public function get tileWidth():uint
		{
			return this._tileWidth;
		}
		
		public function set tileWidth(value:uint):void
		{
			this._tileWidth = value;
		}

		public function get tileHeight():uint
		{
			return this._tileHeight;
		}
		
		public function set tileHeight(value:uint):void
		{
			this._tileHeight = value;
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
		
		public function get objectsBitmap():DisplayObject 
		{
			return _objectsBitmap;
		}
		
		public function set objectsBitmap(value:DisplayObject):void 
		{
			_objectsBitmap = value;
		}
		
		public function get objectsBitmapData():BitmapData 
		{
			return _objectsBitmapData;
		}
		
		public function set objectsBitmapData(value:BitmapData):void 
		{
			_objectsBitmapData = value;
		}
		
		public function get tileSheetBitmapData():BitmapData 
		{
			return _tileSheetBitmapData;
		}
		
		public function set tileSheetBitmapData(value:BitmapData):void 
		{
			_tileSheetBitmapData = value;
		}
		
		public function get tileSheetImage():DisplayObject 
		{
			return _tileSheetImage;
		}
		
		public function set tileSheetImage(value:DisplayObject):void 
		{
			_tileSheetImage = value;
		}
		
		public function get graphicsURL():URLRequest 
		{
			return _graphicsURL;
		}
		
		public function set graphicsURL(value:URLRequest):void 
		{
			_graphicsURL = value;
		}
		
		public function get graphicsLoader():Loader 
		{
			return _graphicsLoader;
		}
		
		public function set graphicsLoader(value:Loader):void 
		{
			_graphicsLoader = value;
		}
		
		public function get game():Game 
		{
			return _game;
		}
		
		public function set game(value:Game):void 
		{
			_game = value;
		}
		
	} // end class

} // end package
