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
		
		private var ressourceDeDestination:Ressource;
		
		private var isBaseConnue:Boolean;
		
		protected var updateTime:Number;
		
		public function BotGangnam(_type:AgentType) 
		{
			listeRessources 				= new Array ();
			systemeExpertGangnam 			= new ExpertSystem ();
			listeAgentCollided 				= new Array ();
			listeAgentCollidedOrPercepted 	= new Array ();
			listeAgentCollidedType			= new Array ();
			ressourceDeDestination 			= new Ressource (0, new Point(0, 0), 0, new Agent(new AgentType()), -1);
			updateTime 		= 0;
			isBaseConnue 	= false;
			super(_type);
		}
		
		override public function Update() : void
		{
			DrawSprite();
			Perception();
			Analyse();
			Action();
			Reinit();
		}
		
		
		/* ################################################################################################ */
		/* ############################################## FONCTIONS DE PERCEPTION ######################### */
		/* ################################################################################################ */
		
		
		public function Perception() : void 
		{
			// On reset les faits
			systemeExpertGangnam.ResetFacts();
			
			// appel fonctions qui set les faits
			setFactCollisionPerception ();
			setFactConnaitRessources ();
			setFactPorteRessource ();
			setFactIsBaseAllieeConnue ();
			setFactEstADestination ();
			setFactDetecteAgentDestination ();
			setFactTypeAgentDestination ();
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
		
		private function setFactIsBaseAllieeConnue () : void
		{
			if (isBaseAllieConnue())
				systemeExpertGangnam.SetFactValue(FactBase.connaitBase, true);
			else
				systemeExpertGangnam.SetFactValue(FactBase.neConnaitPasBase, true);
		}
		
		private function setFactEstADestination () : void
		{
			if (estDansLeRayonDArrivee ())
				systemeExpertGangnam.SetFactValue(FactBase.estADestination, true);
			else
				systemeExpertGangnam.SetFactValue(FactBase.estEnChemin, true);
		}
		
		private function setFactDetecteAgentDestination () : void
		{
			if (ressourceDeDestination != null)
			{
				if (isAgentPercepted(ressourceDeDestination.getPointeurRessource()))
					systemeExpertGangnam.SetFactValue(FactBase.detecteAgentDestination, true);
				else
					systemeExpertGangnam.SetFactValue(FactBase.neDetectePasAgentDestination, true);
			}
			else
			{
				systemeExpertGangnam.SetFactValue(FactBase.neDetectePasAgentDestination, true);
				//trace ("probleme setFactDetecteAgentDestination : ressourceDeDestination Null");
			}
		}
		
		private function setFactTypeAgentDestination () : void
		{
			if (ressourceDeDestination != null)
			{
				if (ressourceDeDestination.getType() == Ressource.BASE_ALLIEE)
				systemeExpertGangnam.SetFactValue(FactBase.destinationEstBaseAllie, true);
			else if (ressourceDeDestination.getType() == Ressource.RESSOURCE)
				systemeExpertGangnam.SetFactValue(FactBase.destinationEstRessource, true);
			}
			//else
				//trace ("probleme setFactTypeAgentDestination : ressourceDeDestination Null");	
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
			else
			{
				if (isBotAllie(agentActuel as Bot))
					typeAgent = BOT_ALLIE;
				else if (!isBotAllie(agentActuel as Bot))
					typeAgent = BOT_ENNEMI;
			}
			listeAgentCollidedType.push(typeAgent);
			//trace ("probleme typeAgent : " + typeAgent);
		}
		
		/* ################################################################################################ */
		/* ############################################## FONCTIONS D'ANALYSE ############################# */
		/* ################################################################################################ */		
		
		
		public function Analyse() : void 
		{
			systemeExpertGangnam.InferForward();
		}
		
		
		/* ################################################################################################ */
		/* ############################################## FONCTIONS D'ACTION ############################## */
		/* ################################################################################################ */		
		
		
		public function Action() : void 
		{
			// Recupere le ou les faits finaux (normalement un seul)
			var tabFaitsFinaux:Array = systemeExpertGangnam.GetInferedFacts();
			var indice:int;
			
			for each(var faitFinal:Fact in tabFaitsFinaux)
			{
				if (faitFinal == FactBase.vaExplorer) 	
					Explorer();
				else if (faitFinal == FactBase.communiquerInfosRessource)
					communiqueInformations();
				else if (faitFinal == FactBase.recupererInfosRessource)
					recupereInformationsRessource();
				else if (faitFinal == FactBase.poseRessource)
					PoseRessource();
				else if (faitFinal == FactBase.prendRessource)
					PrendRessource();
				else if (faitFinal == FactBase.vaChercherRessourcePlusPres)
					seDirigeVersLaRessourcePlusPres();
				else if (faitFinal == FactBase.vaChercherRessourceAvecLePlusDeCapacite)
					seDirigeVersLaRessourceAvecLePlusDeCapacite();
				else if (faitFinal == FactBase.vaALaBaseAlliee)
					seDirigeVersLaBaseAlliee();
				else if (faitFinal == FactBase.vaALaBaseEnnemieLaPlusPres)
					seDirigeVersLaBaseEnnemieLaPlusPres();
				else if (faitFinal == FactBase.vaALaBaseEnnemieAvecLePlusDeCapacite)
					seDirigeVersLaBaseEnnemieAvecLePlusDeCapacite();
				else if (faitFinal == FactBase.resetCapaciteRessource)
					resetCapaciteRessourceDestination ();
				else if (faitFinal == FactBase.setBaseNonConnue)
					oublieBase();
			}
		}
		
		public function Explorer () : void
		{
			var elapsedTime:Number = TimeManager.timeManager.GetFrameDeltaTime();
			var directionChangeDelayGangNam:Number = 1000;
			
			updateTime += elapsedTime;
				
			if (updateTime >=  directionChangeDelayGangNam)
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
			var indice:int = 0;
			// Pour chaque agent collisionné / percepted
			for each (var agent:Agent in listeAgentCollided)
			{
				// Si l'agent est un bot allié
				if (listeAgentCollidedType[indice] == BOT_ALLIE)
				{
					// Pour chaque ressource de sa listeRessource
					for each (var ressource:Ressource in BotGangnam(agent).getListeRessources())
					{
						// Si la ressource existe dans notre listeRessource
						var maRessource:Ressource = getRessourceByPointeurAgent(ressource.getPointeurRessource());
						if (maRessource != null)
						{
							// Si la ressource est plus recente que notre ressource
							if (ressource.estPlusRecentQue(maRessource))
							{
								if (ressource.getType() == Ressource.BASE_ALLIEE)
								{
									if (BotGangnam(agent).getIsBaseConnue())
										maRessource.miseAJourDonnees(ressource);
									isBaseConnue = BotGangnam(agent).getIsBaseConnue();
								}
								else
									maRessource.miseAJourDonnees(ressource);
							}
						}
						// Si elle n'existe pas dans notre listeRessource
						else
						{
							listeRessources.push(ressource.duplique());
							if (ressource.getType() == Ressource.BASE_ALLIEE)
								isBaseConnue = BotGangnam(agent).getIsBaseConnue();
						}
					}
				}
				indice++;
			}
		}
		
		public function recupereInformationsRessource () : void
		{
			var indice:int = 0;
			var maRessource:Ressource;
			for each (var agent:Agent in listeAgentCollided)
			{
				if (listeAgentCollidedType[indice] == RESSOURCE || 
					listeAgentCollidedType[indice] == BASE_ALLIE || 
					listeAgentCollidedType[indice] == BASE_ENNEMIE)
				{
					maRessource = getRessourceByPointeurAgent(agent);
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
						if ((agent as Resource).GetLife() > 0)
						{
							(agent as Resource).DecreaseLife();
							SetResource(true);
						}
					}
					else if (agent.GetType() == AgentType.AGENT_BOT_HOME)
					{
						if ((agent as BotHome).GetResourceCount() > 0)
						{						
							(agent as BotHome).TakeResource();
							SetResource(true);	
						}
					}
					else if (agent.GetType() == AgentType.AGENT_BOT)
					{
						if ((agent as Bot).HasResource())
						{						
							(agent as Bot).SetResource(false);
							SetResource(true);	
						}
					}
				}
				indice++;
			}
		}
		
		public function seDirigeVersLaRessourcePlusPres () : void
		{
			ressourceDeDestination = getRessourceLaPlusPresAvecCapacite ();
			if (ressourceDeDestination != null)
				seDirigeVers(ressourceDeDestination.getPosition());
			//else
				//trace ("probleme seDirigeVersLaRessourcePlusPres : ressourceDeDestination null");
		}
		
		public function seDirigeVersLaRessourceAvecLePlusDeCapacite () : void
		{
			//TODO
			//seDirigeVers(positionAgent);
		}
		
		public function seDirigeVersLaBaseAlliee () : void
		{
			ressourceDeDestination = getBaseAllieeInListe ();
			seDirigeVers(ressourceDeDestination.getPosition());
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
		
		public function resetCapaciteRessourceDestination () : void
		{
			if (ressourceDeDestination != null)
			{
				ressourceDeDestination.setCapacite(0);
				ressourceDeDestination.setTemps(TimeManager.timeManager.GetApplicationTime());
			}
			//else
				//trace ("probleme resetCapaciteRessourceDestination : ressourceDeDestination null");
		}
		
		public function oublieBase () : void
		{
			isBaseConnue = false;
			var ressourceBase:Ressource = getBaseAllieeInListe ();
			ressourceBase.setTemps(TimeManager.timeManager.GetApplicationTime());
		}
		
		
		/* ################################################################################################ */
		/* ############################################## FONCTIONS ANNEXES ############################### */
		/* ################################################################################################ */
		
		public function isAgentPercepted (_agent:Agent) : Boolean
		{
			for each (var agent:Agent in listeAgentCollided)
			{
				if (agent == _agent)
					return true;
			}
			return false;
		}
		
		public function getRessourceDansListeParPosition (_position:Point) : Ressource
		{
			for each (var ressource:Ressource in listeRessources)
			{
				if (ressource.getPosition() == _position)
					return ressource;
			}
			return null;
		}
		
		public function estDansLeRayonDArrivee () : Boolean
		{
			
			var positionDestination:Point
			if (ressourceDeDestination != null)
			{
				positionDestination = ressourceDeDestination.getPosition();
				return ((Math.sqrt(Math.pow((this.x - positionDestination.x), 2) + Math.pow((this.y - positionDestination.y), 2))) < World.BOT_PERCEPTION_RADIUS);	
			}
			else
			{
				//trace ("probleme estDansLeRayonDArrivee : ressourceDeDestination null");
				return false;
			}
			
		}
		
		public function getBaseAllieeInListe () : Ressource
		{
			for each (var ressource:Ressource in listeRessources)
			{
				if (ressource.getType() == Ressource.BASE_ALLIEE)
					return ressource;
			}
			return null;
		}
		
		public function getPositionBaseAlliee () : Point
		{
			var ressourceBaseAllie:Ressource = getBaseAllieeInListe ();
			if (ressourceBaseAllie != null)
				return ressourceBaseAllie.getPosition();
			return null;
		}
		
		public function getRessourceLaPlusPresAvecCapacite () : Ressource
		{
			var ressourcePlusPres:Ressource;
			if (isRessourcesConnuesDisponibles())
			{
				for each (var ressource:Ressource in listeRessources)
				{
					if ((ressource.getType() != Ressource.BASE_ALLIEE) && (ressource.getCapacite() > 0))
					{
						if (ressourcePlusPres == null)
							ressourcePlusPres = ressource;
						else
						{
							if ((Math.sqrt(Math.pow((this.x - ressource.getPosition().x), 2) + Math.pow((this.y - ressource.getPosition().y), 2))
							) < (Math.sqrt(Math.pow((this.x - ressourcePlusPres.getPosition().x), 2) + Math.pow((this.y - ressourcePlusPres.getPosition().y), 2))))
								ressourcePlusPres = ressource;
						}
					}
				}
				return ressourcePlusPres;
			}
			else
			{
				return null;
				//trace ("getRessourceLaPlusPresAvecCapacite : aucune ressource dispo");
			}
		}
		
		public function getPositionRessourceLaPlusPresAvecCapacite () : Point
		{
			var ressource:Ressource = getRessourceLaPlusPresAvecCapacite ();
			if (ressource != null)
				return ressource.getPosition();
			else
			{
				return new Point (this.x, this.y);
				//trace ("probleme getPositionRessourceLaPlusPresAvecCapacite : ressource null");
			}
		}
		
		public function isBaseAllieConnue () : Boolean
		{
			return isBaseConnue;
		}
		
		public function ajouteNouvelleRessource(_agent:Agent):void 
		{
			var type:int;
			var pointeur:Agent;
			var position:Point;
			var temps:Number;
			var capacite:int;
			
			type = getTypeDe(_agent);
			pointeur = _agent;
			// TODO : verifier que l'on prends les bons points actuels
			//position = _agent.GetTargetPoint();
			position = new Point (_agent.x, _agent.y);
			temps = TimeManager.timeManager.GetApplicationTime();
			capacite = getCapaciteDe(_agent);
			
			listeRessources.push(new Ressource(temps, position, capacite, pointeur, type));
			
			var ressource:Ressource = getRessourceByPointeurAgent(_agent);
			if (ressource != null)
			{
				if (ressource.getType() == Ressource.BASE_ALLIEE)
				isBaseConnue = true;
			}
			//else
				//trace("probleme ajouteNouvelleRessource : ressource null");
			
			//trace ("ajout ressource : " + ressource.getPointeurRessource().toString() + " & temps : " + ressource.getTemps()); 
		}
		
		public function modifieRessource(_ressource:Ressource, _agent:Agent):void 
		{
			// TODO : verifier que l'on prends les bons points actuels
			//_ressource.setPosition(_agent.GetTargetPoint());
			_ressource.setPosition(new Point(_agent.x, _agent.y));
			_ressource.setTemps(TimeManager.timeManager.GetApplicationTime());
			_ressource.setCapacite(getCapaciteDe(_agent));
			if (_ressource.getType() == Ressource.BASE_ALLIEE)
				isBaseConnue = true;
			//trace ("modif ressource : " + _ressource.getPointeurRessource().toString() + " & temps : " + _ressource.getTemps()); 
		}
		
		public function setIsBaseConnue(_bool:Boolean):void 
		{
			isBaseConnue = _bool;
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
		
		public function getCapaciteDe(_agent:Agent):Number 
		{
			if (_agent.GetType () == AgentType.AGENT_RESOURCE)
				return (_agent as Resource).GetLife();
			else if (_agent.GetType () == AgentType.AGENT_BOT_HOME)
				return (_agent as BotHome).GetResourceCount();
			return 0;
		}
		
		public function seDirigeVers(_positionAgent:Point) : void
		{
			var elapsedTime:Number = TimeManager.timeManager.GetFrameDeltaTime();
			
			direction.x = _positionAgent.x - this.x;   
			direction.y = _positionAgent.y - this.y;
			
			direction.normalize(1);
			
			targetPoint.x = x + direction.x * speed * elapsedTime / 1000;
			targetPoint.y = y + direction.y * speed * elapsedTime / 1000;
		}
		
		public function isRessourcesConnuesDisponibles () : Boolean
		{
			var nbRessources:Number = 0;
			for each (var ressource:Ressource in listeRessources)
			{
				if (ressource.getType() != Ressource.BASE_ALLIEE)
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
		
		
		public function getRessourceByPointeurAgent (_agent:Agent) : Ressource
		{
			for each (var ressource:Ressource in listeRessources)
			{
				if (_agent == ressource.getPointeurRessource())
				{
					//trace ("no pb !");
					return ressource;
				}
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
		
		public function getListeRessources():Array 
		{
			return listeRessources;
		}
		
		public function getIsBaseConnue():Boolean 
		{
			return isBaseConnue;
		}
		
		override public function ChangeDirection() : void
		{
			direction.x = Math.random();
			direction.y = Math.random();
			if (x < (World.WORLD_WIDTH * 0.1))
			{
				direction.x *= 1;
			}
			else if (x > (World.WORLD_WIDTH * 0.9))
			{
				direction.x *= -1;
			}
			else
			{
				if (Math.random() < 0.5)
				{
					direction.x *= -1;
				}
			}
			
			if (y < (World.WORLD_HEIGHT * 0.1))
			{
				direction.y *= 1;
			}
			else if (y > (World.WORLD_HEIGHT * 0.9))
			{
				direction.y *= -1;
			}
			else 
			{
				if (Math.random() < 0.5)
				{
					direction.y *= -1;
				}
			}
			direction.normalize(1);
		}
		
		override protected function DrawSprite() : void
	   {
			var botColor:int = 0x00FF00;			   
			botSprite.graphics.clear();
			if ( HasResource())
			{
			   botColor = 0xFF0000;
			   botSprite.graphics.lineStyle(1, 0x00FF00, 1);
			}
			else {
			   botColor = 0x00FF00;
			   botSprite.graphics.lineStyle(0, 0x00FF00, 0);
			}
			botSprite.graphics.beginFill(botColor, 1);
			botSprite.graphics.drawCircle(0, 0, radius);
			botSprite.graphics.endFill();
	   }
		
	}

}