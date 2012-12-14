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
		
		
		private static const RESSOURCE:int 		= 1;
		private static const BOT_ALLIE:int 		= 2;
		private static const BOT_ENNEMI:int 	= 3;
		private static const BASE_ALLIE:int 	= 4;
		private static const BASE_ENNEMIE:int 	= 5;
		
		private static const IS_PERCEPTED:int 	= 10;
		private static const IS_COLLIDED:int 	= 11;
		
		
		private var listeRessources:Array;
		
		private var listeAgentCollided:Array;
		private var listeAgentCollidedOrPercepted:Array;
		private var listeAgentCollidedType:Array;
		
		protected var updateTime:Number;
		
		public function BotGangnam(_type:AgentType) 
		{
			listeRessources 				= new Array ();
			systemeExpertGangnam 			= new ExpertSystem ();
			listeAgentCollided 				= new Array ();
			listeAgentCollidedOrPercepted 	= new Array ();
			listeAgentCollidedType			= new Array ();
			updateTime 	= 0;
			super(_type);
		}
		
		override public function Update() : void
		{
			Perception();
			Analyse();
			Action();
			Reinit();
		}
		
		
		/* ################################################################################################ */
		/* ############################################## FONCTIONS DE PERCEPTION ######################### */
		/* ################################################################################################ */
		
		
		public function Perception() : void {
			// On reset les faits
			systemeExpertGangnam.ResetFacts();
			
			// appel fonctions qui set les faits
			setFactCollisionPerception ();
			setFactConnaitRessources ();
			setFactPorteRessource ();
		}
		
		private function setFactCollisionPerception ():void
		{
			var indice:int = 0;
			for each (var agent:Agent in listeAgentCollided)
			{
				if (listeAgentCollidedOrPercepted[indice] == IS_COLLIDED) 
				{
					setFactCollision(listeAgentCollidedType[indice]);
				}
				// Perception
				else if (listeAgentCollidedOrPercepted[indice] == IS_PERCEPTED)
				{
					setFactPerception(listeAgentCollidedType[indice]);
				}
				indice++;
			}
		}
		
		private function setFactPorteRessource():void
		{
			if (HasResource())
			{
				trace("porte ressource");
				systemeExpertGangnam.SetFactValue(FactBase.porteRessource, true);
			}
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
		
		private function setFactCollision(_typeAgent:int):void
		{
			if (_typeAgent == RESSOURCE)
				systemeExpertGangnam.SetFactValue(FactBase.collisionneRessource, true);
			else if (_typeAgent == BASE_ALLIE)
				systemeExpertGangnam.SetFactValue(FactBase.collisionneBaseAlliee, true);
			else if (_typeAgent == BASE_ENNEMIE)
				systemeExpertGangnam.SetFactValue(FactBase.collisionneBaseEnnemie, true);
			else if (_typeAgent == BOT_ALLIE)
				systemeExpertGangnam.SetFactValue(FactBase.collisionneBotAllie, true);
			else if (_typeAgent == BOT_ENNEMI)
				systemeExpertGangnam.SetFactValue(FactBase.collisionneBotEnnemi, true);
			else
				trace ("setFactCollision : typeAgent incorrect");
		}
		
		private function setFactPerception(_typeAgent:int):void 
		{
			if (_typeAgent == RESSOURCE)
				systemeExpertGangnam.SetFactValue(FactBase.detecteRessource, true);
			else if (_typeAgent == BASE_ALLIE)
				systemeExpertGangnam.SetFactValue(FactBase.detecteBaseAlliee, true);
			else if (_typeAgent == BASE_ENNEMIE)
				systemeExpertGangnam.SetFactValue(FactBase.detecteBaseEnnemie, true);
			else if (_typeAgent == BOT_ALLIE)
				systemeExpertGangnam.SetFactValue(FactBase.detecteBotAllie, true);
			else if (_typeAgent == BOT_ENNEMI)
				systemeExpertGangnam.SetFactValue(FactBase.detecteBotEnnemi, true);
			else
				trace ("setFactPerception : typeAgent incorrect");
		}
		
		override public function onAgentCollide(_event:AgentCollideEvent) : void
		{
			var agentActuel:Agent = _event.GetAgent();
			
			// Collision 
			
			if (IsCollided(agentActuel)) 
			{
				listeAgentCollided.push(agentActuel);
				listeAgentCollidedOrPercepted.push(IS_COLLIDED);
				
			}
			// Perception
			else
			{
				listeAgentCollided.push(agentActuel);
				listeAgentCollidedOrPercepted.push(IS_PERCEPTED);
			}
			var typeAgent:int;
			if (agentActuel.GetType () == AgentType.AGENT_RESOURCE)
				typeAgent = RESSOURCE;
			else if (agentActuel.GetType () == AgentType.AGENT_BOT_HOME)
			{
				if (isBaseAlliee(agentActuel as BotHome))
					typeAgent = BASE_ALLIE;
				else if (!isBaseAlliee(agentActuel as BotHome))
					typeAgent = BASE_ENNEMIE;
			}
			else //if (agentActuel.GetType () == AgentType.AGENT_BOT)
			{
				if (isBotAllie(agentActuel as Bot))
					typeAgent = BOT_ALLIE;
				else if (!isBotAllie(agentActuel as Bot))
					typeAgent = BOT_ENNEMI;
			}
			listeAgentCollidedType.push(typeAgent);
			//trace ("probleme typeAgent : " + typeAgent);
			//if (!HasResource())
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

			//systemeExpertGangnam.InferBackward();
			
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
			trace("tableFaitsFinaux taille : " + tabFaitsFinaux.length);
			for each (var fait:Fact in tabFaitsFinaux)
			{
				trace ("fait : " + fait.GetLabel());
			}
			
			if (tabFaitsFinaux.length == 1)
				indice = 0;
			else
				// Comme la table de regle va de check/Fold à Raise, on prend la dernier indice, ce qui permet de choisir de suivre meme si une regle check/fold est vraie 
				//(normalement cette confrontation de regles est impossible, simple sécurité) 
				indice = tabFaitsFinaux.length - 1;
			if (tabFaitsFinaux.length > 0)
				trace("fait choisi : " + (tabFaitsFinaux[indice] as Fact).GetLabel());
			trace("#########################################");
			for each(var fait:Fact in tabFaitsFinaux)
			{
				if (fait == FactBase.vaExplorer) 	
				Explorer();
			else if (fait == FactBase.communiquerInfosRessource)
				communiqueInformations();
			else if (fait == FactBase.recupererInfosRessource)
			{
				recupereInformationsRessource();
				trace("recupereInformationsRessource");
			}
			else if (fait == FactBase.poseRessource)
			{
				trace("PoseRessource");
				PoseRessource();
			}
			else if (fait == FactBase.prendRessource)
			{
				trace("PrendRessource");
				PrendRessource();
			}
			else if (fait == FactBase.vaChercherRessourcePlusPres)
				seDirigeVersLaRessourcePlusPres();
			else if (fait == FactBase.vaChercherRessourceAvecLePlusDeCapacite)
				seDirigeVersLaRessourceAvecLePlusDeCapacite();
			else if (fait == FactBase.vaALaBaseAlliee)
				seDirigeVersLaBaseAlliee();
			else if (fait == FactBase.vaALaBaseEnnemieLaPlusPres)
				seDirigeVersLaBaseEnnemieLaPlusPres();
			else if (fait == FactBase.vaALaBaseEnnemieAvecLePlusDeCapacite)
				seDirigeVersLaBaseEnnemieAvecLePlusDeCapacite();
			}
				
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
		
		public function communiqueInformations () : void
		{
			//TODO
		}
		
		public function recupereInformationsRessource () : void
		{
			//TODO : tester fonction
			var indice:int = 0;
			var maRessource:Ressource;
			for each (var agent:Agent in listeAgentCollided)
			{
				if (listeAgentCollidedType[indice] == RESSOURCE || 
					listeAgentCollidedType[indice] == BASE_ALLIE || 
					listeAgentCollidedType[indice] == BASE_ENNEMIE)
				{
					maRessource = getRessourceByPointeur(agent);
					if (maRessource != null)
						modifieRessource(maRessource, agent);
					else
						ajouteNouvelleRessource(agent);
				}
				indice++;
			}
		}
		
		public function PoseRessource () : void
		{
			var indice:int = 0;
			for each (var agent:Agent in listeAgentCollided)
			{
				if (listeAgentCollidedOrPercepted[indice] == IS_COLLIDED)
				{
					if (agent.GetType () == AgentType.AGENT_RESOURCE)
					{
						(agent as Resource).IncreaseLife();
						SetResource(false);
					}
					else if (agent.GetType() == AgentType.AGENT_BOT_HOME)
					{
						(agent as BotHome).AddResource();
						SetResource(false);
					}
				}
				indice++;
			}
		}
		
		public function PrendRessource () : void
		{
			var indice:int = 0;
			for each (var agent:Agent in listeAgentCollided)
			{
				if (listeAgentCollidedOrPercepted[indice] == IS_COLLIDED)
				{
					if (agent.GetType () == AgentType.AGENT_RESOURCE)
					{
						(agent as Resource).DecreaseLife();
						SetResource(true);
					}
					else if (agent.GetType() == AgentType.AGENT_BOT_HOME)
					{
						(agent as BotHome).TakeResource();
						SetResource(true);
					}
				}
				indice++;
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
		
		public function Reinit ():void
		{
			while (listeAgentCollided.length > 0)
			{
				listeAgentCollided.pop();
				listeAgentCollidedOrPercepted.pop();
				listeAgentCollidedType.pop();
			}
		}
	}

}