package 
{
	import classes.Player;
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import general.Game;
	
	import screens.*;
	
	[Frame(factoryClass="general.Preloader")]
	[SWF(width="800", height="576", frameRate="30", backgroundColor="#FFFFFF")]
	public class TrafficEducation extends Sprite 
	{
		private var game:Game = Game.getInstance();
		private var menu:ContextMenu;
		
		private var menuTitle:ContextMenuItem;
		private var menuCredits:ContextMenuItem;
		private var menuProgramming:ContextMenuItem;
		private var menuSpyros:ContextMenuItem;
		private var menuGraphics:ContextMenuItem;
		private var menuRodo:ContextMenuItem;
		private var menuMiniplay:ContextMenuItem;
		
		public function TrafficEducation():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			menu = new ContextMenu();
			menu.hideBuiltInItems();
			
			menuTitle = new ContextMenuItem("Traffic Education");
			menuCredits = new ContextMenuItem("Credits");
			menuCredits.separatorBefore = true;
			menuCredits.enabled = false;
			menuProgramming = new ContextMenuItem("Programming");
			menuProgramming.separatorBefore = true;
			menuProgramming.enabled = false;
			menuSpyros = new ContextMenuItem("Spyros Papadimitriou");
			menuGraphics = new ContextMenuItem("Graphics");
			menuGraphics.enabled = false;
			menuRodo = new ContextMenuItem("Rodostamo");
			menuMiniplay = new ContextMenuItem("Copyright © 2013 Miniplay");
			menuMiniplay.separatorBefore = true;
			
			menu.customItems.push(menuTitle, menuCredits, menuProgramming, menuSpyros, menuGraphics, menuRodo, menuMiniplay);
			contextMenu = menu;
			
			menuSpyros.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onClick);
			menuRodo.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onClick);
			menuMiniplay.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onClick);
			
			game.stage = stage;
			game.root = this;
			
			var screen:StartScreen = new StartScreen();
			//var screen:SelectPlayerScreen = new SelectPlayerScreen();
			//var screen:SelectGenderScreen = new SelectGenderScreen();
			//var screen:GameScreen = new GameScreen();
			//var screen:ResultScreen = new ResultScreen();
			//var screen:InstructionsScreen = new InstructionsScreen();
			//var screen:CreditsScreen = new CreditsScreen();
			//addChild(screen);
			screen.create();
		}
		
		private function onClick(e:ContextMenuEvent):void
		{
			var url:String = '';
			
			switch (e.target)
			{
				case menuSpyros:
					url = "http://www.spyrospapadimitriou.gr";
				break;
				
				case menuRodo:
					url = "http://www.facebook.com/Rodostamohandmade";
				break;
				
				case menuMiniplay:
					url = "http://www.miniplay.gr/";
				break;
			}
			
			navigateToURL(new URLRequest(url), "_blank");
		}

	} // end constructor

} // end package
