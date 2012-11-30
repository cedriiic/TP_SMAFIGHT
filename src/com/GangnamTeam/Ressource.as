package com.GangnamTeam 
{
	import com.novabox.MASwithTwoNests.Agent;
	import com.novabox.MASwithTwoNests.Resource;
	/**
	 * ...
	 * @author Charco
	 */
	public class Ressource 
	{
		private var temps:int;
		private var positionX:int;
		private var positionY:int;
		private var capacite:int;
		private var pointeurRessource:Agent;
		private var type:int;
		
		public static const BASE_ALLIEE:int = 1;
		public static const BASE_ENNEMIE:int = 2;
		public static const RESSOURCE:int = 3;
		
		public function Ressource(_temps:int, _positionX:int, _positionY:int, _capacite:int, _pointeurRessource:Agent, _type:int) 
		{
			temps 				= _temps;
			positionX 			= _positionX;
			positionY 			= _positionY;
			capacite 			= _capacite;
			pointeurRessource 	= _pointeurRessource;
			type 				= _type;
		}
		
		public function getTemps():int 
		{
			return temps;
		}
		
		public function setTemps(value:int):void 
		{
			temps = value;
		}
		
		public function getPositionX():int 
		{
			return positionX;
		}
		
		public function setPositionX(value:int):void 
		{
			positionX = value;
		}
		
		public function getPositionY():int 
		{
			return positionY;
		}
		
		public function setPositionY(value:int):void 
		{
			positionY = value;
		}
		
		public function getCapacite():int 
		{
			return capacite;
		}
		
		public function setCapacite(value:int):void 
		{
			capacite = value;
		}
		
		public function getPointeurRessource():Agent 
		{
			return pointeurRessource;
		}
		
		public function setPointeurRessource(value:Agent):void 
		{
			pointeurRessource = value;
		}
		
		public function getType():int 
		{
			return type;
		}
		
		public function setType(value:int):void 
		{
			type = value;
		}
		
		public function estPlusRecentQue (_autreRessource:Ressource) : Boolean
		{
			return (this.temps > _autreRessource.getTemps());
		}
		
		public function miseAJourDonnees (_autreRessource:Ressource) : void
		{
			if (this.pointeurRessource == _autreRessource.getPointeurRessource())
			{
				if (!estPlusRecentQue (_autreRessource))
				{
					this.temps 		= _autreRessource.getTemps();
					this.capacite 	= _autreRessource.getCapacite();
					this.positionX 	= _autreRessource.getPositionX();
					this.positionY 	= _autreRessource.getPositionY();
				}
			}
		}
	}

}