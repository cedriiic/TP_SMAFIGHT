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
		public static const aucuneRessourceTrouvee:Fact = new Fact("aucuneRessourceTrouvee");
		
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
		
		public static const aUnOrdre:Fact 				= new Fact("AUnOrdre");
		public static const naPasDOrdre:Fact 			= new Fact("naPasDOrdre");
		
		//public static const recupereInfosRessource = new Fact("RecupererInfosRessource");
		//public static const communiquerInfosRessource = new Fact("CommuniquerInfosRessource");
		//public static const recupereInfosBaseAlliee = new Fact("RecupereInfosBaseAlliee");
		//public static const recupereInfosBaseEnnemie = new Fact("RecupereInfosBaseEnnemie");
		
		public function FactBase() 
		{
			facts = new Array();
			factValues = new Array();
			
			AddFact(porteRessource);
			AddFact(nePortePasDeRessource);
			
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