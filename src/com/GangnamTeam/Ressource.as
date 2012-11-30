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
		
		public function get temps():int 
		{
			return temps;
		}
		
		public function set temps(value:int):void 
		{
			temps = value;
		}
		
		public function get positionX():int 
		{
			return positionX;
		}
		
		public function set positionX(value:int):void 
		{
			positionX = value;
		}
		
		public function get positionY():int 
		{
			return positionY;
		}
		
		public function set positionY(value:int):void 
		{
			positionY = value;
		}
		
		public function get capacite():int 
		{
			return capacite;
		}
		
		public function set capacite(value:int):void 
		{
			capacite = value;
		}
		
		public function get pointeurRessource():Agent 
		{
			return pointeurRessource;
		}
		
		public function set pointeurRessource(value:Agent):void 
		{
			pointeurRessource = value;
		}
		
		public function get type():int 
		{
			return type;
		}
		
		public function set type(value:int):void 
		{
			type = value;
		}
		
		public function estPlusRecentQue (_autreRessource:Ressource) : Boolean
		{
			return (this.temps > _autreRessource.temps);
		}
		
		public function miseAJourDonnees (_autreRessource:Ressource) : void
		{
			if (this.pointeurRessource == _autreRessource.pointeurRessource)
			{
				if (!estPlusRecentQue (_autreRessource))
				{
					this.temps 		= _autreRessource.temps;
					this.capacite 	= _autreRessource.capacite;
					this.positionX 	= _autreRessource.positionX;
					this.positionY 	= _autreRessource.positionY;
				}
			}
		}
	}

}