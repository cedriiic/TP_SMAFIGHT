package com.GangnamTeam 
{
	import com.novabox.MASwithTwoNests.Agent;
	import com.novabox.MASwithTwoNests.Resource;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Charco
	 */
	public class Ressource 
	{
		private var temps:Number;
		private var position:Point;
		private var capacite:int;
		private var pointeurRessource:Agent;
		private var type:int;
		
		public static const BASE_ALLIEE:int = 1;
		public static const BASE_ENNEMIE:int = 2;
		public static const RESSOURCE:int = 3;
		
		
		public function Ressource(_temps:Number, _position:Point, _capacite:int, _pointeurRessource:Agent, _type:int) 
		{
			temps 				= _temps;
			position 			= _position;
			capacite 			= _capacite;
			pointeurRessource 	= _pointeurRessource;
			type 				= _type;
		}
		
		public function getTemps():Number 
		{
			return temps;
		}
		
		public function setTemps(value:Number):void 
		{
			temps = value;
		}
		
		public function getPosition():Point 
		{
			return position;
		}
		
		public function setPosition(value:Point):void 
		{
			position = value;
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
					this.position 	= _autreRessource.getPosition();
				}
			}
		}
	}

}