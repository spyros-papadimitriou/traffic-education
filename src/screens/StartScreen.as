package screens
{
	import flash.display.DisplayObject;
	import general.Screen;
	import general.MenuButton;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class StartScreen extends Screen
	{
		private var buttonSingle:MenuButton;
		private var buttonInstructions:MenuButton;
		private var buttonCredits:MenuButton;
		private var buttonGraphics:MenuButton;

		[Embed(source="/assets/background_main.jpg")]
		private var BackgroundMain:Class;
		
		public function StartScreen():void
		{
			super();
		} // end constructor

		override protected function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			var background:DisplayObject = new BackgroundMain();
			addChild(background);

			buttonSingle = new MenuButton("ΕΠΙΛΟΓΗ ΠΑΙΚΤΩΝ");
			buttonSingle.x = game.WIDTH / 2 - buttonSingle.width / 2;
			buttonSingle.y = 180;
			addChild(buttonSingle);
			
			var graphicsText:String;
			game.desyllas ? graphicsText = "Επιτραπέζιο": graphicsText = "Καρτούν";
			
			buttonGraphics = new MenuButton("ΓΡΑΦΙΚΑ: " + graphicsText);
			buttonGraphics.x = game.WIDTH / 2 - buttonGraphics.width / 2;
			buttonGraphics.y = buttonSingle.y + buttonSingle.height + 20;
			addChild(buttonGraphics);

			buttonInstructions = new MenuButton("ΟΔΗΓΙΕΣ");
			buttonInstructions.x = buttonGraphics.x;
			buttonInstructions.y = buttonGraphics.y + buttonGraphics.height + 20;
			addChild(buttonInstructions);
			
			buttonCredits = new MenuButton("CREDITS");
			buttonCredits.x = buttonInstructions.x;
			buttonCredits.y = buttonInstructions.y + buttonInstructions.height + 20;
			addChild(buttonCredits);

			buttonSingle.addEventListener(MouseEvent.CLICK, onClickButton);
			buttonGraphics.addEventListener(MouseEvent.CLICK, onClickButtonGraphics);
			buttonInstructions.addEventListener(MouseEvent.CLICK, onClickButton);
			buttonCredits.addEventListener(MouseEvent.CLICK, onClickButton);
			
			showMiniplay();
		}
		
		private function onClickButtonGraphics(e:MouseEvent):void
		{
			var graphicsText:String;

			game.desyllas = !game.desyllas;
			game.desyllas ? graphicsText = "Επιτραπέζιο": graphicsText = "Καρτούν";
					
			buttonGraphics.tf.text = "ΓΡΑΦΙΚΑ: " + graphicsText;
		}

		private function onClickButton(event:MouseEvent):void
		{
			var button:MenuButton = event.currentTarget as MenuButton;

			buttonSingle.removeEventListener(MouseEvent.CLICK, onClickButton);
			buttonGraphics.removeEventListener(MouseEvent.CLICK, onClickButton);
			buttonInstructions.removeEventListener(MouseEvent.CLICK, onClickButton);
			buttonCredits.removeEventListener(MouseEvent.CLICK, onClickButton);

			switch (button)
			{
				case buttonSingle:
					var selectPlayerScreen:SelectPlayerScreen = new SelectPlayerScreen();
					selectPlayerScreen.create();
				break;
				
				case buttonInstructions:
					var instructionsScreen:InstructionsScreen = new InstructionsScreen();
					instructionsScreen.create();
				break;
				
				case buttonCredits:
					var creditsScreen:CreditsScreen = new CreditsScreen();
					creditsScreen.create();
				break;
			} // end switch

		}

	} // end class

} // end package
