package classes
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.filters.DropShadowFilter;
	import flash.events.MouseEvent;
	import general.Game;

	public class Order extends Sprite
	{

		public const GREEN_LIGHT:uint = 1; // 6
		public const TRANSIT:uint = 2; // 10
		public const POLICEMAN:uint = 3; // 4
		
		private var _game:Game = Game.getInstance();

		private var _type:uint = 0;
		private var _info:String;

		private static var instructions:Array =
			[
				["Δεν επιτρέπεται ποτέ να περνάμε γραμμές τρένων που δεν έχουν διάβαση. Είναι πολύ επικίνδυνο για τη ζωή μας να περάσουμε αφού δεν είναι εύκολο να σταματήσει έγκαιρα ένα τρένο όταν κινείται!"],
				["Όταν κυκλοφορούμε πεζοί με κάποιο φίλο μας και υπάρχει στενό πεζοδρόμιο, βαδίζουμε ο ένας πίσω από τον άλλο. Με αυτό τον τρόπο δεν υπάρχει περίπτωση κάποιος να βγει στο δρόμο!"],
				["Όταν το φανάρι δε λειτουργεί ή υπάρχει έντονο κυκλοφοριακό πρόβλημα, επεμβαίνει ο τροχονόμος. Τότε, πεζοί και οδηγοί, δεν υπακούμε στα φανάρια αλλά προτεραιότητα έχουν οι οδηγίες του τροχονόμου."],
				["Όταν δεν υπάρχουν διαβάσεις πεζών ή υπόγειες διαβάσεις, καλό είναι να περνάμε απέναντι από σημείο του δρόμου με καλή ορατότητα προς όλες τις κατευθυσεις."],
				["Στις φυλασσόμενες διαβάσεις, όταν περνάει τρένο, στεκόμαστε στην άκρη του δρόμου μπροστά από τις μπάρες στο σημείο που σταματούν και τα αυτοκίνητα. Όταν σηκωθούν οι μπάρες, διασχίζουμε τις γραμμές."],
				["Ο οδηγός δεν πρέπει να μιλάει ή να στέλνει μηνύματα από το κινητό του τηλέφωνο. Αν συμβεί αυτό, ζητήστε του είτε να κλείσει το τηλέφωνο είτε να σταματήσει την οδήγηση για να μιλήσει στο κινητό του."],
				["Όταν το αυτοκίνητο σταματά, ποτέ δε βγαίνουμε από την πλευρά που είναι ο δρόμος αλλά μόνο από την πλευρά που υπάρχει πεζοδρόμιο. Στο δρόμο μπορεί να κινείται άλλο αυτοκίνητο."],
				["Δεν γκρινιάζουμε και δε φωνάζουμε ποτέ όταν είμαστε στο αυτοκίνητο γιατί μπορεί να αποσπάσουμε την προσοχή του οδηγού! Ο οδηγός πρέπει να προσέχει πάντα στο δρόμο!"],
				["Όταν, μικροί και μεγάλοι, κάνουμε ποδήλατο, πρέπει να φοράμε κράνος! Το κράνος προστατεύει το κεφάλι μας, μέρος του σώματός μας με σημαντικά όργανα όπως π.χ. ο εγκέφαλος, από σοβαρά χτυπήματα!"],
				["Όταν υπάρχει κατοικίδιο στο αυτοκίνητο, πρέπει οπωσδήποτε να είναι εκπαιδευμένο να παραμένει ήρεμο κατά τη διάρκεια του ταξιδιού ενώ πρέπει κι αυτό να φοράει ζώνη ασφαλείας."],
				["Όταν υπάρχει πεζοδρόμιο, πρέπει να βαδίζουμε μέσα στα όριά του χωρίς να βγαίνουμε στο δρόμο. Αν βγούμε στο δρόμο, μπορεί να συμβεί ατύχημα με όχημα που περνάει και να χτυπήσουμε!"],
				["Όταν δεν υπάρχει πεζοδρόμιο, βαδίζουμε αντίθετα από την κατεύθυνση των αυτοκινήτων. Με αυτό τον τρόπο, βλέπουμε έγκαιρα τα οχήματα που κινούνται προς το μέρος μας και έτσι μπορούμε να προφυλαχτούμε."],
				["Αν κυκλοφορούμε στο δρόμο με ένα μικρότερό μας, οφείλουμε να τον κρατάμε πάντα από το χέρι προσέχοντας να βαδίζει προς το μέρος του πεζοδρομίου. Έτσι τον προφυλάσσουμε από πιθανό ατύχημα."],
				["Είναι σημαντικό να φοράμε ανοιχτόχρωμα ή αντανακλαστικά ρούχα για να είμαστε ορατοί στους οδηγούς, ειδικά το βράδυ που η ορατότητα είναι πιο περιορισμένη."],
				["Το φανάρι έχει δύο ανθρωπάκια, ένα κόκκινο που λέγεται Σταμάτης και ένα πράσινο που λέγεται Γρηγόρης. Όταν εμφανιστεί ο Σταμάτης, δεν περνάμε ποτέ το δρόμο! Περνάμε απέναντι όταν εμφανιστεί ο Γρηγόρης!"],
				["Όταν είμαστε πεζοί, περνάμε πάντα το δρόμο από το φανάρι. Όταν δεν υπάρχει φανάρι, περνάμε το δρόμο από τη διάβαση πεζών. Δε διασχίζουμε το δρόμο αν δε βεβαιωθούμε ότι τα οχήματα έχουν σταματήσει."],
				["Στους λεωφορειόδρομους προσέχουμε πολύ γιατί σ' αυτούς επιτρέπονται αποκλειστικά λεωφορεία, τρόλεϊ ή άλλα μέσα μαζικής μεταφοράς ενώ πολλές φορές αυτά κινούνται αντίθετα από άλλα οχήματα."],
				["Ο οδηγός οφείλει να παραχωρεί προτεραιότητα αν συναντάει αστυνομικό αυτοκίνητο, ασθενοφόρο ή πυροσβεστικό όχημα που ακούγεται η σειρήνα του. Αν δεν το κάνει, ζητήστε του ευγενικά να παραχωρήσει προτεραιότητα."],
				["Όταν βλέπουμε σχολικό τροχονόμο, μπορούμε να του ζητήσουμε να μας περάσει απέναντι γιατί έχει το δικαίωμα να σταματήσει για λίγα δευτερόλεπτα τη διέλευση των οχημάτων στο δρόμο."]
			] 

		private var tf:TextField;
		private var textFormat:TextFormat;
		private var lightbox:Sprite;
		private var background:Sprite;
		private var buttonBackground:Sprite;
		private var buttonFormat:TextFormat;
		private var buttonText:TextField;

		public function Order(orderType:uint, orderInfo:String)
		{
			type = orderType;
			info = orderInfo;

			background = new Sprite();

			textFormat = new TextFormat("customFont", 18);
			textFormat.align = "justify";
			textFormat.color = 0xFFFFFF;
			
			tf = new TextField();
			tf.selectable = false;
			//tf.border = true;
			tf.embedFonts = true;
			tf.setTextFormat(textFormat);
			tf.defaultTextFormat = textFormat;
			tf.mouseEnabled = false;
			tf.multiline = true;
			tf.wordWrap = true;
			tf.width = 500 - 20;
			tf.x = 10;
			tf.y = 10;
			
			buttonBackground = new Sprite();
			buttonBackground.graphics.beginFill(0xb7c2c7);
			buttonBackground.graphics.drawRect(0, 0, 120, 40);
			buttonBackground.graphics.endFill();
			buttonBackground.filters = [new DropShadowFilter()];
			
			buttonFormat = new TextFormat("customFont", 20);
			buttonFormat.color = 0x000000;
			buttonFormat.align = "center";
			
			buttonText = new TextField();
			buttonText.selectable = false;
			buttonText.embedFonts = true;
			buttonText.setTextFormat(buttonFormat);
			buttonText.defaultTextFormat = buttonFormat;
			buttonText.text = "ΕΝΤΑΞΕΙ";
			buttonText.mouseEnabled = false;
			buttonText.width = buttonBackground.width;
			buttonText.height = buttonBackground.height;
			buttonText.y = (buttonText.height - 4 - buttonText.textHeight) / 2;
			
			lightbox = new Sprite();
			lightbox.graphics.beginFill(0x000000);
			lightbox.graphics.drawRect(0, 0, game.WIDTH, game.HEIGHT);
			lightbox.graphics.endFill();
			lightbox.alpha = 0.4;

			addChild(lightbox);
			background.addChild(tf);
			buttonBackground.addChild(buttonText);
			background.addChild(buttonBackground);
			
			addChild(background);
		} // end constructor
		
		public function getInstruction():String
		{
			var output:String = '';
			var index:uint = Math.round(0 + (instructions.length - 1) * Math.random());
			output = instructions[index];
			
			return output;
		}
		
		public function showInstruction(txt:String = ""):void
		{
			var output:String = "";

			if (txt != "")
				output += "<u>Διαταγή</u>\n" + txt;
			output += "\n\n<u>Χρήσιμη Πληροφορία</u>\n";
			output += '"' + getInstruction() + '"';
			
			tf.htmlText = output;
			tf.height = tf.textHeight + 4;
			
			background.graphics.clear();
			background.graphics.beginFill(0x8aa0aa);
			background.graphics.drawRect(0, 0, 500, tf.height + 20 + buttonBackground.height + 20);
			background.graphics.endFill();
			
			buttonBackground.x = (background.width - buttonBackground.width) / 2;
			buttonBackground.y = background.height - buttonBackground.height - 10;
			
			var dropShadowFilter:DropShadowFilter = new DropShadowFilter();
			background.filters = [dropShadowFilter];
		
			background.x = (lightbox.width - background.width) / 2;
			background.y = (lightbox.height - background.height) / 2;
			game.root.addChild(this);
			
			buttonBackground.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(e:MouseEvent):void
		{
			buttonBackground.removeEventListener(MouseEvent.CLICK, onClick);
			game.root.removeChild(this);
		}

		// Getters and Setters
		public function get type():uint
		{
			return this._type;
		}
		
		public function set type(value:uint):void
		{
			this._type = value;
		}

		public function get info():String
		{
			return this._info;
		}
		
		public function set info(value:String):void
		{
			this._info = value;
		}
		
		public function get game():Game
		{
			return this._game;
		}
				
		public function set game(value:Game):void
		{
			this._game = value;
		}

	} // end class

} // end package
