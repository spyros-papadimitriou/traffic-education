package screens
{
	import classes.Player;
	import classes.RankingPlayer;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import general.Screen;
	import general.MenuButton;
	
	public class ResultScreen extends Screen
	{
		[Embed(source="/assets/ranking_bg.jpg")]
		//[Embed(source="/assets/background_general.jpg")]
		private var BackgroundRanking:Class;
		
		private var buttonBack:MenuButton;
		
		public function ResultScreen()
		{
			super();
		} // end constructor
		
		override protected function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			var background:DisplayObject = new BackgroundRanking();
			addChild(background);
			
			buttonBack = new MenuButton("ΠΙΣΩ");
			buttonBack.backgroundColor = buttonBack.RED;
			buttonBack.x = 90;
			buttonBack.y = game.HEIGHT - buttonBack.height - 20;
			addChild(buttonBack);
			
			if (game.ranking.length)
			{
				var rankingPlayer:RankingPlayer;

				for (var i:uint = 0; i < game.ranking.length; i++)
				{
					rankingPlayer = new RankingPlayer(game.ranking[i], (i + 1));
					addChild(rankingPlayer);
				}
			}
			
			// For testing
			/*
			var player:Player = new Player();
			player.color = player.BLUE;
			game.ranking.push(player);
			var rankingBlue:RankingPlayer = new RankingPlayer(player, 1);
			
			player.color = player.YELLOW;
			game.ranking.push(player);
			var rankingYellow:RankingPlayer = new RankingPlayer(player, 2);
			
			player.color = player.GREEN;
			game.ranking.push(player);
			var rankingGreen:RankingPlayer = new RankingPlayer(player, 3);
			
			player.color = player.RED;
			game.ranking.push(player);
			var rankingRed:RankingPlayer = new RankingPlayer(player, 4);

			addChild(rankingBlue);
			addChild(rankingYellow);
			addChild(rankingRed);
			addChild(rankingGreen);
			*/
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
