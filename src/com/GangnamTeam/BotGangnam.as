package com.GangnamTeam 
{
	import com.novabox.MASwithTwoNests.AgentCollideEvent;
	import com.novabox.MASwithTwoNests.AgentType;
	import com.novabox.MASwithTwoNests.Bot;
	import com.novabox.MASwithTwoNests.BotHome;
	import com.novabox.MASwithTwoNests.Resource;
	import com.novabox.MASwithTwoNests.Agent;
	
	/**
	 * ...
	 * @author Charco
	 */
	public class BotGangnam extends Bot 
	{
		
		private var listeRessources:Array;
		
		
		public function BotGangnam(_type:AgentType) 
		{
			super(_type);
			
			listeRessources = new Array ();
		}
		
		override public function Update() : void
		{
			
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