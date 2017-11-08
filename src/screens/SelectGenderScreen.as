package screens 
{
	import classes.Player;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import general.CharacteristicButton;
	import general.MenuButton;
	import general.Screen;
	
	public class SelectGenderScreen extends Screen 
	{
		
		[Embed(source="/assets/background_general.jpg")]
		private var Background:Class;
		[Embed(source = "/assets/titles/select_characteristics.png")]
		private var TitleImage:Class;
		
		private var buttonStart:MenuButton;
		private var buttonBack:MenuButton;
		
		private var playerButton:CharacteristicButton;
		private var genderButton:CharacteristicButton;
		private var greenLightButton:CharacteristicButton;
		private var policemanButton:CharacteristicButton;
		private var transitButton:CharacteristicButton
		
		private var currentPlayer:Object;
		private var players:Array; // Οι παίκτες που έχουν επιλεχθεί να παίξουν
		
		private var infoFormat:TextFormat;
		private var info:TextField;
		
		public function SelectGenderScreen() 
		{
			super();
			players = new Array();
			
			if (game.playerBlue.playedBy)
				players.push(game.playerBlue);
			if (game.playerYellow.playedBy)
				players.push(game.playerYellow);
			if (game.playerGreen.playedBy)
				players.push(game.playerGreen);
			if (game.playerRed.playedBy)
				players.push(game.playerRed);
				
			initPlayer(game.playerBlue);
			initPlayer(game.playerYellow);
			initPlayer(game.playerGreen);
			initPlayer(game.playerRed);
				
			currentPlayer = players[0];
		} // end constructor
		
		private function initPlayer(player:Object):void
		{
			player.gender = 1;
			player.greenLight = 0;
			player.policeman = 0;
			player.transit = 0;
			player.total = 0;
			
			if (player.playedBy == 2)
			{
				var num:uint;
				player.gender = Math.round(1 + 1 * Math.random());
				
				for (var i:uint = 0; i < 3; i++)
				{					
				
					num = Math.round(1 + 2 * Math.random());
					switch (num)
					{
						case 1:
							player.greenLight++;
							break;
							
						case 2:
							player.policeman++;
							break;
							
						case 3:
							player.transit++;
							break;
					}
					player.total++;
				} // end for
			}
		}
		
		override protected function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			var background:DisplayObject = new Background();
			var title:DisplayObject = new TitleImage();
			title.x = (game.WIDTH - title.width) / 2;
			title.y = 30;
			
			playerButton = new CharacteristicButton("Παίκτης");
			playerButton.x = 20;
			playerButton.y = 210;
			if (players.length == 1)
				playerButton.enabled = false;
			
			genderButton = new CharacteristicButton("Φύλο");
			genderButton.x = (game.WIDTH - genderButton.width) / 2 + 150;
			genderButton.y = 210;
			
			greenLightButton = new CharacteristicButton("Πράσινο Φανάρι");
			greenLightButton.x = genderButton.x;
			greenLightButton.y = genderButton.y + genderButton.height + 10;
			
			policemanButton = new CharacteristicButton("Τροχονόμος");
			policemanButton.x = genderButton.x;
			policemanButton.y = greenLightButton.y + greenLightButton.height + 10;
			
			transitButton = new CharacteristicButton("Διέλευση");
			transitButton.x = genderButton.x;
			transitButton.y = policemanButton.y + policemanButton.height + 10;
			
			buttonStart = new MenuButton("ΕΝΑΡΞΗ ΠΑΙΧΝΙΔΙΟΥ");
			buttonStart.backgroundColor = buttonStart.RED;
			buttonStart.x = game.WIDTH - buttonStart.width - 50;
			buttonStart.y = transitButton.y + transitButton.height + 10;
			//buttonStart.x = genderButton.x + genderButton.width + 20;
			//buttonStart.y = genderButton.y + 2 * (genderButton.height + 10) - buttonStart.height / 2;
			buttonBack = new MenuButton("ΠΙΣΩ");
			buttonBack.backgroundColor = buttonBack.RED;
			buttonBack.x = 50;
			buttonBack.y = buttonStart.y;
			
			infoFormat = new TextFormat("customFont", 18, 0x000000);
			infoFormat.align = "left";
			
			info = new TextField();
			info.embedFonts = true;
			info.setTextFormat(infoFormat);
			info.defaultTextFormat = infoFormat;
			//info.border = true;
			info.multiline = true;
			info.wordWrap = true;
			info.width = playerButton.width;
			info.height = playerButton.height * 3;
			info.x = playerButton.x;
			info.y = playerButton.y + playerButton.height + 10;
			
			update();
			
			addChild(background);
			addChild(title);
			
			addChild(playerButton);
			addChild(genderButton);
			addChild(greenLightButton);
			addChild(policemanButton);
			addChild(transitButton);
			
			addChild(info);
			addChild(buttonStart);
			addChild(buttonBack);
			
			playerButton.addEventListener(MouseEvent.CLICK, onClickPlayer);
			genderButton.addEventListener(MouseEvent.CLICK, onClickGender);
			
			greenLightButton.addEventListener(MouseEvent.CLICK, onClickGreenLight);
			policemanButton.addEventListener(MouseEvent.CLICK, onClickPoliceman);
			transitButton.addEventListener(MouseEvent.CLICK, onClickTransit);
			
			buttonStart.addEventListener(MouseEvent.CLICK, onClickStart);
			buttonBack.addEventListener(MouseEvent.CLICK, onClickBack);
		}
		
		private function update():void
		{
			playerButton.description = currentPlayer.name;
			currentPlayer.gender == 1 ? genderButton.description = "Φύλο: Αγόρι": genderButton.description = "Φύλο: Κορίτσι";
			greenLightButton.description = "Πράσινο φανάρι: " + currentPlayer.greenLight;
			policemanButton.description = "Τροχονόμος: " + currentPlayer.policeman;
			transitButton.description = "Διέλευση: " + currentPlayer.transit;
			
			if (currentPlayer.playedBy == 1)
			{
				genderButton.enabled = true;
				greenLightButton.enabled = true;
				policemanButton.enabled = true;
				transitButton.enabled = true;
			} else {
				genderButton.enabled = false;
				greenLightButton.enabled = false;
				policemanButton.enabled = false;
				transitButton.enabled = false;
			}
			
			if (players.length == 1)
				info.text = "Στον αγώνα θα πάρει μέρος ένας οδηγός.\n\n";
			else
				info.text = "Στον αγώνα θα πάρουν μέρος " + players.length.toString() + " οδηγοί.\n\n";
			
			if (currentPlayer.playedBy == 1)
				if (currentPlayer.total < 3)
					info.appendText("Πρέπει να επιλέξεις 3 πλακίδια για να έχεις στην κατοχή σου.");
				else
					info.appendText("Ο παίκτης είναι έτοιμος για το παιχνίδι.");
			else
				info.appendText("Ο υπολογιστής χειρίζεται το συγκεκριμένο αυτοκίνητο και έχει επιλέξει ήδη 3 πλακίδια.");
			
			var currentTotal:uint = 0;
			for (var i:uint = 0; i < players.length; i++)
				currentTotal += players[i].total;
				
			if (currentTotal == players.length * 3)
			{
				buttonStart.visible = true;
				info.appendText("\n\nΤο παιχνίδι είναι έτοιμο να ξεκινήσει!");
			}
			else
				buttonStart.visible = false;
		}
		
		private function onClickPlayer(e:MouseEvent):void
		{
			var clicked:uint = e.currentTarget.buttonClicked(e.currentTarget.mouseX, e.currentTarget.mouseY);
			
			if (clicked == 2)
				loadNext();
			else if (clicked == 1)
				loadPrevious();
		}
		
		private function loadPrevious():void
		{
			var index:uint = players.indexOf(currentPlayer);
			if (index == 0)
				currentPlayer = players[players.length - 1];
			else
				currentPlayer = players[--index];
			
			update();
		}
		
		private function loadNext():void
		{
			var index:uint = players.indexOf(currentPlayer);
			if (index == players.length - 1)
				currentPlayer = players[0];
			else
				currentPlayer = players[++index];
			
			update();
		}
		
		private function onClickStart(e:MouseEvent):void
		{
			buttonStart.removeEventListener(MouseEvent.CLICK, onClickStart);
			buttonBack.removeEventListener(MouseEvent.CLICK, onClickBack);
			
			var gameScreen:GameScreen = new GameScreen();
			gameScreen.create();
		}
		
		private function onClickBack(e:MouseEvent):void
		{
			buttonStart.removeEventListener(MouseEvent.CLICK, onClickStart);
			buttonBack.removeEventListener(MouseEvent.CLICK, onClickBack);
			
			var selectPlayerScreen:SelectPlayerScreen = new SelectPlayerScreen();
			selectPlayerScreen.create();
		}
		
		private function onClickGender(e:MouseEvent):void
		{
			var clicked:uint = e.currentTarget.buttonClicked(e.currentTarget.mouseX, e.currentTarget.mouseY);
			
			if (clicked)
				currentPlayer.gender == 1 ? currentPlayer.gender = 2: currentPlayer.gender = 1;

			update();
		}
		
		private function onClickGreenLight(e:MouseEvent):void
		{
			var clicked:uint = e.currentTarget.buttonClicked(e.currentTarget.mouseX, e.currentTarget.mouseY);
			
			if (clicked == 2)
			{
				if (currentPlayer.total < 3)
				{
					currentPlayer.greenLight++;
					currentPlayer.total++;
				}
			} else if (clicked == 1)
			{
				if (currentPlayer.greenLight > 0)
				{
					currentPlayer.greenLight--;
					currentPlayer.total--;
				}
			}

			update();
		}
		
		private function onClickPoliceman(e:MouseEvent):void
		{
			var clicked:uint = e.currentTarget.buttonClicked(e.currentTarget.mouseX, e.currentTarget.mouseY);
			
			if (clicked == 2)
			{
				if (currentPlayer.total < 3)
				{
					currentPlayer.policeman++;
					currentPlayer.total++;
				}
			} else if (clicked == 1)
			{
				if (currentPlayer.policeman > 0)
				{
					currentPlayer.policeman--;
					currentPlayer.total--;
				}
			}

			update();
		}
		
		private function onClickTransit(e:MouseEvent):void
		{
			var clicked:uint = e.currentTarget.buttonClicked(e.currentTarget.mouseX, e.currentTarget.mouseY);
			
			if (clicked == 2)
			{
				if (currentPlayer.total < 3)
				{
					currentPlayer.transit++;
					currentPlayer.total++;
				}
			} else if (clicked == 1)
			{
				if (currentPlayer.transit > 0)
				{
					currentPlayer.transit--;
					currentPlayer.total--;
				}
			}

			update();
		}
		
	} // end class

} // end package
