package com.GangnamTeam 
{
	import com.GangnamTeam.expertSystemGangnam.ExpertSystem;
	import com.GangnamTeam.expertSystemGangnam.Fact;
	import com.GangnamTeam.expertSystemGangnam.FactBase;
	import com.novabox.MASwithTwoNests.AgentCollideEvent;
	import com.novabox.MASwithTwoNests.AgentType;
	import com.novabox.MASwithTwoNests.Bot;
	import com.novabox.MASwithTwoNests.BotHome;
	import com.novabox.MASwithTwoNests.Resource;
	import com.novabox.MASwithTwoNests.Agent;
	import com.novabox.MASwithTwoNests.TimeManager;
	import com.novabox.MASwithTwoNests.World;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Charco
	 */
	public class BotGangnam extends Bot 
	{
		private var systemeExpertGangnam:ExpertSystem;
		
		
		
		
		private var listeRessources:Array;
		
		private var agentCollided:Agent;
		private var agentPercepted:Agent;
	
		protected var updateTime:Number;
		
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
		
		
		/* ################################################################################################ */
		/* ############################################## FONCTIONS DE PERCEPTION ######################### */
		/* ################################################################################################ */
		
		
		public function Perception() : void {
			// On reset les faits
			systemeExpertGangnam.ResetFacts();
			
			// appel fonctions qui set les faits
			setFactConnaitRessources ();
			setFactPorteRessource ();
		}
		
		private function setFactPorteRessource():void
		{
			if (HasResource())
				systemeExpertGangnam.SetFactValue(FactBase.porteRessource, true);
			else
				systemeExpertGangnam.SetFactValue(FactBase.nePortePasDeRessource, true);
		}
		
		private function setFactConnaitRessources () : void
		{
			//trace (isRessourcesConnuesDisponibles());
			if (isRessourcesConnuesDisponibles())
				systemeExpertGangnam.SetFactValue(FactBase.connaitDesRessources, true);
			else
				systemeExpertGangnam.SetFactValue(FactBase.neConnaitPasDeRessource, true);
		}
		
		override public function onAgentCollide(_event:AgentCollideEvent) : void
		{
			var agentActuel:Agent = _event.GetAgent();
			
			// Collision 
			if (IsCollided(agentActuel)) {
				setFactCollision(agentActuel);
			}
			// Perception
			else
			{
				setFactPerception(agentActuel);
			}
			//if (!HasResource())
		}
		
		private function setFactCollision(_collidedAgent:Agent):void 
		{
			agentCollided = _collidedAgent;
			if (_collidedAgent.GetType () == AgentType.AGENT_RESOURCE)
				systemeExpertGangnam.SetFactValue(FactBase.collisionneRessource, true);
			if (_collidedAgent.GetType () == AgentType.AGENT_BOT_HOME)
			{
				if (isBaseAlliee(_collidedAgent as BotHome))
					systemeExpertGangnam.SetFactValue(FactBase.collisionneBaseAlliee, true);
				else if (!isBaseAlliee(_collidedAgent as BotHome))
					systemeExpertGangnam.SetFactValue(FactBase.collisionneBaseEnnemie, true);
			}
			if (_collidedAgent.GetType () == AgentType.AGENT_BOT)
			{
				if (isBotAllie(_collidedAgent as Bot))
					systemeExpertGangnam.SetFactValue(FactBase.collisionneBotAllie, true);
				else if (!isBotAllie(_collidedAgent as Bot))
					systemeExpertGangnam.SetFactValue(FactBase.collisionneBotEnnemi, true);
			}
		}
		
		private function setFactPerception(_collidedAgent:Agent):void 
		{
			agentPercepted = _collidedAgent;
			if (_collidedAgent.GetType () == AgentType.AGENT_RESOURCE)
				systemeExpertGangnam.SetFactValue(FactBase.detecteRessource, true);
			else if (_collidedAgent.GetType () == AgentType.AGENT_BOT_HOME)
			{
				if (isBaseAlliee(_collidedAgent as BotHome))
					systemeExpertGangnam.SetFactValue(FactBase.detecteBaseAlliee, true);
				else if (!isBaseAlliee(_collidedAgent as BotHome))
					systemeExpertGangnam.SetFactValue(FactBase.detecteBaseEnnemie, true);
			}
			else if (_collidedAgent.GetType () == AgentType.AGENT_BOT)
			{
				if (isBotAllie(_collidedAgent as Bot))
					systemeExpertGangnam.SetFactValue(FactBase.detecteBotAllie, true);
				else if (!isBotAllie(_collidedAgent as Bot))
					systemeExpertGangnam.SetFactValue(FactBase.detecteBotEnnemi, true);
			}
		}
		
		/* ################################################################################################ */
		/* ############################################## FONCTIONS D'ANALYSE ############################# */
		/* ################################################################################################ */		
		
		
		public function Analyse() : void {

			systemeExpertGangnam.InferForward();
			
			//var inferedFacts:Array = systemeExpertGangnam.GetInferedFacts();
			//for each(var inferedFact:Fact in inferedFacts)
			//{
				//trace("        Infered Facts:" + inferedFact.GetLabel());
			//}

			systemeExpertGangnam.InferBackward();
			
			//var factsToAsk:Array = systemeExpertGangnam.GetFactsToAsk();
			//trace("Facts to ask :");
			//for each(var factToAsk:Fact in factsToAsk)
			//{
				//trace(factToAsk.GetLabel());
			//}
		}
		
		
		/* ################################################################################################ */
		/* ############################################## FONCTIONS D'ACTION ############################## */
		/* ################################################################################################ */		
		
		
		public function Action() : void {
			// Recupere le ou les faits finaux (normalement un seul)
			var tabFaitsFinaux:Array = systemeExpertGangnam.GetInferedFacts();
			var indice:int;
			//trace("tableFait taille : " + tabFaitsFinaux.length + " indice : " + (tabFaitsFinaux[0] as Fact).GetLabel());
			if (tabFaitsFinaux.length == 1)
				indice = 0;
			else
				// Comme la table de regle va de check/Fold à Raise, on prend la dernier indice, ce qui permet de choisir de suivre meme si une regle check/fold est vraie 
				//(normalement cette confrontation de regles est impossible, simple sécurité) 
				indice = tabFaitsFinaux.length - 1;

			if (tabFaitsFinaux [indice] == FactBase.vaExplorer) 	
				Explorer();
			else if (tabFaitsFinaux [indice] == FactBase.communiquerInfosRessource)
				communiqueInformations(agentPercepted);
			else if (tabFaitsFinaux [indice] == FactBase.recupererInfosRessource)
			{
				recupereInformationsRessource(agentPercepted);
				trace("recupereInformationsRessource : lengh = " + listeRessources.length);
			}
			else if (tabFaitsFinaux [indice] == FactBase.poseRessource)
			{
				trace("PoseRessource");
				PoseRessource(agentCollided);
			}
			else if (tabFaitsFinaux [indice] == FactBase.prendRessource)
			{
				trace("PrendRessource");
				PrendRessource(agentCollided);
			}
			else if (tabFaitsFinaux [indice] == FactBase.vaChercherRessourcePlusPres)
				seDirigeVersLaRessourcePlusPres();
			else if (tabFaitsFinaux [indice] == FactBase.vaChercherRessourceAvecLePlusDeCapacite)
				seDirigeVersLaRessourceAvecLePlusDeCapacite();
			else if (tabFaitsFinaux [indice] == FactBase.vaALaBaseAlliee)
				seDirigeVersLaBaseAlliee();
			else if (tabFaitsFinaux [indice] == FactBase.vaALaBaseEnnemieLaPlusPres)
				seDirigeVersLaBaseEnnemieLaPlusPres();
			else if (tabFaitsFinaux [indice] == FactBase.vaALaBaseEnnemieAvecLePlusDeCapacite)
				seDirigeVersLaBaseEnnemieAvecLePlusDeCapacite();
				
			//else if ()
			
				//Call (_pokerTable.GetValueToCall());
			//else if (tabFaitsFinaux [indice] == FactBase.EVENT_RELANCER) 	
				// On effectue une relance aléatoire comprise entre 1 et 4 fois la big blind
				//Raise(Math.floor((Math.random() * 3) + 1) * _pokerTable.GetBigBlind(), _pokerTable.GetValueToCall());
			//else if (this.CanCheck(_pokerTable))
				//Check();
			//else
				//Fold ();
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
			
			
			 targetPoint.x = x + direction.x * speed * elapsedTime / 1000;
			 targetPoint.y = y + direction.y * speed * elapsedTime / 1000;
		}
		
		public function communiqueInformations (_agent:Agent) : void
		{
			//TODO
		}
		
		public function recupereInformationsRessource (_agent:Agent) : void
		{
			//TODO : tester fonction
			var maRessource:Ressource = getRessourceByPointeur(_agent);
			if (maRessource != null)
			{
				modifieRessource(maRessource, _agent);
			}
			else
			{	
				ajouteNouvelleRessource(_agent);
			}
		}
		
		public function PoseRessource (_collidedAgent:Agent) : void
		{
			if (_collidedAgent.GetType () == AgentType.AGENT_RESOURCE)
			{
				(_collidedAgent as Resource).IncreaseLife();
				SetResource(false);
			}
			else if (_collidedAgent.GetType() == AgentType.AGENT_BOT_HOME)
			{
				(_collidedAgent as BotHome).AddResource();
				SetResource(false);
			}
		}
		
		public function PrendRessource (_collidedAgent:Agent) : void
		{
			if (_collidedAgent.GetType () == AgentType.AGENT_RESOURCE)
			{
				(_collidedAgent as Resource).DecreaseLife();
				SetResource(true);
			}
			else if (_collidedAgent.GetType() == AgentType.AGENT_BOT_HOME)
			{
				(_collidedAgent as BotHome).TakeResource();
				SetResource(true);
			}
		}
		
		public function seDirigeVersLaRessourcePlusPres () : void
		{
			//TODO
			//seDirigeVers(positionAgent);
		}
		
		public function seDirigeVersLaRessourceAvecLePlusDeCapacite () : void
		{
			//TODO
			//seDirigeVers(positionAgent);
		}
		
		public function seDirigeVersLaBaseAlliee () : void
		{
			//TODO
			//seDirigeVers(positionAgent);
		}
		
		public function seDirigeVersLaBaseEnnemieLaPlusPres () : void
		{
			//TODO
			//seDirigeVers(positionAgent);
		}
		
		public function seDirigeVersLaBaseEnnemieAvecLePlusDeCapacite () : void
		{
			//TODO
			//seDirigeVers(positionAgent);
		}
		
		
		/* ################################################################################################ */
		/* ############################################## FONCTIONS ANNEXES ############################### */
		/* ################################################################################################ */
		
		public function ajouteNouvelleRessource(_agent:Agent):void 
		{
			var type:int;
			var pointeur:Agent;
			var position:Point;
			var temps:Number;
			var capacite:int;
			
			type = getTypeDe(_agent);
			pointeur = _agent;
			position = _agent.GetTargetPoint();
			temps = TimeManager.timeManager.GetFrameDeltaTime();
			capacite = getCapaciteDe(_agent);
			
			listeRessources.push(new Ressource(temps, position, capacite, pointeur, type));
		}
		
		public function modifieRessource(_ressource:Ressource, _agent:Agent):void 
		{
			_ressource.setPosition(_agent.GetTargetPoint());
			_ressource.setTemps(TimeManager.timeManager.GetFrameDeltaTime());
			_ressource.setCapacite(getCapaciteDe(_agent));
		}
		
		public function getTypeDe(_agent:Agent):int 
		{
			if (_agent.GetType () == AgentType.AGENT_RESOURCE)
				return Ressource.RESSOURCE;
			else if (_agent.GetType () == AgentType.AGENT_BOT_HOME)
			{
				if (isBaseAlliee((_agent as BotHome)))
					return Ressource.BASE_ALLIEE;
				else
					return Ressource.BASE_ENNEMIE;
			}
			return 0;
		}
		
		public function getCapaciteDe(_agent:Agent):int 
		{
			if (_agent.GetType () == AgentType.AGENT_RESOURCE)
				return (_agent as Resource).GetLife();
			else if (_agent.GetType () == AgentType.AGENT_BOT_HOME)
				return (_agent as BotHome).GetResourceCount();
			return 0;
		}
		
		// TODO : vérifier que la fonction se comporte comme elle devrait ! (appel du Move ...)
		public function seDirigeVers(_positionAgent:Point) : void
		{
			direction = _positionAgent;
			
			Move();
		}
		
		// TODO : a verifier fonctionnement
		//public function isRessourceConnue (_pointeurAgent:Agent) : Boolean
		//{
			//for each (var ressource:Ressource in listeRessources)
			//{
				//if (ressource.getPointeurRessource() == _pointeurAgent)
					//return true;
			//}
			//return false;
		//}
		
		public function isRessourcesConnuesDisponibles () : Boolean
		{
			var nbRessources:int = 0;
			for each (var ressource:Ressource in listeRessources)
			{
				nbRessources = nbRessources + ressource.getCapacite();
			}
			return nbRessources > 0;
			
		}
		
		public function isBaseAlliee (_botHome:BotHome) : Boolean
		{
			return (_botHome.GetTeamId() == World.GANGNAM_TEAM.GetId());
		}
		
		public function isBotAllie (_bot:Bot) : Boolean
		{
			return (_bot.GetTeamId() == World.GANGNAM_TEAM.GetId());
		}
		
		
		public function getRessourceByPointeur (_agent:Agent) : Ressource
		{
			for each (var ressource:Ressource in listeRessources)
			{
				if (_agent == ressource.getPointeurRessource())
					return ressource;
			}
			return null;
		}
		
		
	}

}