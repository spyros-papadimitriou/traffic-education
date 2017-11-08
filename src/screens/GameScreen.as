package screens 
{
	import classes.Column;
	import classes.Die;
	import classes.Keypad;
	import classes.Map;
	import classes.Order;
	import classes.Player;
	import classes.Tag;
	import classes.Tile;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filters.DropShadowFilter;
	import flash.net.URLRequest;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import general.Screen;

	public class GameScreen extends Screen
	{
		private const speed:uint = 8;
		
		private var map:Map;
		private var die:Die;
		private var orders:Array = new Array();
		private var players:Array = new Array();
		private var availablePaths:Array = new Array();
		private var selectedPath:Array = new Array(); // η διαδρομή που επιλέγει να ακολουθήσει ο υπολογιστής
		private var currentPlayer:Player; // ο παίκτης που παίζει
		private var numPlayers:uint = 0; // Ο αριθμός των παικτών που παίζουν και δεν έχουν τερματίσει
		private var clickNext:Boolean = false;
		
		private var movingPath:Array; // Η διαδρομή που ακολουθεί το αυτοκίνητο κατά την κίνησή του
		private var totalMoved:uint = 0;
		private var direction:uint = 0;

		private var mapMask:Sprite; // Η μάσκα για το χάρτη.
		private var column:Column; // Η στήλη δεξιά
		private var tag:Tag; // Η ετικέτα πάνω από το ζάρι
		
		private var infoFormat:TextFormat;
		private var keypad:Keypad;
		private var exit:TextField;
		private var exitBackground:Sprite;

		public function GameScreen() 
		{
			super();
		} // end constructor
		
		override protected function onAddedToStage(event:Event):void
		{			
			var backgrounds:Array = [
									[11, 1, 10, 30, 31, 32, 33, 50, 51, 52, 40, 41, 42, 43, 11, 1, 10],
									[0, 70, 21, 1, 20, 1, 10, 60, 61, 62, 11, 1, 20, 1, 23, 71, 0],
									[0, 80, 2, 14, 0, 25, 21, 1, 20, 1, 23, 25, 0, 9, 2, 81, 0],
									[21, 1, 22, 20, 22, 1, 23, 74, 0, 75, 21, 1, 22, 20, 22, 1, 23],
									[0, 90, 91, 0, 5, 6, 0, 84, 0, 85, 0, 7, 8, 0, 92, 93, 0],
									[21, 1, 1, 23, 15, 16, 21, 1, 24, 1, 23, 17, 18, 21, 1, 1, 23],
									[0, 94, 95, 21, 1, 1, 23, 27, 2, 28, 21, 1, 1, 23, 96, 97, 0],
									[21, 1, 1, 23, 34, 35, 21, 1, 24, 1, 23, 54, 55, 21, 1, 1, 23],
									[0, 78, 79, 0, 44, 45, 0, 76, 0, 77, 0, 64, 65, 0, 88, 89, 0],
									[21, 1, 20, 22, 20, 1, 13, 86, 0, 87, 11, 1, 20, 22, 20, 1, 23],
									[0, 72, 2, 14, 0, 25, 21, 1, 22, 1, 23, 25, 0, 9, 2, 73, 0],
									[0, 82, 21, 1, 22, 1, 12, 57, 58, 59, 13, 1, 22, 1, 23, 83, 0],
									[13, 1, 12, 36, 37, 38, 39, 67, 68, 69, 46, 47, 48, 49, 13, 1, 12]
								];

			var types:Array = [
								[7, 7, 2, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 2, 7, 7],
								[6, 8, 7, 7, 1, 7, 6, 8, 8, 8, 6, 7, 1, 7, 7, 8, 6],
								[7, 8, 3, 8, 7, 8, 7, 4, 7, 4, 7, 8, 7, 8, 3, 8, 7],
								[2, 7, 7, 5, 7, 7, 1, 8, 7, 8, 1, 7, 7, 5, 7, 7, 2],
								[7, 8, 8, 7, 8, 8, 7, 8, 2, 8, 7, 8, 8, 7, 8, 8, 7],
								[7, 7, 1, 7, 8, 8, 7, 5, 7, 5, 7, 8, 8, 7, 1, 7, 7],
								[4, 8, 8, 6, 7, 7, 4, 8, 3, 8, 4, 7, 7, 6, 8, 8, 4],
								[7, 7, 1, 7, 8, 8, 7, 5, 7, 5, 7, 8, 8, 7, 1, 7, 7],
								[7, 8, 8, 7, 8, 8, 7, 8, 2, 8, 7, 8, 8, 7, 8, 8, 7],
								[2, 7, 7, 5, 7, 7, 1, 8, 7, 8, 1, 7, 7, 5, 7, 7, 2],
								[7, 8, 3, 8, 7, 8, 7, 4, 7, 4, 7, 8, 7, 8, 3, 8, 7],
								[6, 8, 7, 7, 1, 7, 6, 8, 8, 8, 6, 7, 1, 7, 7, 8, 6],
								[7, 7, 2, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 2, 7, 7]
							];
			map = new Map();	
			map.backgrounds = backgrounds;
			map.types = types;
			map.build();

			// Δημιουργούμε τις διαταγές
			for (var i:uint = 0 ; i < 6; i++)
				orders.push(new Order(1, ""));
			for (i = 0; i < 10; i++)
				orders.push(new Order(2, ""));
			for (i = 0; i < 4; i++)
				orders.push(new Order(3, ""));

			var player:Player;

			// Δημιουργούμε τους παίκτες	
			// Μπλε παίκτης
			if (game.playerBlue.playedBy)
			{
				player = new Player();
				player.name = "Μπλε παίκτης";
				player.color = player.BLUE;
				game.playerBlue.playerBy == game.COMPUTER ? player.computer = true: player.computer = false;
				player.sex = game.playerBlue.gender;
				player.greenLight = game.playerBlue.greenLight;
				player.transit = game.playerBlue.transit;
				player.policeman = game.playerBlue.policeman;
				player.homeTile = map.getTileByNum(0);
				player.passengerTile = map.getTileByNum(182);
				player.standingTile = map.getTileByNum(183);
				player.tile = player.homeTile;
				player.orders = orders;
				players.push(player);
				player.turn = players.length;
				player.direction = map.EAST;
			} // end if

			// Κίτρινος παίκτης
			if (game.playerYellow.playedBy)
			{
				player = new Player();
				player.name = "Κίτρινος παίκτης";
				player.color = player.YELLOW;
				player.sex = player.GIRL;
				game.playerYellow.playedBy == game.COMPUTER ? player.computer = true: player.computer = false;
				player.sex = game.playerYellow.gender;
				player.greenLight = game.playerYellow.greenLight;
				player.transit = game.playerYellow.transit;
				player.policeman = game.playerYellow.policeman;
				player.homeTile = map.getTileByNum(204);
				player.passengerTile = map.getTileByNum(46);
				player.standingTile = map.getTileByNum(47);
				player.tile = player.homeTile;
				player.orders = orders;
				players.push(player);
				player.turn = players.length;
				player.direction = map.EAST;
			} // end if

			// Πράσινος παίκτης
			if (game.playerGreen.playedBy)
			{
				player = new Player();
				player.color = player.GREEN;
				player.name = "Πράσινος παίκτης";
				game.playerGreen.playedBy == game.COMPUTER ? player.computer = true: player.computer = false;
				player.sex = game.playerGreen.gender;
				player.greenLight = game.playerGreen.greenLight;
				player.transit = game.playerGreen.transit;
				player.policeman = game.playerGreen.policeman;
				player.homeTile = map.getTileByNum(220);
				player.tile = player.homeTile;
				player.passengerTile = map.getTileByNum(38);
				player.standingTile = map.getTileByNum(37);
				player.orders = orders;
				players.push(player);
				player.turn = players.length;
				player.direction = map.WEST;
			} // end if

			// Κόκκινος παίκτης
			if (game.playerRed.playedBy)
			{
				player = new Player();
				player.color = player.RED;
				player.name = "Κόκκινος παίκτης";
				game.playerRed.playedBy == game.COMPUTER ? player.computer = true: player.computer = false;
				player.sex = game.playerRed.gender;
				player.greenLight = game.playerRed.greenLight;
				player.transit = game.playerRed.transit;
				player.policeman = game.playerRed.policeman;
				player.homeTile = map.getTileByNum(16);
				player.tile = player.homeTile;
				player.passengerTile = map.getTileByNum(174);
				player.standingTile = map.getTileByNum(173);
				player.orders = orders;
				players.push(player);
				player.turn = players.length;
				player.direction = map.WEST;
			} // end if

			game.numPlayers = players.length;
			game.ranking = new Array();

			// Ποιος παίζει τώρα?
			currentPlayer = players[0];
			map.goToTile(currentPlayer.tile); // Κεντράρισμα στο tile που βρίσκεται ο παίκτης που παίζει πρώτος

			// Δημιουργία της μάσκας
			mapMask = new Sprite();
			mapMask.graphics.beginFill(0xFF0000);
			mapMask.graphics.drawRect(0, 0, map.VISIBLE_COLS * 96, map.VISIBLE_ROWS * 96);
			mapMask.graphics.endFill();
			map.mask = mapMask;
			
			column = new Column();
			column.x = game.WIDTH - column.width;
			tag = new Tag();
			tag.x = (column.width - tag.width) / 2;
			tag.y = 10;

			// Δημιουργούμε το ζάρι
			die = new Die();
			die.x = mapMask.width + (game.WIDTH - mapMask.width - die.width) / 2;
			die.y = 140;
			tag.setText("Παίζει ο " + currentPlayer.name);
			die.addEventListener(MouseEvent.CLICK, onClickDie); // Ενεργοποιούμε το κλικ του ζαριού
			die.setReadyToClick(true);

			// Δημιουργία του πλαισίου πληροφοριών
			infoFormat = new TextFormat("customFont", 12, 0x000000, true);
			
			
			game.info = new TextField();
			game.info.embedFonts = true;
			game.info.selectable = false;
			game.info.width = game.WIDTH - mapMask.width - 40;
			game.info.height = game.HEIGHT - 40;
			game.info.wordWrap = true;
			game.info.x = mapMask.width + 20;
			game.info.y = die.y + die.height;
			game.info.setTextFormat(infoFormat);
			game.info.defaultTextFormat = infoFormat;
			game.info.text = currentPlayer.getInfo();
			
			// Δημιουργία του button για έξοδο από το παιχνίδι			
			exit = new TextField();
			exit.embedFonts = true;
			exit.setTextFormat(infoFormat);
			exit.defaultTextFormat = infoFormat;
			exit.selectable = false;
			exit.text = "Έξοδος";
			exit.width = exit.textWidth + 5;
			exit.height = exit.textHeight + 5;
			exit.x = 5;
			exit.y = 5;
			
			exitBackground = new Sprite();
			exitBackground.graphics.beginFill(0xCD8500);
			exitBackground.graphics.drawRect(0, 0, exit.width + 10, exit.height + 10);
			exitBackground.graphics.endFill();
			exitBackground.x = game.WIDTH - exitBackground.width - 5;
			exitBackground.y = 5;
			exitBackground.filters = [new DropShadowFilter()];
			exitBackground.mouseChildren = false;
			
			// Δημιουργία του keypad για τη μετακίνηση του χάρτη
			keypad = new Keypad();
			keypad.x = mapMask.width + (game.WIDTH - mapMask.width - keypad.width) / 2;
			keypad.y = game.HEIGHT - keypad.height - 30;

			addChild(map);
			addChild(column);
			addChild(game.info);
			exitBackground.addChild(exit);
			addChild(exitBackground);
			column.addChild(tag);
			addChild(die);
			addChild(keypad);
			addChild(mapMask);
			
			//showMiniplay();
			
			game.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			keypad.addEventListener(MouseEvent.MOUSE_DOWN, onPressKeypad);
			keypad.addEventListener(MouseEvent.MOUSE_UP, onClickKeypad);
			exitBackground.addEventListener(MouseEvent.CLICK, onClickExit);
		}
		
		private function removeListeners():void
		{
			if (game.stage.hasEventListener(KeyboardEvent.KEY_DOWN))
				game.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
			if (keypad.hasEventListener(MouseEvent.MOUSE_DOWN))
				keypad.removeEventListener(MouseEvent.MOUSE_DOWN, onPressKeypad);
			
			if (keypad.hasEventListener(MouseEvent.MOUSE_UP))
				keypad.removeEventListener(MouseEvent.MOUSE_UP, onClickKeypad);
			
			if (exitBackground.hasEventListener(MouseEvent.CLICK))
				exitBackground.removeEventListener(MouseEvent.CLICK, onClickExit);
		}
		
		private function onClickExit(e:MouseEvent):void
		{
			removeListeners();

			var startScreen:StartScreen = new StartScreen();
			startScreen.create();
		}
		
		private function onPressKeypad(e:MouseEvent):void
		{
			keypad.removeEventListener(MouseEvent.MOUSE_DOWN, onPressKeypad);

			var row:uint = keypad.mouseY / 48;
			var col:uint = keypad.mouseX / 48;
			
			if (row == 0 && col != 1)
				return;
			
			keypad.pressKey(row, col);
		}
		
		// Μετακίνηση του χάρτη με το keypad
		private function onClickKeypad(e:MouseEvent):void
		{
			var row:uint = keypad.mouseY / 48;
			var col:uint = keypad.mouseX / 48;

			if (row == 0 && col == 1)
				if (map.y != 0)
						map.y += map.tileHeight / 2;
			
			if (row == 1 && col == 0)
				if (map.x != 0)
						map.x += map.tileWidth / 2;
			
			if (row == 1 && col == 1)
				if (map.y != -(map.rows - map.VISIBLE_ROWS) * map.tileHeight)
						map.y -= map.tileHeight / 2;
			
			if (row == 1 && col == 2)
				if (map.x != -(map.cols - map.VISIBLE_COLS) * map.tileWidth)
						map.x -= map.tileWidth / 2;

			keypad.releaseKey();
			keypad.addEventListener(MouseEvent.MOUSE_DOWN, onPressKeypad);
		}
		
		private function onKeyUp(e:KeyboardEvent):void
		{
			stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			keypad.releaseKey();
		}

		// Μετακίνηση του χάρτη με τα βελάκια
		private function onKeyDown(event:KeyboardEvent):void
		{
			if (!stage.hasEventListener(KeyboardEvent.KEY_UP))
				stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			var key:uint = event.keyCode;

			switch (key)
			{
				case Keyboard.RIGHT:
					keypad.pressKey(1, 2);
					if (map.x != -(map.cols - map.VISIBLE_COLS) * map.tileWidth)
						map.x -= map.tileWidth / 2;
				break;
				
				case Keyboard.LEFT:
					keypad.pressKey(1, 0);
					if (map.x != 0)
						map.x += map.tileWidth / 2;
				break;
				
				case Keyboard.UP:
					keypad.pressKey(0, 1);
					if (map.y != 0)
						map.y += map.tileHeight / 2;
				break;
				
				case Keyboard.DOWN:
					keypad.pressKey(1, 1);
					if (map.y != -(map.rows - map.VISIBLE_ROWS) * map.tileHeight)
						map.y -= map.tileHeight / 2;
				break;
			} // end switch
		}

		// Όταν κάνουμε κλικ στο ζάρι
		private function onClickDie(event:MouseEvent):void
		{
			if (!game.numPlayers)
			{
				die.removeEventListener(MouseEvent.CLICK, onClickDie);
				die.setReadyToClick(false);
				
				removeListeners();
				var resultScreen:ResultScreen = new ResultScreen();
				resultScreen.create();
				return;
			}
			
			if (clickNext)
			{
				clickNext = false;
				nextPlayer();
				return;
			} // end if

			var play:Boolean = true;
			die.roll();
			
			if (!currentPlayer.computer)
				tag.setText("Μετακίνησε το αυτοκίνητο");

			switch (currentPlayer.tile.type)
			{
				case currentPlayer.tile.RED_LIGHT:
					if (die.num <= 3)
					{
						currentPlayer.tries--;
						play = false;
						tag.setText("Ξανακάνε κλικ στο ζάρι");
					}

					if (!currentPlayer.tries)
					{
						tag.setText("Επόμενος παίκτης");
						clickNext = true;
					}
				break;

				case currentPlayer.tile.POLICEMAN:
					if (die.num >= 4)
					{
						currentPlayer.tries--;
						play = false;
						tag.setText("Ξανακάνε κλικ στο ζάρι");
					}

					if (!currentPlayer.tries)
					{
						tag.setText("Επόμενος παίκτης");
						clickNext = true;
					}
				break;	
			} // end switch

			// Μετά το ρίξιμο του ζαριού, ο παίκτης πρέπει να ξεκινήσει το μονοπάτι από το tile στο οποίο βρίσκεται
			if (play)
			{
				die.removeEventListener(MouseEvent.CLICK, onClickDie);
				die.setReadyToClick(false);
				if (currentPlayer.computer)
					computerPlay();
				else
					currentPlayer.tile.addEventListener(MouseEvent.MOUSE_DOWN, onClickPlayer);
			} // end if

		}

		// Αφού κάνουμε κλικ πάνω στο tile που βρίσκεται ο παίκτης
		private function onClickPlayer(event:MouseEvent):void
		{
			currentPlayer.tile.removeEventListener(MouseEvent.MOUSE_DOWN, onClickPlayer);
			map.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			map.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}

		// Όταν ελευθερώσουμε το πλήκτρο του ποντικιού
		private function onMouseUp(event:MouseEvent):void
		{
			map.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			map.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			var tile:Tile = map.getTileByMouse(map.mouseX, map.mouseY);
			if (tile.target) // Αν είναι προορισμός
			{
				// Εδώ πρέπει να μπει η κίνηση του αυτοκινήτου
				movingPath = currentPlayer.currentPath.slice();
				movePlayer();
				return;
			} // end if
			else if (currentPlayer.currentPath.length > 1 && currentPlayer.currentPath[currentPlayer.currentPath.length - 2].target) // Αν το προηγούμενο είναι προορισμός (περίπτωση διάβασης πεζών)
			{
				// Εδώ πρέπει να μπει η κίνηση του αυτοκινήτου
				tile = currentPlayer.currentPath.pop();
				tile.visited = false;
				tile.target = false;
				movingPath = currentPlayer.currentPath.slice();
				movePlayer();
				return;
			}
			else
			{
				currentPlayer.clearCurrentPath();
				currentPlayer.tile.addEventListener(MouseEvent.MOUSE_DOWN, onClickPlayer);
				currentPlayer.tempGreenLight = currentPlayer.greenLight;
				currentPlayer.tempTransit = currentPlayer.transit;
				currentPlayer.tempPoliceman = currentPlayer.policeman;
			} // end else

		}

		// Όταν κινούμε τον κέρσορα του ποντικιού για τη δημιουργία διαδρομής
		private function onMouseMove(event:MouseEvent):void
		{
			var tile:Tile = map.getTileByMouse(map.mouseX, map.mouseY);
			var lastVisited:Tile = new Tile();

			if (event.buttonDown)
			{
				
				/******** Έλεγχοι ********/
				if (!currentPlayer.currentPath.length && tile != currentPlayer.tile) { return; } // Διόρθωση του bug με το 'Βήμα 0'
				if (tile.visited && tile != currentPlayer.currentPath[currentPlayer.currentPath.length - 1]) // Αν πάμε πίσω, καθάρισε τη διαδρομή μέχρι εκείνο το tile
				{
					lastVisited = currentPlayer.currentPath.pop();
					lastVisited.visited = false;
					lastVisited.target = false;
					currentPlayer.addTempItem(lastVisited);
					lastVisited.tf.text = lastVisited.num.toString() + ": " + lastVisited.type.toString();
					tile.target = false;
					return;
				}

				if (currentPlayer.currentPath.length > die.num) { return; } // Αν έχουμε συμπληρώσει τον αριθμό της ζαριάς
				if (tile.type == tile.NOROAD) { return; } // Αν δεν είναι δρόμος
				if (currentPlayer.tile.type == tile.PROHIBITED && currentPlayer.currentPath.length == 1 && currentPlayer.previousPath[currentPlayer.previousPath.length - 2] != tile ) { return; }// Αν πρέπει να κάνουμε αναστροφή λόγω απαγορευτικού

				if (currentPlayer.currentPath.length)
				{
					lastVisited = currentPlayer.currentPath[currentPlayer.currentPath.length - 1];

					if (lastVisited.target) { return; } // Αν είναι προορισμός
					if (!map.isAdjacent(tile, lastVisited)) { return; } // Αν δεν είναι γειτονικά
				} // end if
				/*************************/

				tile.visited = true;
				currentPlayer.currentPath.push(tile);
				
				// Ελέγχουμε αν είναι τελικός προορισμός
				if (currentPlayer.currentPath.length - 1 == die.num)
					if (tile.type == tile.PEDESTRIAN_CROSSING)
						lastVisited.target = true;
					else
						tile.target = true;
				else if (tile != currentPlayer.tile && ((tile.type == tile.RED_LIGHT && !currentPlayer.tempGreenLight) || (tile.type == tile.STOP && !currentPlayer.tempTransit) || (tile.type == tile.POLICEMAN && !currentPlayer.tempPoliceman) || (tile.type == tile.PROHIBITED && !currentPlayer.tempTransit) || (!currentPlayer.passenger && tile == currentPlayer.passengerTile) || (currentPlayer.passenger && tile == currentPlayer.homeTile)))
					tile.target = true;
				
				currentPlayer.removeTempItem(tile);
				if (tile == currentPlayer.tile)
					tile.tf.text = "Σημείο εκκίνησης";
				else
					tile.tf.text = "Βήμα " + (currentPlayer.currentPath.length - 1).toString();

			} // end if
		}

		private function computerPlay():void
		{
			trace("Computer plays.");

			var tempPath:Array = new Array();
			var maxWeight:int = -999;
			var weight:int = -999;
			tempPath.push(currentPlayer.tile);
			availablePaths = new Array();

			findAvailablePaths(tempPath, die.num);
			for (var i:uint = 0; i < availablePaths.length; i++)
			{
				availablePaths[i] = fixPath(availablePaths[i]);
				weight = calculateWeight(availablePaths[i]);

				if (weight > maxWeight)
				{
					maxWeight = weight;
					selectedPath = new Array();
					selectedPath.push(availablePaths[i]);
				}
			} // end for

			currentPlayer.clearCurrentPath();
			currentPlayer.currentPath = selectedPath[0];

			// Ο υπολογιστής μετακινεί τον παίκτη
			// Εδώ πρέπει να μπει η κίνηση του αυτοκινήτου
			movingPath = currentPlayer.currentPath.slice();
			movePlayer();
			return;
		}

		// Υπολογίζει τις διαδρομές που μπορεί να ακολουθήσει ο παίκτης του υπολογιστή χωρίς να λαμβάνεται υπόψη αν έχει πλακίδια στην κατοχή του
		private function findAvailablePaths(tempPath:Array, num:uint):void
		{
			if (num == 0)
			{
				availablePaths.push(tempPath);
				return;
			}
			var tempTile:Tile = tempPath[tempPath.length - 1];
			var previousTile:Tile = null;

			if (tempPath.length > 1)
				previousTile = tempPath[tempPath.length - 2];

			var adjacents:Array = map.findAdjacents(tempTile, previousTile);
			var newPath:Array = new Array();
			for each (var a:Tile in adjacents)
			{
				newPath = tempPath.concat(new Array());
				newPath.push(a);

				findAvailablePaths(newPath, num - 1);
			} // end for

		}

		// Επιστρέφει τις τελικές δυνατές διαδρομές βάσει εμποδίων και κατοχής πλακιδίων
		private function fixPath(path:Array):Array
		{
			var result:Array = new Array();
			result.push(path[0]); // Το πρώτο στοιχείο δε χρειάζεται έλεγχο εκτός αν πρόκειται για απαγορευτικό

			// Αναστροφή
			if (path[0].type == path[0].PROHIBITED && path[1] != currentPlayer.previousPath[currentPlayer.previousPath.length - 2])
				return result;

			var i:int = 1;
			var stop:Boolean = false;
			var tile:Tile;

			currentPlayer.tempGreenLight = currentPlayer.greenLight;
			currentPlayer.tempTransit = currentPlayer.transit;
			currentPlayer.tempPoliceman = currentPlayer.policeman;

			while (i < path.length && !stop)
			{
				tile = path[i];
				result.push(tile);

				switch (tile.type)
				{
					case tile.RED_LIGHT:
						if (currentPlayer.tempGreenLight)
							currentPlayer.tempGreenLight--;
						else
							stop = true;
					break;

					case tile.STOP:
						if (currentPlayer.tempTransit)
							currentPlayer.tempTransit--;
						else
							stop = true;
					break;

					case tile.POLICEMAN:
						if (currentPlayer.tempPoliceman)
							currentPlayer.tempPoliceman--;
						else
							stop = true;
					break;

					case tile.PROHIBITED:
						if (currentPlayer.tempTransit)
							currentPlayer.tempTransit--;
						else
							stop = true;
					break;
				} // end switch

				// Αν έφτασε σε επιβάτη ή γύρισε τον επιβάτη στην αφετηρία
				if ((!currentPlayer.passenger && currentPlayer.passengerTile == tile) || (currentPlayer.passenger && currentPlayer.homeTile == tile))
					stop = true;

				i++;
			} // end while

			// Περίπτωση διάβασης πεζών (αφαιρούμε το τελευταίο tile)
			if (tile.type == tile.PEDESTRIAN_CROSSING)
				result.pop();

			//for each (var r:Tile in result)
				//trace(r.num);
			//trace("---------------------");
			return result;
		}

		// Υπολογίζει το ειδικό βάρος μίας διαδρομής
		private function calculateWeight(path:Array):int
		{
			if (path.length <= 1) { return -999; }

			var weight:int = 0;
			var destinationTile:Tile;
			var targetTile:Tile = path[path.length - 1];

			if (!currentPlayer.passenger)
				destinationTile = currentPlayer.passengerTile;
			else
				destinationTile = currentPlayer.homeTile;

			weight -= (Math.abs(targetTile.row - destinationTile.row) + Math.abs(targetTile.col - destinationTile.col));

			weight += path.length;

			switch (targetTile.type)
			{
				case targetTile.RED_LIGHT:
					weight -= 2;
				break;

				case targetTile.STOP:
					weight -= 1;
				break;

				case targetTile.POLICEMAN:
					weight -= 2;
				break;

				case targetTile.PROHIBITED:
					weight -= 10;
				break;
			} // end switch

			return weight;
		}

		// Παίζει ο επόμενος παίκτης (έλεγχος για το αν έχει τερματίσει)
		// Γίνονται και τυχόν αρχικοποιήσεις για τον παίκτη που έπαιξε
		private function nextPlayer():void
		{
			if (!game.numPlayers)
			{
				//die.removeEventListener(MouseEvent.CLICK, onClickDie);
				//die.setReadyToClick(false);
				tag.setText("ΤΕΛΟΣ ΠΑΙΧΝΙΔΙΟΥ");

				var i:uint = 1;
				trace("All players finished.");
				trace("Ranking");
				trace("----------------");
				for each (var p:Player in game.ranking)
				{
					trace(i.toString() + ": Player " + p.color);
					i++
				} // end for
				return;
			} // end if

			currentPlayer.tries = 2;

			do
			{
				if (currentPlayer.turn < players.length)
					currentPlayer = players[currentPlayer.turn];
				else
					currentPlayer = players[0];
			} while (currentPlayer.finished);

			tag.setText("Παίζει ο " + currentPlayer.name);
			map.goToTile(currentPlayer.tile);
			game.info.text = currentPlayer.getInfo();
		}
		
		private function movePlayer():void
		{
			map.setChildIndex(currentPlayer.tile, map.numChildren - 1); // Διόρθωση του βάθους του αυτοκινήτου
			var currentTile:Tile = movingPath.shift();

			if (!movingPath.length)
			{
				currentPlayer.tile = currentTile;
				//currentPlayer.passenger = true; // Για τεστ
				finishMove();
				return;
			}
			
			var nextTile:Tile = movingPath[0];

			currentPlayer.direction = map.findDirection(currentTile.num, nextTile.num);
			totalMoved = 0;
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void
		{
			switch (currentPlayer.direction)
			{
				case map.NORTH:
					currentPlayer.y -= speed;
					break;
					
				case map.EAST:
					currentPlayer.x += speed;
					break;
					
				case map.SOUTH:
					currentPlayer.y += speed;
					break;
					
				case map.WEST:
					currentPlayer.x -= speed;
					break;
			}
			
			totalMoved += speed;
			if (totalMoved >= map.tileWidth)
			{
				stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				currentPlayer.useItem(movingPath[0]); // Το προσθέσαμε εκ των υστέρων για να χρησιμοποιεί τα αντικείμενα με το που περνάει πάνω από τα αντίστοιχα tiles!
				movePlayer();
			}
		}
		
		private function finishMove():void
		{
			die.arrow.visible = true;
			die.addEventListener(MouseEvent.CLICK, onClickDie);
			die.setReadyToClick(true);
			if (game.numPlayers)
				tag.setText("Επόμενος παίκτης");
			else
				tag.setText("ΤΕΛΟΣ ΠΑΙΧΝΙΔΙΟΥ!\n Δείτε την τελική κατάταξη.");
			currentPlayer.clearCurrentPath();

			clickNext = true;
		}

	} // end class

} // end package
