package classes 
{
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class Tile extends Sprite
	{
		public const RED_LIGHT:uint = 1;
		public const STOP:uint = 2;
		public const PEDESTRIAN_CROSSING:uint = 3;
		public const PROHIBITED:uint = 4;
		public const POLICEMAN:uint = 5;
		public const ORDER:uint = 6;
		
		public const ROAD:uint = 7;
		public const NOROAD:uint = 8;
		public const GREEN_LIGHT:uint = 9;
		public const POLICEMAN_ALLOWED:uint = 10;
		public const TRANSIT:uint = 11;
		
		public const TILE_WIDTH:uint = 96;
		public const TILE_HEIGHT:uint = 96;

		private var _map:Map;
		private var _background:uint = 0;
		private var _type:uint = 0;
		private var _target:Boolean = false;
		private var _visited:Boolean = false;
		
		private var _num:uint = 0;
		private var _row:uint = 0;
		private var _col:uint = 0;

		private var _usedItem:Boolean = false;
		
		// Temporary properties
		private var shape:Sprite;
		private var circle:Sprite;
		private var textFormat:TextFormat;
		public var tf:TextField;
		
		public function Tile() 
		{
			shape = new Sprite();
			shape.graphics.beginFill(0x333333, 0.4);
			shape.graphics.drawRect(0, 0, TILE_WIDTH - 1, TILE_HEIGHT - 1);
			shape.graphics.endFill();
			
			textFormat = new TextFormat("customFont", 11, 0x000000, true);
			
			tf = new TextField();
			tf.embedFonts = true;
			tf.width = shape.width;
			tf.height = shape.height;
			tf.selectable = false;
			tf.multiline = true;
			tf.wordWrap = true;
			tf.setTextFormat(textFormat);
			tf.defaultTextFormat = textFormat;
			
			shape.visible = false;
			shape.addChild(tf);
			addChild(shape);
			
			// Temporary for marking help
			circle = new Sprite();
			circle.graphics.beginFill(0xFF794B);
			circle.graphics.drawCircle(TILE_WIDTH / 2, TILE_HEIGHT / 2, 10);
			circle.visible = false;
			addChild(circle);
		} // end constructor
		
		// Getters and Setters
		public function get map():Map
		{
			return this._map;
		}
		
		public function set map(value:Map):void
		{
			this._map = value;
		}

		public function get background():uint
		{
			return this._background;
		}
		
		public function set background(value:uint):void
		{
			this._background = value;
		}
		
		public function get type():uint
		{
			return this._type;
		}
		
		public function set type(value:uint):void
		{
			this._type = value;
			map.addObject(this, value);
		}
		
		public function get target():Boolean
		{
			return this._target;
		}
		
		public function set target(value:Boolean):void
		{
			this._target = value;
			value == true ? circle.visible = true: circle.visible = false;
		}
		
		public function get visited():Boolean
		{
			return this._visited;
		}
		
		public function set visited(value:Boolean):void
		{
			this._visited = value;
			shape.visible = value;
		}
		
		public function get num():uint
		{
			return this._num;
		}
		
		public function set num(value:uint):void
		{
			this._num = value;
		}
		
		public function get row():uint
		{
			return this._row;
		}
		
		public function set row(value:uint):void
		{
			this._row = value;
		}
		
		public function get col():uint
		{
			return this._col;
		}
		
		public function set col(value:uint):void
		{
			this._col = value;
		}

		public function get usedItem():Boolean
		{
			return this._usedItem;
		}
		
		public function set usedItem(value:Boolean):void
		{
			this._usedItem = value;
		}
		
	} // end class

} // end package
