package com.GangnamTeam.expertSystemGangnam 
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
		
		private var factValues:Array;
		
		public static const porteRessource:Fact 		= new Fact("porteRessource");
		public static const nePortePasDeRessource:Fact 	= new Fact("nePortePasDeRessource");
		public static const neConnaitPasDeRessource:Fact = new Fact("neConnaitPasDeRessource");
		public static const connaitDesRessources:Fact	= new Fact("connaitRessource");
		
		public static const detecteRessource:Fact 		= new Fact("detecteRessource");
		public static const detecteBotEnnemi:Fact 		= new Fact("detecteBotEnnemi");
		public static const detecteBotAllie:Fact 		= new Fact("detecteBotAllie");
		public static const detecteBaseEnnemie:Fact 	= new Fact("detecteBaseEnnemie");
		public static const detecteBaseAlliee:Fact 		= new Fact("detecteBaseAlliee");
		
		public static const collisionneRessource:Fact 	= new Fact("collisionneRessource");
		public static const collisionneBotEnnemi:Fact 	= new Fact("collisionneBotEnnemi");
		public static const collisionneBotAllie:Fact 	= new Fact("collisionneBotAllie");
		public static const collisionneBaseEnnemie:Fact	= new Fact("collisionneBaseEnnemie");
		public static const collisionneBaseAlliee:Fact 	= new Fact("collisionneBaseAlliee");
		
		public static const aUnOrdre:Fact 				= new Fact("aUnOrdre");
		public static const naPasDOrdre:Fact 			= new Fact("naPasDOrdre");
		
		public static const recupererInfosRessource:Fact 	= new Fact("recupererInfosRessource");
		public static const communiquerInfosRessource:Fact 	= new Fact("communiquerInfosRessource");
		//public static const recupereInfosBaseAlliee:Fact 	= new Fact("recupereInfosBaseAlliee");
		//public static const recupereInfosBaseEnnemie:Fact 	= new Fact("recupereInfosBaseEnnemie");
		
		public static const poseRessource:Fact								= new Fact("poseRessource");
		public static const prendRessource:Fact								= new Fact("prendRessource");
		public static const vaChercherRessourcePlusPres:Fact				= new Fact("vaChercherRessourcePlusPres");
		public static const vaChercherRessourceAvecLePlusDeCapacite:Fact	= new Fact("vaChercherRessourceAvecLePlusDeCapacite");
		public static const vaExplorer:Fact									= new Fact("vaExplorer");
		public static const vaALaBaseAlliee:Fact							= new Fact("vaALaBaseAlliee");
		public static const vaALaBaseEnnemieLaPlusPres:Fact					= new Fact("vaALaBaseEnnemieLaPlusPres");
		public static const vaALaBaseEnnemieAvecLePlusDeCapacite:Fact		= new Fact("vaALaBaseEnnemieAvecLePlusDeCapacite");
		
		public function FactBase() 
		{
			facts = new Array();
			factValues = new Array();
			
			AddFact(porteRessource);
			AddFact(nePortePasDeRessource);
			AddFact(connaitDesRessources);
			AddFact(neConnaitPasDeRessource);
			
			AddFact(detecteRessource);
			AddFact(detecteBotEnnemi);
			AddFact(detecteBotAllie);
			AddFact(detecteBaseEnnemie);
			AddFact(detecteBaseAlliee);
			
			AddFact(collisionneRessource);
			AddFact(collisionneBotEnnemi);
			AddFact(collisionneBotAllie);
			AddFact(collisionneBaseEnnemie);
			AddFact(collisionneBaseAlliee);
			
			AddFact(aUnOrdre);
			AddFact(naPasDOrdre);
			
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
			else
				trace("CROTTE");
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