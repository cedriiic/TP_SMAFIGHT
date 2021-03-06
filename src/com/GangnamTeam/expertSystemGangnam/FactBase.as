﻿package com.GangnamTeam.expertSystemGangnam 
{
	/**
	 * Expert System 
	 * 
	 * @author Ophir / Nova-box
	 * @version 1.0
	 */
	public class FactBase
	{
		
		private var facts:Array;
		
		public var factValues:Array;
		
		public static const destinationEstBaseAllie:Fact 	= new Fact("destinationEstBaseAllie");
		public static const destinationEstRessource:Fact 	= new Fact("destinationEstRessource");
		
		public static const porteRessource:Fact 			= new Fact("porteRessource");
		public static const nePortePasDeRessource:Fact 		= new Fact("nePortePasDeRessource");
		public static const neConnaitPasDeRessource:Fact 	= new Fact("neConnaitPasDeRessource");
		public static const connaitDesRessources:Fact		= new Fact("connaitRessource");
		public static const connaitBase:Fact				= new Fact("connaitBase");
		public static const neConnaitPasBase:Fact			= new Fact("neConnaitPasBase");
		
		public static const detecteRessource:Fact 			= new Fact("detecteRessource");
		public static const detecteBotEnnemi:Fact 			= new Fact("detecteBotEnnemi");
		public static const detecteBotAllie:Fact 			= new Fact("detecteBotAllie");
		public static const detecteBaseEnnemie:Fact 		= new Fact("detecteBaseEnnemie");
		public static const detecteBaseAlliee:Fact 			= new Fact("detecteBaseAlliee");
		public static const detecteAgentDestination:Fact 	= new Fact("detecteAgentDestination");
		public static const neDetectePasAgentDestination:Fact = new Fact("neDetectePasAgentDestination");
		
		public static const collisionneRessource:Fact 		= new Fact("collisionneRessource");
		public static const collisionneBotEnnemi:Fact 		= new Fact("collisionneBotEnnemi");
		public static const collisionneBotAllie:Fact 		= new Fact("collisionneBotAllie");
		public static const collisionneBaseEnnemie:Fact		= new Fact("collisionneBaseEnnemie");
		public static const collisionneBaseAlliee:Fact 		= new Fact("collisionneBaseAlliee");
		
		public static const estADestination:Fact 			= new Fact("estADestination");
		public static const estEnChemin:Fact 				= new Fact("estEnChemin");
		
		public static const recupererInfosRessource:Fact 	= new Fact("recupererInfosRessource");
		public static const communiquerInfosRessource:Fact 	= new Fact("communiquerInfosRessource");
		
		public static const poseRessource:Fact								= new Fact("poseRessource");
		public static const prendRessource:Fact								= new Fact("prendRessource");
		public static const vaChercherRessourcePlusPres:Fact				= new Fact("vaChercherRessourcePlusPres");
		public static const vaChercherRessourceAvecLePlusDeCapacite:Fact	= new Fact("vaChercherRessourceAvecLePlusDeCapacite");
		public static const vaExplorer:Fact									= new Fact("vaExplorer");
		public static const vaALaBaseAlliee:Fact							= new Fact("vaALaBaseAlliee");
		public static const vaALaBaseEnnemieLaPlusPres:Fact					= new Fact("vaALaBaseEnnemieLaPlusPres");
		public static const vaALaBaseEnnemieAvecLePlusDeCapacite:Fact		= new Fact("vaALaBaseEnnemieAvecLePlusDeCapacite");
		public static const resetCapaciteRessource:Fact						= new Fact("resetCapaciteRessource");
		public static const setBaseNonConnue:Fact							= new Fact("setBaseNonConnue");
		
		
		public function FactBase() 
		{
			facts = new Array();
			factValues = new Array();
			
			AddFact(destinationEstBaseAllie);
			AddFact(destinationEstRessource);
			
			AddFact(porteRessource);
			AddFact(nePortePasDeRessource);
			AddFact(connaitDesRessources);
			AddFact(neConnaitPasDeRessource);
			AddFact(connaitBase);
			AddFact(neConnaitPasBase);
			
			AddFact(detecteRessource);
			AddFact(detecteBotEnnemi);
			AddFact(detecteBotAllie);
			AddFact(detecteBaseEnnemie);
			AddFact(detecteBaseAlliee);
			AddFact(detecteAgentDestination);
			AddFact(neDetectePasAgentDestination);
			
			AddFact(collisionneRessource);
			AddFact(collisionneBotEnnemi);
			AddFact(collisionneBotAllie);
			AddFact(collisionneBaseEnnemie);
			AddFact(collisionneBaseAlliee);
			
			AddFact(estADestination);
			AddFact(estEnChemin);
			
			AddFact(recupererInfosRessource);
			AddFact(communiquerInfosRessource);
			
			AddFact(poseRessource);
			AddFact(prendRessource);
			AddFact(vaChercherRessourcePlusPres);
			AddFact(vaChercherRessourceAvecLePlusDeCapacite);
			AddFact(vaExplorer);
			AddFact(vaALaBaseAlliee);
			AddFact(vaALaBaseEnnemieLaPlusPres);
			AddFact(vaALaBaseEnnemieAvecLePlusDeCapacite);
			AddFact(resetCapaciteRessource);
			AddFact(setBaseNonConnue);
			
			
			// ******************************************* FIN BASE DE FAITS *****************************************
			
			ResetFacts();
		}
		
		public function AddFact(_fact:Fact) : void
		{
			facts.push(_fact);
			SetFactValue(_fact, false);
		}
		
		public function HasFact(_fact:Fact) : Boolean
		{
			for (var i:int = 0; i < facts.length; i++)
			{
				if (facts[i] == _fact)
				{
					return true;
				}
			}
			return false;
		}
				
		public function SetFactValue(_fact:Fact, _value:Boolean) : void
		{
			if (HasFact(_fact))
			{
				factValues[_fact.GetLabel()] = _value;
			}
		}
		
		public function GetFactValue(_fact:Fact) : Boolean
		{
			if (HasFact(_fact))
			{
				return factValues[_fact.GetLabel()];
			}
			return false;
		}
		
		public function ResetFacts() : void
		{
			for (var i:int = 0; i < facts.length; i++)
			{
				var fact:Fact = (facts[i] as Fact);
				SetFactValue(fact, false);
			}
		}
		
	}

}