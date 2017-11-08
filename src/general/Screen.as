package general 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import general.Game;
	
	public class Screen extends Sprite 
	{
		protected var _game:Game;
		private var _miniplay:TextField;
		private var _miniplayFormat:TextFormat;

		public function Screen() 
		{
			game = Game.getInstance();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			if (game.currentScreen != null)
			{
				game.currentScreen.destroy();
				game.root.removeChild(game.currentScreen);
			} // end if

			game.currentScreen = this;
			
			miniplayFormat = new TextFormat("customFont", 14, 0x000000, true);
			miniplayFormat.align = "center";
			
			miniplay = new TextField();
			miniplay.embedFonts = true;
			miniplay.selectable = false;
			miniplay.setTextFormat(miniplayFormat);
			miniplay.defaultTextFormat = miniplayFormat;
			miniplay.text = "miniplay.gr";
			miniplay.width = miniplay.textWidth + 10;
			miniplay.height = 20;
			miniplay.x = game.stage.stageWidth - miniplay.width;
			miniplay.y = game.stage.stageHeight - miniplay.height;
			//miniplay.border = true;
			miniplay.addEventListener(MouseEvent.CLICK, onClickMiniplay);
			
			trace("Entering " + this + "...");
		} // end constructor
		
		protected function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onClickMiniplay(e:MouseEvent):void
		{
			 var url:String = "http://www.miniplay.gr/";
			 var request:URLRequest = new URLRequest(url);
			 navigateToURL(request, "_blank");
		}

		public function create():void
		{
			game.root.addChild(this);
			addEventListener(Event.ENTER_FRAME, onEnterFrame); // Σε περίπτωση που βάλω εφφέ κατά την εναλλαγή των οθονών
		}
		
		private function onEnterFrame(e:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		public function destroy():void
		{
			trace ("Destroying " + this + "...");

			while (numChildren)
				removeChildAt(0);
		}
		
		public function showMiniplay():void
		{
			addChild(miniplay);
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
		
		public function get miniplay():TextField 
		{
			return _miniplay;
		}
		
		public function set miniplay(value:TextField):void 
		{
			_miniplay = value;
		}
		
		public function get miniplayFormat():TextFormat 
		{
			return _miniplayFormat;
		}
		
		public function set miniplayFormat(value:TextFormat):void 
		{
			_miniplayFormat = value;
		}
		
	} // end class

} // end package
