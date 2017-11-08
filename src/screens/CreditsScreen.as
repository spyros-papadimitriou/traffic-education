package screens
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import general.Screen;
	import general.MenuButton;

	public class CreditsScreen extends Screen
	{
		[Embed(source="/assets/background_general.jpg")]
		private var Background:Class;
		
		private var buttonBack:MenuButton;
		private var infoFormat:TextFormat;
		private var info:TextField;
		
		public function CreditsScreen():void
		{
			super();
		} // end constructor
		
		override protected function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			var background:DisplayObject = new Background();

			buttonBack = new MenuButton("ΠΙΣΩ");
			buttonBack.backgroundColor = buttonBack.RED;
			buttonBack.x = (game.WIDTH - buttonBack.width) / 2;
			buttonBack.y = game.HEIGHT - buttonBack.height - 20;
			
			infoFormat = new TextFormat("customFont", 20, 0x000000);
			infoFormat.align = "center";
			
			info = new TextField();
			info.embedFonts = true;
			//info.border = true;
			info.selectable = false;
			info.multiline = true;
			info.wordWrap = true;
			info.setTextFormat(infoFormat);
			info.defaultTextFormat = infoFormat;
			info.width = game.WIDTH - 100;
			info.height = game.HEIGHT / 2 + 100;
			info.x = (game.WIDTH - info.width) / 2;
			info.y = (game.HEIGHT - info.height) / 2 - 50;

			var output:String = "";
			output += "ΚΥΚΛΟΦΟΡΙΑΚΗ ΑΓΩΓΗ";
			
			output += "<br /><br /><a href='http://www.desyllasgames.gr/products.aspx?id=9&prod=1416' target='_blank'>Βασισμένο στο ομώνυμο παιχνίδι της εταιρείας Desyllas Games.</a>"
			
			output += "<br /><br />Game Programming";
			output += "<br /><a href='http://www.spyrospapadimitriou.gr' target='_blank'>Σπύρος Παπαδημητρίου<br />http://www.spyrospapadimitriou.gr</a>"
			
			output += "<br /><br />Game Graphics Designer";
			output += "<br /><a href='http://www.facebook.com/Rodostamohandmade' target='_blank'>Τόνια Οικονομίδου<br />http://www.facebook.com/Rodostamohandmade</a>";
			
			output += "<br /><br />Fonts";
			output += "<br /><a href='http://www.backpacker.gr/' target='_blank'>BPreplayExtended<br />http://www.backpacker.gr</a>";
			
			info.htmlText = output;
			
			addChild(background);
			addChild(buttonBack);
			addChild(info);
			showMiniplay();
			
			buttonBack.addEventListener(MouseEvent.CLICK, onClickBack);
		}
		
		private function onClickBack(e:MouseEvent):void
		{
			buttonBack.removeEventListener(MouseEvent.CLICK, onClickBack);
			
			var startScreen:StartScreen = new StartScreen();
			startScreen.create();
		}
		
	} // end class

} // end package
