package com.GangnamTeam 
{
	import com.GangnamTeam.expertSystemGangnam.ExpertSystem;
	import com.GangnamTeam.expertSystemGangnam.FactBase;
	import com.novabox.MASwithTwoNests.AgentCollideEvent;
	import com.novabox.MASwithTwoNests.AgentType;
	import com.novabox.MASwithTwoNests.Bot;
	import com.novabox.MASwithTwoNests.BotHome;
	import com.novabox.MASwithTwoNests.Resource;
	import com.novabox.MASwithTwoNests.Agent;
	import com.novabox.MASwithTwoNests.TimeManager;
	
	/**
	 * ...
	 * @author Charco
	 */
	public class BotGangnam extends Bot 
	{
		private var systemeExpertGangnam:ExpertSystem;
		
<<<<<<< HEAD
		//public static const poseRessource:int							= 1;
		//public static const prendRessource:int							= 2;
		//public static const vaChercherRessourcePlusPres:int				= 3;
		//public static const vaChercherRessourceAvecLePlusDeCapacite:int	= 4;
		//public static const vaExplorer:int								= 5;
		//public static const vaALaBaseAlliee:int							= 6;
		//public static const vaALaBaseEnnemieLaPlusPres:int				= 7;
		//public static const vaALaBaseEnnemieAvecLePlusDeCapacite:int	= 8;
=======
		public static const poseRessource:int							= 1;
		public static const prendRessource:int							= 2;
		public static const vaChercherRessourcePlusPres:int				= 3;
		public static const vaChercherRessourceAvecLePlusDeCapacite:int	= 4;
		public static const vaChercherRessourceLaPlusRecente:int		= 5;
		public static const vaExplorer:int								= 6;
		public static const vaALaBaseAlliee:int							= 7;
		public static const vaALaBaseEnnemieLaPlusPres:int				= 8;
		public static const vaALaBaseEnnemieAvecLePlusDeCapacite:int	= 9;
>>>>>>> 31099ed5dbb5cd15cc768a9e380d6bcc6186cf69
		
		private var listeRessources:Array;
	
		protected var updateTime:Number = 0;
		
		public function BotGangnam(_type:AgentType) 
		{
			listeRessources = new Array ();
			systemeExpertGangnam = new ExpertSystem ();
			updateTime = 0;
			super(_type);
		}
		
		override public function Update() : void
		{
			Perception();
			Analyse();
			Action();
		}		
		
		public function Perception() : void {
			// On reset les faits
			systemeExpertGangnam.ResetFacts();
			
			// appel fonctions qui set les faits
			
		}
		
		public function Analyse() : void {

			systemeExpertGangnam.InferForward();
			var inferedFacts:Array = systemeExpertGangnam.GetInferedFacts();
			//trace("Infered Facts:");

			systemeExpertGangnam.InferBackward();
			var factsToAsk:Array = systemeExpertGangnam.GetFactsToAsk();
			//trace("Facts to ask :");
		}
		
		public function Action() : void {
			// Recupere le ou les faits finaux (normalement un seul)
			var tabFaitsFinaux:Array = systemeExpertGangnam.GetInferedFacts();
			var indice:int;
			
			if (tabFaitsFinaux.length == 1)
				indice = 0;
			else
				// Comme la table de regle va de check/Fold à Raise, on prend la dernier indice, ce qui permet de choisir de suivre meme si une regle check/fold est vraie 
				//(normalement cette confrontation de regles est impossible, simple sécurité) 
				indice = tabFaitsFinaux.length - 1;

			//if (tabFaitsFinaux [indice] == FactBase.aucuneRessourceTrouvee) 	
				Explorer();
			//else if (tabFaitsFinaux [indice] == FactBase.EVENT_SUIVRE) 	
				//Call (_pokerTable.GetValueToCall());
			//else if (tabFaitsFinaux [indice] == FactBase.EVENT_RELANCER) 	
				// On effectue une relance aléatoire comprise entre 1 et 4 fois la big blind
				//Raise(Math.floor((Math.random() * 3) + 1) * _pokerTable.GetBigBlind(), _pokerTable.GetValueToCall());
			//else if (this.CanCheck(_pokerTable))
				//Check();
			//else
				//Fold ();
		}
		
		override public function onAgentCollide(_event:AgentCollideEvent) : void
		{
			var collidedAgent:Agent = _event.GetAgent();
			
			if (collidedAgent.GetType() == AgentType.AGENT_RESOURCE)
			{
				if (IsCollided(collidedAgent))
				{
					
					if (!HasResource())
					{
						(collidedAgent as Resource).DecreaseLife();
						SetResource(true);
					}
					else
					{
						(collidedAgent as Resource).IncreaseLife();
						SetResource(false);			
					}
					ChangeDirection();
				}
			}
			else if (collidedAgent.GetType() == AgentType.AGENT_BOT_HOME)
			{
				if (HasResource())
				{
					(collidedAgent as BotHome).AddResource();
					SetResource(false);
				}
			}
		}
		
		public function Explorer () : void
		{
			var elapsedTime:Number = TimeManager.timeManager.GetFrameDeltaTime();
			
			updateTime += elapsedTime;
				
			if (updateTime >=  directionChangeDelay)
			{
				ChangeDirection();
				updateTime = 0;
			}
			
			
			 targetPoint.x = x + direction.x * speed * elapsedTime / 1000 ;
			 targetPoint.y = y + direction.y * speed * elapsedTime / 1000;
		}
		
		public function getRessourceByPointeur (_maRessource:Ressource) : Ressource
		{
			for each (var ressource:Ressource in listeRessources)
			{
				if (_maRessource.getPointeurRessource() == ressource.getPointeurRessource())
					return ressource;
			}
			return null;
		}
	}

}