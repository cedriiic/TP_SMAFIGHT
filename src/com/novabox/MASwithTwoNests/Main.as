package com.novabox.MASwithTwoNests
{
	import com.novabox.expertSystem.ExpertSystem;
	import com.novabox.expertSystem.Rule;
	import com.novabox.expertSystem.Fact;
	import fl.controls.Button;
	import fl.controls.CheckBox;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import fl.events.ComponentEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	/**
	 * Cognitive Multi-Agent System Example
	 * Part 2 : Two distinct termite nests
	 * (Termites collecting wood)
	 * 
	 * @author Ophir / Nova-box
	 * @version 1.0
	 */
	public class Main extends Sprite 
	{
		public static var world:World;
		
		protected var paused:Boolean;		
		protected var startFromHome:CheckBox;
		protected var homeGettingBigger:CheckBox;
		protected var pauseButton:Button;
		protected var restartButton:Button;
		protected var botCountField:TextField;
		public function Main():void 
		{		
			if (stage) 	InitializeUI(), init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			paused = false;
			if (pauseButton)
			{
				pauseButton.label = "Pause";
			}
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			world = new World();
			
			stage.addChild(world);
		
			if (isNaN(parseInt(botCountField.text)))
			{
				botCountField.text = "50";
			}
			
			World.BOT_COUNT =  parseInt(botCountField.text);
			
			world.Initialize();
			
			stage.addEventListener(Event.ENTER_FRAME, Update);
			
		}
		
		private function InitializeUI() : void
		{
			startFromHome = new CheckBox();
			startFromHome.label = "Start from home";
			startFromHome.width = 200;
			startFromHome.x = 680
			startFromHome.y = 0;
			startFromHome.selected = true;
			addChild(startFromHome);
			startFromHome.addEventListener(MouseEvent.CLICK, SwitchStartFromHome);
			
			homeGettingBigger = new CheckBox();
			homeGettingBigger.label = "Home expansion";
			homeGettingBigger.selected = true;
			homeGettingBigger.width = 200;
			homeGettingBigger.x = 680;
			homeGettingBigger.y = 20;
			addChild(homeGettingBigger);
			homeGettingBigger.addEventListener(MouseEvent.CLICK, SwitchHomeExpansion);
			
			pauseButton = new Button();
			pauseButton.label = "Pause";
			pauseButton.x = 680;
			pauseButton.y = 45;
			addChild(pauseButton);
			pauseButton.addEventListener(MouseEvent.CLICK, Pause);

			restartButton = new Button();
			restartButton.label = "Restart";
			restartButton.x = 680;
			restartButton.y = 70;
			addChild(restartButton);
			restartButton.addEventListener(MouseEvent.CLICK, Restart);
			
			var botCountLabel:TextField = new TextField();
			botCountLabel.autoSize = TextFieldAutoSize.LEFT;
			botCountLabel.x = 680;
			botCountLabel.y = 100;
			botCountLabel.text = "Bot count : ";
			botCountLabel.setTextFormat(new TextFormat("arial", 11));
			addChild(botCountLabel);
			
			botCountField = new TextField();
			botCountField.border = true;
			botCountField.type = TextFieldType.INPUT;
			botCountField.width = 40;
			botCountField.height = 20;
			//botCountField.label = "Bot count";
			botCountField.x = 738;
			botCountField.y = 100;
			botCountField.setTextFormat(new TextFormat("arial", 11));
			botCountField.text = "50";

			addChild(botCountField);

			
			for (var i:int = 0; i < World.ALL_TEAMS.length; i++)
			{
				var team:BotTeam = World.ALL_TEAMS[i];
				var teamCheckBox:CheckBox = new CheckBox();
				teamCheckBox.label = team.GetId();
				
				
				if (i < 2)
				{
					teamCheckBox.selected = true;
					if (!World.teams) World.teams = new Array();
					World.teams.push(team);
				}
				
				teamCheckBox.width = 200;
				teamCheckBox.x = 680
				teamCheckBox.y = 120 + i * 20;
				addChild(teamCheckBox);
				
				teamCheckBox.addEventListener(MouseEvent.CLICK, SwitchTeamSelected);
	
				this.graphics.beginFill(team.GetColor());
				this.graphics.drawRect(teamCheckBox.x - 10, teamCheckBox.y + 5 , 10 , 10);
				this.graphics.endFill();

			}
			
		}
		
		private function SwitchStartFromHome(_e:Event) : void
		{
			World.BOT_START_FROM_HOME = startFromHome.selected;
		}
		
		private function SwitchTeamSelected(_e:Event) : void
		{
			var checkBox:CheckBox = (_e.currentTarget as CheckBox);
			for each(var team:BotTeam in World.ALL_TEAMS)
			{
				if (team.GetId() == checkBox.label)
				{
					if (!checkBox.selected)
					{
						if (World.teams.indexOf(team) != -1)
						{
							World.teams.splice(World.teams.indexOf(team), 1);
						}
					}
					else
					{
						if (World.teams.indexOf(team) == -1)
						{
							World.teams.push(team);
						}
					}
				}
			}
		}
		
		private function SwitchHomeExpansion(_e:Event) : void
		{
			World.HOME_GETTING_BIGGER = homeGettingBigger.selected;
		}

		private function Pause(_e:Event) : void
		{
			paused = !paused;
			if (paused)
			{
				(_e.currentTarget as Button).label = "Play";
			}
			else
			{
				(_e.currentTarget as Button).label = "Pause";				
			}
		}
		
		private function Restart(_e:Event): void
		{
			stage.removeEventListener(Event.ENTER_FRAME, Update);
			while (stage.numChildren > 1)
			{
				stage.removeChildAt(1);
			}
			
			
			init(_e);
		}
		
		
		private function Update(_event:Event) : void
		{
			if (!paused)
			{
				TimeManager.timeManager.Update();
				world.Update();
			}
		}
	}
	
}