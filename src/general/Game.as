package general
{
	import classes.Player;
	import flash.display.Stage;
	import flash.display.Sprite;
	import flash.text.TextField;

	public class Game
	{
		private static var instance:Game = null;

		private var _stage:Stage;
		private var _root:Sprite;
		private var _currentScreen:Screen = null;

		public const NOPLAY:uint = 0;
		public const PLAYER:uint = 1;
		public const COMPUTER:uint = 2;
		public const WIDTH:uint = 800;
		public const HEIGHT:uint = 576;

		public var playerBlue:Object = { name:"Μπλε παίκτης", playedBy:1, gender:1, greenLight:1, transit:1, policeman:1, total:3 };
		public var playerYellow:Object = { name:"Κίτρινος παίκτης", playedBy:2, gender:1, greenLight:1, transit:1, policeman:1, total:3 };
		public var playerGreen:Object = { name:"Πράσινος παίκτης",playedBy:0, gender:1, greenLight:0, transit:0, policeman:0, total:0 };
		public var playerRed:Object = { name:"Κόκκινος παίκτης", playedBy:0, gender:1, greenLight:0, transit:0, policeman:0, total:0 };

		public var numPlayers:uint = 0; // Ο αριθμός των παικτών στο παιχνίδι (που δεν έχουν τερματίσει ακόμα)
		public var ranking:Array = new Array(); // Τελική κατάταξη των παικτών
		public var desyllas:Boolean = false;

		public var info:TextField;
		
		[Embed(source="/assets/fonts/BPreplayExtendedBold.otf", fontName="customFont", mimeType="application/x-font", fontWeight="bold", fontStyle="normal", unicodeRange="U+0020,U+0041-005A, U+0020,U+0061-007A, U+0030-0039,U+002E, U+0020-002F,U+003A-0040,U+005B-0060,U+007B-007E, U+0020-002F,U+0030-0039,U+003A-0040,U+0041-005A,U+005B-0060,U+0061-007A,U+007B-007E, U+0374-03F2,U+1F00-1FFE,U+2000-206F,U+20A0-20CF,U+2100-2183", advancedAntiAliasing="true", embedAsCFF="false")]
		public static const CustomFont:Class

		public function Game():void
		{
		} // end constructor

		public static function getInstance():Game
		{
			if (instance == null)
				instance = new Game();

			return instance;
		}

		// Getters and Setters
		public function get stage():Stage
		{
			return this._stage;
		}
		
		public function set stage(value:Stage):void
		{
			this._stage = value;
		}

		public function get root():Sprite
		{
			return this._root;
		}
		
		public function set root(value:Sprite):void
		{
			this._root = value;
		}

		public function get currentScreen():Screen
		{
			return this._currentScreen;
		}
		
		public function set currentScreen(value:Screen):void
		{
			this._currentScreen = value;
		}

	} // end class

} // end package
