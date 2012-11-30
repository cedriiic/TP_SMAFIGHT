package com.GangnamTeam.expertSystemGangnam 
{
	/**
	 * Expert System 
	 * 
	 * @author Ophir / Nova-box
	 * @version 1.0
	 */
	public class RuleBase
	{
		private var rules:Array;
		
		public function RuleBase() 
		{
			rules = new Array();
			
			//Recherche de ressource
			AddRule(new Rule(FactBase.vaExplorer, new Array(FactBase.nePortePasDeRessource, FactBase.aucuneRessourceTrouvee)));
			
			//Détection
			AddRule(new Rule(FactBase.recupereInfosRessource, FactBase.detecteRessource));
			AddRule(new Rule(FactBase.communiquerInfosRessource, FactBase.detecteBotAllie));
			AddRule(new Rule(FactBase.recupereInfosBaseEnnemie, FactBase.detecteBaseEnnemie));
			AddRule(new Rule(FactBase.recupereInfosBaseAlliee, FactBase.detecteBaseAlliee));
			
			//Collision
			AddRule(new Rule(FactBase.prendRessource, new Array(FactBase.collisionneRessource, FactBase.nePortePasDeRessource)));
			AddRule(new Rule(FactBase.prendRessource, new Array(FactBase.collisionneBaseEnnemie, FactBase.nePortePasDeRessource)));
			
			//Porte une ressource
			AddRule(new Rule(FactBase.vaALaBaseAlliee, FactBase.porteRessource));
			
			
		}
		
		public function AddRule(_rule:Rule) : void
		{
			rules.push(_rule);
		}
		
		public function GetRules() : Array
		{
			return rules;
		}
		
	}

}