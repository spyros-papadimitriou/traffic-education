package classes 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.utils.getTimer;
	
	import general.Game;
	
	public class Player extends Sprite
	{
		// Temp
		public var shape:Sprite;
		private var colorTransform:ColorTransform;
		public var tf:TextField;

		public const RED:uint = 1;
		public const BLUE:uint = 2;
		public const GREEN:uint = 3;
		public const YELLOW:uint = 4;
		
		public const BOY:uint = 1;
		public const GIRL:uint = 2;

		private var _game:Game = Game.getInstance();

		private var _tile:Tile; // Σε ποιο tile βρίσκεται
		private var _color:uint; // Τι χρώμα έχει
		private var _computer:Boolean = false; // Τον χειρίζεται άνθρωπος ή υπολογιστής
		private var _turn:uint = 0; // Σε ποια σειρά παίζει

		private var _greenLight:uint = 0; // Πόσα πλακίδια με πράσινο φανάρι έχει ο παίκτης
		private var _transit:uint = 0; // Πόσα πλακίδια δρόμου έχει ο παίκτης
		private var _policeman:uint = 0; // Πόσα πλακίδια τροχονόμου έχει ο παίκτης

		// Προσωρινές μεταβλητές που χρησιμοποιούνται στον υπολογισμό διαδρομής
		private var _tempGreenLight:uint = 0;
		private var _tempTransit:uint = 0;
		private var _tempPoliceman:uint = 0;

		private var _tries:uint = 0; // Πόσες προσπάθειες έχει όταν πέσει σε φανάρι ή τροχονόμο
		private var _currentPath:Array = new Array();
		private var _previousPath:Array = new Array(); // Η τελευταία διαδρομή που ακολούθησε (βοηθάει στην αναστροφή)
		private var _movingPath:Array = new Array(); // Η διαδρομή με την κίνηση
		private var _orders:Array = new Array(); // Αναφορά στο σύνολο των διαταγών

		private var _passenger:Boolean = false; // Αν έχει πάρει τον επιβάτη
		private var _finished:Boolean = false; // Αν έχει τερματίσει
		private var _homeTile:Tile; // Το σημείο αφετηρίας του παίκτη
		private var _passengerTile:Tile; // Το σημείο που πρέπει να παρκάρει ο παίκτης για να πάρει τον επιβάτη
		private var _standingTile:Tile; // Το σημείο όπου στέκεται ο επιβάτης
		private var _direction:uint = 2; // Προς ποια κατεύθυνση βλέπει
		private var _sex:uint = 1; // Το φύλο του παίκτη
		
		// Γραφικά
		[Embed(source="/assets/cars96.png")]
		private var TilesetCars:Class
		private var _tilesetImage:DisplayObject;
		private var _tilesetBitmapData:BitmapData;
		private var _canvasBitmapData:BitmapData;
		private var _canvasBitmap:Bitmap;
		
		public function Player() 
		{
		
			tilesetImage = new TilesetCars();
			tilesetBitmapData = new BitmapData(tilesetImage.width, tilesetImage.height, true, 0xFFFFFF);
			tilesetBitmapData.draw(tilesetImage);
			
			canvasBitmapData = new BitmapData(96, 96, true, 0xFFFFFF);
			canvasBitmap = new Bitmap(canvasBitmapData);
			
			tf = new TextField();
			tf.selectable = false;
			tf.multiline = true;
			tf.wordWrap = true;
			tf.x = -tf.width / 2;
			
			

			addChild(canvasBitmap);
			//addChild(tf);
			//addChild(shape);
		} // end constructor

		public function useItem(tile:Tile):void
		{
			var output:String = "";

			switch (tile.type)
			{
				case tile.RED_LIGHT:
					if (greenLight)
					{
						greenLight--;
						tile.type = tile.GREEN_LIGHT;
						output += "- Ο " + name + " χρησιμοποίησε πλακίδιο με πράσινο φανάρι.\n";
						trace ("Player " + color + " used a Green Light item on tile " + tile.num + ". Green Light items left: " + greenLight);
					}
				break;
				
				case tile.STOP:
					if (transit)
					{
						transit--;
						tile.type = tile.TRANSIT;
						output += "- Ο " + name + " χρησιμοποίησε πλακίδιο διέλευσης.\n";
						trace ("Player " + color + " used a Transit item on tile " + tile.num + ". Transit items left: " + transit);
					}
				break;
				
				case tile.POLICEMAN:
					if (policeman)
					{
						policeman--;
						tile.type = tile.POLICEMAN_ALLOWED;
						output += "- Ο " + name + " χρησιμοποίησε πλακίδιο τροχονόμου.\n";
						trace ("Player " + color + " used a Policeman item on tile " + tile.num + ". Policeman items left: " + policeman);
					}
				break;
				
				case tile.PROHIBITED:
					if (transit)
					{
						transit--;
						tile.type = tile.TRANSIT;
						output += "- Ο " + name + " χρησιμοποίησε πλακίδιο διέλευσης.\n";
						trace ("Player " + color + " used a Transit item on tile " + tile.num + ". Transit items left: " + transit);
					}
				break;
			} // end switch

			game.info.appendText(output);
		}

		public function removeTempItem(tile:Tile):void
		{
			if (tile.usedItem)
				return;

			switch (tile.type)
			{
				case tile.RED_LIGHT:
					if (tempGreenLight)
					{
						tempGreenLight--;
						tile.usedItem = true;
					}
				break;
				
				case tile.STOP:
					if (tempTransit)
					{
						tempTransit--;
						tile.usedItem = true;
					}
				break;
				
				case tile.POLICEMAN:
					if (tempPoliceman)
					{
						tempPoliceman--;
						tile.usedItem = true;
					}
				break;
				
				case tile.PROHIBITED:
					if (tempTransit)
					{
						tempTransit--;
						tile.usedItem = true;
					}
				break;
			} // end switch
		}
		
		public function addTempItem(tile:Tile):void
		{
			if (!tile.usedItem)
				return;

			tile.usedItem = false;
			switch (tile.type)
			{
				case tile.RED_LIGHT:
						tempGreenLight++;
				break;
				
				case tile.STOP:
					if (tempTransit < transit)
						tempTransit++;
				break;
				
				case tile.POLICEMAN:
					if (tempPoliceman < policeman)
						tempPoliceman++;
				break;
				
				case tile.PROHIBITED:
					if (tempTransit < transit)
						tempTransit++;
				break;
			} // end switch
		}

		// Τράβηξε μια τυχαία διαταγή
		private function retrieveOrder():void
		{
			if (!orders.length) { return; }

			var index:uint = Math.round(0 + (orders.length - 1) * Math.random());
			var temp:Array = orders.splice(index, 1);
			var order:Order = temp[0];
			var output:String = '';
			
			//output += 'ΤΟ ΗΞΕΡΕΣ ΟΤΙ...\n';
			//output += order.getInstruction();
			
			output += '\nΔΙΑΤΑΓΗ\n';

			switch (order.type)
			{
				case order.GREEN_LIGHT:
					greenLight++;
					output += "Ο " + name + " μόλις έλαβε διαταγή και κέρδισε ένα πλακίδιο με πράσινο φανάρι.\n\n";
					order.showInstruction("Ο " + name + " μόλις έλαβε διαταγή και κέρδισε ένα πλακίδιο με πράσινο φανάρι.");
					game.info.appendText(output);
					trace("Green Light item retrieved. Green Light items left: " + greenLight);
				break;

				case order.TRANSIT:
					transit++;
					output += "Ο " + name + " μόλις έλαβε διαταγή και κέρδισε ένα πλακίδιο διέλευσης.\n\n";
					order.showInstruction("Ο " + name + " μόλις έλαβε διαταγή και κέρδισε ένα πλακίδιο διέλευσης.");
					game.info.appendText(output);
					trace("Transit item retrieved. Transit items left: " + transit);
				break;

				case order.POLICEMAN:
					policeman++;
					output += "Ο " + name + " μόλις έλαβε διαταγή και κέρδισε ένα πλακίδιο με τροχονόμο.\n\n";
					order.showInstruction("Ο " + name + " μόλις έλαβε διαταγή και κέρδισε ένα πλακίδιο με τροχονόμο.");
					game.info.appendText(output);
					trace("Policeman item retrieved. Policeman items left: " + policeman);
				break;
			} // end switch

		}

		// Καθάρισε το τρέχον μονοπάτι
		public function clearCurrentPath():void
		{
			//dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
			var tile:Tile = new Tile();
			
			while (currentPath.length)
			{
				tile = currentPath.pop();
				tile.visited = false;
				tile.target = false;
				addTempItem(tile);
				tile.tf.text = tile.num.toString() + ": " + tile.type.toString();
				//tile.tf.text = player.tempGreenLight.toString();
			} // end while

		}
		
		public function getInfo():String
		{
			var output:String = '';
			output += name;
			
			output += "\n\nΠΛΑΚΙΔΙΑ";
			output += "\nΠράσινο φανάρι: " + greenLight.toString();
			output += "\nΤροχονόμος: " + policeman.toString();
			output += "\nΔιέλευση: " + transit.toString();
			
			output += "\n\nΣΤΟΧΟΣ\n";
			if (passenger)
				output += "Επιστροφή του επιβάτη στην αφετηρία.";
			else
				output += "Παραλαβή του επιβάτη από το σπιτάκι του.";

			if (tile.type == tile.RED_LIGHT)
				output += "\n\nΒρίσκεσαι σε κόκκινο φανάρι. Πρέπει να φέρεις 4, 5 ή 6 για να συνεχίσεις. Έχεις δικαίωμα να ρίξεις 2 φορές το ζάρι.";
			else if (tile.type == tile.POLICEMAN)
				output += "\n\nΒρίσκεσαι σε σημείο με τροχονόμο. Πρέπει να φέρεις 1, 2 ή 3 για να συνεχίσεις. Έχεις δικαίωμα να ρίξεις 2 φορές το ζάρι.";
			else if (tile.type == tile.PROHIBITED)
				output += "\n\nΒρίσκεσαι σε σημείο με απαγορευτική πινακίδα. Πρέπει να κάνεις αναστροφή.";
			
			output += "\n\n";
			
			return output;
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

		public function get tile():Tile
		{
			return this._tile;
		}
		
		public function set tile(value:Tile):void
		{
			if (this._tile != null)
				this._tile.removeChild(this);
				
			this._tile = value;
			//this.x = this._tile.width / 2;
			//this.y = this._tile.height / 2;
			x = 0;
			y = 0;
			this._tile.addChild(this);

			previousPath = new Array();

			if (!passenger && tile == passengerTile)
			{
				passenger = true;
				game.info.appendText("- Ο " + name + " μόλις πήρε τον επιβάτη του. Πρέπει να επιστρέψει στην αφετηρία του.\n");
				trace("Player " + color + " just got his passenger.");
				direction = direction;
				
				standingTile.map.addObject(standingTile, 15); // Το 15 πρέπει να παραμένει κενό!!!
			} // end if

			if (tile.type == tile.ORDER)
				retrieveOrder();
			else if (passenger && tile == homeTile)
			{
				game.numPlayers--;
				finished = true;
				game.ranking.push(this);
				game.info.appendText("- Ο " + name + " μόλις τερμάτισε στη θέση " + game.ranking.length + ".\n");
			}

			if (currentPath.length)
			{
				var path:String = "";
				for each (var t:Tile in currentPath)
				{
					//useItem(t); Αντικατάσταση (GameScreen.as συνάρτηση onEnterFrame)
					previousPath.push(t);
					path += t.num + " ";
				} // end for
			} // end if

			// Αν τον χειρίζεται ο υπολογιστής, κεντράρισε το χάρτη στο tile προορισμού
			if (computer)
				tile.map.goToTile(tile);

			//if (game.info != null)
				//game.info.appendText("- Ο παίχτης " + color + " σταμάτησε στο κουτάκι " + tile.num + ".\n");

			trace ("Ο παίχτης " + color + " ακολούθησε το μονοπάτι " + path + ".");
			trace ("Ο παίχτης " + color + " σταμάτησε στο κουτάκι " + tile.num + ".");
			if (finished)
				trace ("Ο παίχτης " + color + " μόλις τερμάτισε.");
			trace ("------------------------------------------------------------");

		}

		public function get color():uint
		{
			return this._color;
		}
		
		public function set color(value:uint):void
		{
			this._color = value;
			var tileSheetRow:uint = Math.floor((value - 1) / 4);
			var tileSheetCol:uint = value - 1 - tileSheetRow * 4;
			//canvasBitmapData.copyPixels(tilesetBitmapData, new Rectangle(tileSheetCol * 128, tileSheetRow * 128, 128, 128), new Point(0, 0), null, null, true);
		}

		public function get computer():Boolean
		{
			return this._computer;
		}
		
		public function set computer(value:Boolean):void
		{
			this._computer = value;
		}

		public function get turn():uint
		{
			return this._turn;
		}
		
		public function set turn(value:uint):void
		{
			this._turn = value;
		}

		public function get greenLight():uint
		{
			return this._greenLight;
		}
		
		public function set greenLight(value:uint):void
		{
			this._greenLight = value;
			tempGreenLight = value;
		}
		
		public function get transit():uint
		{
			return this._transit;
		}
		
		public function set transit(value:uint):void
		{
			this._transit = value;
			tempTransit = value;
		}
		
		public function get policeman():uint
		{
			return this._policeman;
		}
		
		public function set policeman(value:uint):void
		{
			this._policeman = value;
			tempPoliceman = value;
		}
		
		public function get tempGreenLight():uint
		{
			return this._tempGreenLight;
		}
		
		public function set tempGreenLight(value:uint):void
		{
			this._tempGreenLight = value;
		}
		
		public function get tempTransit():uint
		{
			return this._tempTransit;
		}
		
		public function set tempTransit(value:uint):void
		{
			this._tempTransit = value;
		}
		
		public function get tempPoliceman():uint
		{
			return this._tempPoliceman;
		}
		
		public function set tempPoliceman(value:uint):void
		{
			this._tempPoliceman = value;
		}
		
		public function get tries():uint
		{
			return this._tries;
		}
		
		public function set tries(value:uint):void
		{
			this._tries = value;
		}
		
		public function get currentPath():Array
		{
			return this._currentPath;
		}
		
		public function set currentPath(value:Array):void
		{
			this._currentPath = value;
			tf.text = "";
			for each (var t:Tile in value)
				tf.appendText(t.num.toString() + ", ");
		}

		public function get previousPath():Array
		{
			return this._previousPath;
		}
		
		public function set previousPath(value:Array):void
		{
			this._previousPath = value;
		}

		public function get orders():Array
		{
			return this._orders;
		}
		
		public function set orders(value:Array):void
		{
			this._orders = value;
		}

		public function get passenger():Boolean
		{
			return this._passenger;
		}
		
		public function set passenger(value:Boolean):void
		{
			this._passenger = value;
			tf.text = "Passenger";
		}

		public function get finished():Boolean
		{
			return this._finished;
		}
		
		public function set finished(value:Boolean):void
		{
			this._finished = value;
		}

		public function get homeTile():Tile
		{
			return this._homeTile;
		}
		
		public function set homeTile(value:Tile):void
		{
			this._homeTile = value;
			if (value.map != null)
				value.map.addObject(value, 15 + color);
		}

		public function get passengerTile():Tile
		{
			return this._passengerTile;
		}
		
		public function set passengerTile(value:Tile):void
		{
			this._passengerTile = value;
			if (value.map != null)
				value.map.addObject(value, 15 + color);
		}
		
		public function get standingTile():Tile
		{
			return this._standingTile;
		}
		
		public function set standingTile(value:Tile):void
		{
			this._standingTile = value;
			if (value.map != null)
				if (sex == BOY)
					value.map.addObject(value, 14);
				else
					value.map.addObject(value, 13);
		}
		
		public function get tilesetImage():DisplayObject 
		{
			return _tilesetImage;
		}
		
		public function set tilesetImage(value:DisplayObject):void 
		{
			_tilesetImage = value;
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
		
		public function get tilesetBitmapData():BitmapData 
		{
			return _tilesetBitmapData;
		}
		
		public function set tilesetBitmapData(value:BitmapData):void 
		{
			_tilesetBitmapData = value;
		}
		
		public function get movingPath():Array 
		{
			return _movingPath;
		}
		
		public function set movingPath(value:Array):void 
		{
			_movingPath = value;
		}
		
		public function get direction():uint 
		{
			return _direction;
		}
		
		public function set direction(value:uint):void 
		{
			_direction = value;
			canvasBitmapData.fillRect(new Rectangle(0, 0, 96, 96), 0xFF0000);
			
			var tileSheetRow:uint = (value - 1) % 4; // Καθορισμός κατεύθυνσης
			var tileSheetCol:uint = (color - 1) % 4; // Καθορισμός χρώματος
			
			if (sex == GIRL)
				tileSheetRow += 4;
			
			if (passenger)
				tileSheetCol += 4;
			
			canvasBitmapData.copyPixels(tilesetBitmapData, new Rectangle(tileSheetCol * 96, tileSheetRow * 96, 96, 96), new Point(0, 0), null, null, true);
		}
		
		public function get sex():uint 
		{
			return _sex;
		}
		
		public function set sex(value:uint):void 
		{
			_sex = value;
		}
		
	} // end class

} // end package
