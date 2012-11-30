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
			AddRule(new Rule(FactBase.recupereInfosRessource, FactBase.detecteRessource));
			AddRule(FactBase.communiquerInfosRessource, FactBase.detecteBotAllie);
			AddRule(FactBase.recupereInfosBaseEnnemie, FactBase.detecteBaseEnnemie);
			AddRule(FactBase.recupereInfosBaseAlliee, FactBase.detecteBaseAlliee);
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