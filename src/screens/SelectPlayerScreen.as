package screens
{
	import flash.display.DisplayObject;
	import general.Screen;
	import general.MenuButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Sprite;

	public class SelectPlayerScreen extends Screen
	{
		private var buttonBlue:MenuButton;
		private var buttonYellow:MenuButton;
		private var buttonGreen:MenuButton;
		private var buttonRed:MenuButton;

		private var buttonStart:MenuButton;
		private var buttonBack:MenuButton;

		private var menu:Sprite;
		private var offset:uint = 20;
		
		[Embed(source="/assets/background_main.jpg")]
		private var BackgroundMain:Class;

		public function SelectPlayerScreen():void
		{
			super();

			game.ranking = new Array();
		} // end constructor

		override protected function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			var background:DisplayObject = new BackgroundMain();
			addChild(background);

			menu = new Sprite();

			buttonBlue = new MenuButton();
			buttonBlue.backgroundColor = buttonBlue.BLUE;
			loadText(buttonBlue, "", game.playerBlue.playedBy);
			menu.addChild(buttonBlue);

			buttonYellow = new MenuButton();
			buttonYellow.backgroundColor = buttonYellow.YELLOW;
			buttonYellow.y = buttonBlue.y + buttonBlue.height + offset;
			loadText(buttonYellow, "", game.playerYellow.playedBy);
			menu.addChild(buttonYellow);

			buttonRed = new MenuButton();
			buttonRed.backgroundColor = buttonRed.RED;
			buttonRed.x = buttonBlue.x + buttonBlue.width + offset;
			buttonRed.y = buttonBlue.y;
			loadText(buttonRed, "", game.playerRed.playedBy);
			menu.addChild(buttonRed);
			
			buttonGreen = new MenuButton();
			buttonGreen.backgroundColor = buttonGreen.GREEN;
			buttonGreen.x = buttonRed.x;
			buttonGreen.y = buttonYellow.y;
			loadText(buttonGreen, "", game.playerGreen.playedBy);
			menu.addChild(buttonGreen);

			buttonStart = new MenuButton("ΕΠΟΜΕΝΗ ΟΘΟΝΗ");
			buttonStart.backgroundColor = buttonStart.RED;
			buttonStart.x = (menu.width - buttonStart.width) / 2;
			buttonStart.y = 2 * (buttonBlue.y + buttonBlue.height + offset);
			menu.addChild(buttonStart);

			buttonBack = new MenuButton("ΠΙΣΩ");
			buttonBack.backgroundColor = buttonBack.RED;
			buttonBack.x = buttonStart.x;
			buttonBack.y = 3 * (buttonBlue.y + buttonBlue.height + offset);
			menu.addChild(buttonBack);

			menu.x = (game.WIDTH - menu.width) / 2;
			menu.y = (game.HEIGHT - menu.height) / 2 + 80;
			addChild(menu);
			
			showMiniplay();

			menu.addEventListener(MouseEvent.CLICK, onClickMenu);
		}

		private function onClickMenu(event:MouseEvent):void
		{
			var button:MenuButton = event.target as MenuButton;

			switch (button)
			{
				case buttonBlue:
					game.playerBlue.playedBy = selectPlayer(game.playerBlue.playedBy);
					loadText(buttonBlue, "", game.playerBlue.playedBy);
				break;

				case buttonYellow:
					game.playerYellow.playedBy = selectPlayer(game.playerYellow.playedBy);
					loadText(buttonYellow, "", game.playerYellow.playedBy);
				break;

				case buttonRed:
					game.playerRed.playedBy = selectPlayer(game.playerRed.playedBy);
					loadText(buttonRed, "", game.playerRed.playedBy);
				break;
				
				case buttonGreen:
					game.playerGreen.playedBy = selectPlayer(game.playerGreen.playedBy);
					loadText(buttonGreen, "", game.playerGreen.playedBy);
				break;

				case buttonStart:
					var selectGenderScreen:SelectGenderScreen = new SelectGenderScreen();
					selectGenderScreen.create();
				break;

				case buttonBack:
					var startScreen:StartScreen = new StartScreen();
					startScreen.create();
				break;
			} // end switch

			if (game.playerBlue.playedBy == 1 || game.playerYellow.playedBy == 1 || game.playerGreen.playedBy == 1 || game.playerRed.playedBy == 1)
				buttonStart.visible = true;
			else
				buttonStart.visible = false;

		}

		private function selectPlayer(value:uint):uint
		{
			if (value < 2)
				value++;
			else
				value = 0;

			return value;
		}

		private function loadText(button:MenuButton, descr:String, value:uint):void
		{
			switch (value)
			{
				case 0:
					button.tf.text = descr + "-";
				break;

				case 1:
					button.tf.text = descr + "ΠΑΙΚΤΗΣ";
				break;

				case 2:
					button.tf.text = descr + "ΥΠΟΛΟΓΙΣΤΗΣ";
				break;
			} // end switch
		}

	} // end class

} // end package
