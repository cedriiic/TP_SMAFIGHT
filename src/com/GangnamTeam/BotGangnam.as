package com.GangnamTeam 
{
	import com.novabox.MASwithTwoNests.Bot;
	
	/**
	 * ...
	 * @author Charco
	 */
	public class BotGangnam extends Bot 
	{
		
		private var listeRessources:Array;
		
		public function BotGangnam() 
		{
			listeRessources = new Array ();
		}
		
		override public function Update() : void
		{
			
		}
		
		public function getRessourceByPointeur (_maRessource:Ressource) : Ressource
		{
			for each (var ressource:Ressource in listeRessources)
			{
				if (_maRessource.pointeurRessource == ressource.pointeurRessource)
					return ressource;
			}
			return null;
		}
	}

}