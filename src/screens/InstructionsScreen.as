package screens
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.filters.DropShadowFilter;

	import general.Screen;
	import general.MenuButton;

	public class InstructionsScreen extends Screen
	{
		[Embed(source="/assets/background_general.jpg")]
		private var Background:Class;
		
		private var buttonBack:MenuButton;
		private var infoFormat:TextFormat;
		private var info:TextField;
		private var backgroundText:Sprite;
		private var dropShadowFilter:DropShadowFilter;
		private var container:Sprite;
		private var containerMask:Sprite;
		
		[Embed(source="/assets/arrow.png")]
		private var ArrowBitmap:Class
		[Embed(source="/assets/instructions/border.jpg")]
		private var BorderBitmap:Class;
		[Embed(source="/assets/instructions/passenger.jpg")]
		private var PassengerBitmap:Class;
		[Embed(source="/assets/instructions/redLight.jpg")]
		private var RedLightBitmap:Class;
		[Embed(source="/assets/instructions/stop.jpg")]
		private var StopBitmap:Class;
		[Embed(source="/assets/instructions/policeman.jpg")]
		private var PolicemanBitmap:Class;
		[Embed(source="/assets/instructions/prohibited.jpg")]
		private var ProhibitedBitmap:Class;
		[Embed(source="/assets/instructions/order.jpg")]
		private var OrderBitmap:Class;
		[Embed(source="/assets/instructions/pedestrian.jpg")]
		private var PedestrianBitmap:Class;
		
		private var arrowUpBitmap:Bitmap;
		private var arrowDownBitmap:Bitmap;
		private var arrowUp:Sprite;
		private var arrowDown:Sprite;
		
		private var border:DisplayObject;
		private var redLight:DisplayObject;
		private var stop:DisplayObject;
		private var policeman:DisplayObject;
		private var prohibited:DisplayObject;
		private var order:DisplayObject;
		private var pedestrian:DisplayObject;
		private var passenger:DisplayObject;
	
		public function InstructionsScreen():void
		{
			super();
		} // end constructor
		
		override protected function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			var background:DisplayObject = new Background();
			var output:String = "";
			output += "<u>Σκοπός του παιχνιδιού</u>";
			output += "<br />Σκοπός του παιχνιδιού είναι ο παίκτης να φτάσει στο χρωματιστό τετράγωνο δίπλα από το σπίτι που βρίσκεται ο επιβάτης, να τον παραλάβει και στη συνέχεια να τον μεταφέρει πίσω στο τετράγωνο έναρξης που αντιστοιχεί στο χρώμα του παίκτη."
			
			output += "<br /><br /><u>Εξέλιξη του παιχνιδιού</u>";
			output += "<br />Πρώτος ξεκινάει ο μπλε παίκτης, ακολουθεί ο κίτρινος, ο πράσινος και τελευταίος παίζει ο κόκκινος. Ο παίκτης κάνει κλικ στο ζάρι και μετακινεί του αυτοκίνητό του αντίστοιχες θέσεις πάνω στην πίστα. Για τη μετακίνηση, πρέπει να κάνει κλικ στο τετράγωνο στο οποίο βρίσκεται το αυτοκίνητό του, και κρατώντας πατημένο το πλήκτρο του ποντικιού, να σύρει το ποντίκι ώστε να δημιουργήσει τη διαδρομή που θέλει να ακολουθήσει. Στο τετράγωνο όπου θα εμφανιστεί ένας κύκλος με χρώμα πορτοκαλί, μπορεί να αφήσει ελεύθερο το πλήκτρο του ποντικιού ώστε να μετακινηθεί το αυτοκίνητο στον αντίστοιχο προορισμό.";
			
			output += "<br /><br />Ο παίκτης μπορεί να βρεθεί στα εξής τετράγωνα:";
			output += "<br /><br /><u>Κόκκινο φανάρι.</u> Σε αυτή την περίπτωση, ο παίκτης σταματάει αναγκαστικά σ' αυτό το τετράγωνο, ανεξάρτητα από τον αριθμό που έφερε στο ζάρι. Αν ο παίκτης έχει στην κατοχή του πλακίδιο πράσινου φαναριού, το φανάρι γίνεται πράσινο και ο παίκτης συνεχίζει την κίνησή του. Αν δεν έχει αυτό το πλακίδιο, τότε χάνει τη σειρά του και παίζει ο επόμενος παίκτης. Όταν έρθει ξανά η σειρά του, έχει το δικαίωμα να ρίξει 2 φορές ζάρι μέχρι να φέρει 4, 5 ή 6 για να μπορέσει να προχωρήσει αντίστοιχες θέσεις πάνω στην πίστα. Αν δε φέρει την επιθυμητή ζαριά καμία από τις 2 φορές, τότε χάνει τη σειρά του και παίζει ο επόμενος παίκτης. Την επόμενη φορά θα ακολουθήσει την ίδια διαδικασία μέχρι να φέρει 4, 5 ή 6.";
			
			output += "<br /><br /><u>Πινακίδα STOP.</u> Και σε αυτή την περίπτωση, ο παίκτης σταματάει αναγκαστικά σ' αυτό το τετράγωνο, ανεξάρτητα από τον αριθμό που έφερε στο ζάρι. Σε περίπτωση που ο παίκτης έχει πλακίδιο διέλευσης, το χρησιμοποιεί και συνεχίζει την κίνησή του. Αν δεν έχει αυτό το πλακίδιο, χάνει τη σειρά του και παίζει ο επόμενος παίκτης. Όταν έρθει πάλι η σειρά του, θα μπορεί να ρίξει κανονικά το ζάρι και να μετακινήσει το αυτοκίνητό του αντίστοιχες θέσεις.";
			
			output += "<br /><br /><u>Διάβαση πεζών.</u> Ο παίκτης σταματάει σε αυτό το τετράγωνο αν με το ζάρι που θα φέρει, μετακινήσει το αυτοκίνητό του ακριβώς πάνω σε αυτό. Σ' αυτήν την περίπτωση, μετακινείται μία θέση προς τα πίσω για να μην πατάει τη διάβαση πεζών.";
			
			output += "<br /><br /><u>Τροχονόμος.</u> Σ' αυτήν την περίπτωση, ο παίκτης σταματάει αναγκαστικά σ' αυτό το τετράγωνο ανεξάρτητα από τον αριθμό που έφερε στο ζάρι. Αν ο παίκτης έχει στην κατοχή του πλακίδιο τροχονόμου, τότε το χρησιμοποιεί και συνεχίζει την κίνησή του. Αν δεν έχει αυτό το πλακίδιο, χάνει τη σειρά του και παίζει ο επόμενος παίκτης. Όταν έρθει η σειρά του, έχει το δικαίωμα να ρίξει 2 φορές ζάρι μέχρι να φέρει 1, 2 ή 3 για να μπορέσει να προχωρήσει. Αν δε φέρει την επιθυμητή ζαριά καμία από τις 2 φορές, χάνει τη σειρά του και παίζει ο επόμενος παίκτης. Την επόμενη φορά, θα ακολουθήσει την ίδια διαδικασία μέχρι να φέρει 1, 2 ή 3.";
			
			output += "<br /><br /><u>Πινακίδα απαγορεύεται η διέλευση.</u> Σ' αυτή την περίπτωση, ο παίκτης σταματάει αναγκαστικά σ' αυτό το τετράγωνο, ανεξάρτητα από τον αριθμό που έφερε στο ζάρι. Αν ο παίκτης έχει στην κατοχή του πλακίδιο διέλευσης, το χρησιμοποιεί και συνεχίζει την κίνησή του. Αν δεν έχει αυτό το πλακίδιο, χάνει τη σειρά του και παίζει ο επόμενος παίκτης. Όταν έρθει ξανά η σειρά του, ο παίκτης μπορεί κανονικά να ρίξει ζάρι και να μετακινήσει το αυτοκίνητό του αλλά δεν μπορεί να προχωρήσει κάτα μήκος του δρόμου που βρίσκεται η πινακίδα. Θα πρέπει να κάνει αναστροφή και να ακολουθήσει έναν εναλλακτικό δρόμο.";
			
			output += "<br /><br /><u>Διαταγή.</u> Ο παίκτης σταματάει σε αυτό το τετράγωνο αν μετά το ζάρι που θα φέρει, μετακινήσει το αυτοκίνητό του ακριβώς στο τετράγωνο αυτό. Τότε ο παίκτης λαμβάνει μία διαταγή και παίρνει το πλακίδιο που αυτή του υποδηλώνει.";
			
			output += "<br /><br /><u>Νικητής του παιχνιδιού.</u>";
			output += "<br />Νικητής του παιχνιδιού ανακηρύσσεται ο παίκτης που πρώτος θα μεταφέρει τον επιβάτη του πίσω στο τετράγωνο έναρξης που αντιστοιχεί στο χρώμα του παίκτη.";
			
			output += "<br /><br /><u>Παρατηρήσεις.</u>";
			output += "<br />Ο παίκτης που κινείται προς το τετράγωνο του επιβάτη ή προς το τετράγωνο της έναρξης, δεν είναι απαραίτητο να φέρει ακριβώς τη ζαριά που απαιτείται για να φτάσει στο τετράγωνο αυτό. Σε περίπτωση που φέρει μεγαλύτερη ζαριά, σταματάει στο τετράγωνο και παίρνει τον επιβάτη ή αφήνει τον επιβάτη αντίστοιχα."
			
			buttonBack = new MenuButton("ΠΙΣΩ");
			buttonBack.backgroundColor = buttonBack.RED;
			buttonBack.x = (game.WIDTH - buttonBack.width) / 2;
			buttonBack.y = game.HEIGHT - buttonBack.height - 20;
			
			container = new Sprite();

			backgroundText = new Sprite();
			backgroundText.graphics.beginFill(0x8aa0aa);
			backgroundText.graphics.drawRect(0, 0, game.WIDTH - 100, game.HEIGHT / 2 + 90);
			backgroundText.graphics.endFill();
			backgroundText.x = game.WIDTH / 2 - backgroundText.width / 2;
			backgroundText.y = 50;
			
			containerMask = new Sprite();
			containerMask.graphics.beginFill(0x666666);
			containerMask.graphics.drawRect(0, 0, backgroundText.width - 20, backgroundText.height - 20);
			containerMask.graphics.endFill();
			containerMask.x = backgroundText.x + 10;
			containerMask.y = backgroundText.y + 10;
			container.mask = containerMask;
			
			dropShadowFilter = new DropShadowFilter();
			backgroundText.filters = [dropShadowFilter];
			
			arrowUpBitmap = new ArrowBitmap() as Bitmap;
			arrowUp = new Sprite();
			arrowUp.addChild(arrowUpBitmap);
			arrowUp.x = backgroundText.x + backgroundText.width - arrowUp.width - 10;
			arrowUp.y = backgroundText.y + 20;
			
			arrowDownBitmap = new ArrowBitmap() as Bitmap;
			arrowDownBitmap.scaleY *= -1;
			arrowDown = new Sprite();
			arrowDown.addChild(arrowDownBitmap);
			arrowDown.x = arrowUp.x;
			arrowDown.y = backgroundText.y + backgroundText.height - 20;
			
			infoFormat = new TextFormat("customFont", 18, 0xFFFFFF);
			infoFormat.align = "justify";
			
			info = new TextField();
			info.embedFonts = true;
			//info.border = true;
			info.selectable = false;
			info.multiline = true;
			info.wordWrap = true;
			info.setTextFormat(infoFormat);
			info.defaultTextFormat = infoFormat;
			info.width = backgroundText.width - 130 - arrowUp.width - 20;
			info.x = 10;
			info.y = 10;
			info.htmlText = output;
			info.height = info.textHeight + 4;
			
			redLight = new RedLightBitmap() as DisplayObject;
			redLight.x = info.x + info.width + 10;
			redLight.y = 503;
			
			border = new BorderBitmap() as DisplayObject;
			border.x = redLight.x;
			border.y = 34;
			
			passenger = new PassengerBitmap() as DisplayObject;
			passenger.x = redLight.x;
			passenger.y = border.y + border.height + 10;
			
			stop = new StopBitmap() as DisplayObject;
			stop.x = redLight.x;
			stop.y = 789;
			
			pedestrian = new PedestrianBitmap() as DisplayObject;
			pedestrian.x = redLight.x;
			pedestrian.y = 989;
			
			policeman = new PolicemanBitmap() as DisplayObject;
			policeman.x = redLight.x;
			policeman.y = 1099;
			
			prohibited = new ProhibitedBitmap() as DisplayObject;
			prohibited.x = redLight.x;
			prohibited.y = 1363;
			
			order = new OrderBitmap() as DisplayObject;
			order.x = redLight.x;
			order.y = 1606;
			
			addChild(background);
			addChild(buttonBack);
			
			container.addChild(info);
			container.addChild(border);
			container.addChild(passenger);
			container.addChild(redLight);
			container.addChild(stop);
			container.addChild(pedestrian);
			container.addChild(policeman);
			container.addChild(prohibited);
			container.addChild(order);
			backgroundText.addChild(container);
			
			addChild(backgroundText);
			addChild(arrowUp);
			addChild(arrowDown);
			addChild(containerMask);
			
			
			showMiniplay();
			
			buttonBack.addEventListener(MouseEvent.CLICK, onClickBack);
			
			arrowDown.addEventListener(MouseEvent.MOUSE_OVER, startScrolling);
			arrowUp.addEventListener(MouseEvent.MOUSE_OVER, startScrolling);
			
			arrowDown.addEventListener(MouseEvent.MOUSE_OUT, stopScrolling);
			arrowUp.addEventListener(MouseEvent.MOUSE_OUT, stopScrolling);
		}
		
		private function startScrolling(e:MouseEvent):void
		{
			var target:Sprite = e.target as Sprite;
				
			if (target == arrowDown)
				addEventListener(Event.ENTER_FRAME, scrollUp);
			else if (target == arrowUp)
				addEventListener(Event.ENTER_FRAME, scrollDown);
		}
		
		private function stopScrolling(e:MouseEvent):void
		{
			var target:Sprite = e.target as Sprite;

			if (target == arrowDown)
			{
				if (hasEventListener(Event.ENTER_FRAME))
					removeEventListener(Event.ENTER_FRAME, scrollUp);
			}
			else if (target == arrowUp)
			{
				if (hasEventListener(Event.ENTER_FRAME))
					removeEventListener(Event.ENTER_FRAME, scrollDown);
			}
		}
		
		private function scrollUp(e:Event):void
		{
			if ((container.y + container.height) > containerMask.height)
				container.y -= 16;
		}
		
		private function scrollDown(e:Event):void
		{
			if (container.y < 0)
				container.y += 16;
		}
		
		private function onClickBack(e:MouseEvent):void
		{
			buttonBack.removeEventListener(MouseEvent.CLICK, onClickBack);
			
			var startScreen:StartScreen = new StartScreen();
			startScreen.create();
		}
	
	} // end class

} // end package
