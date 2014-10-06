package  
{
	/**
	 * ...
	 * @author ...
	 */
	public class Computer 
	{
		private var _difficult: Number = 0;
		
		private var _active: Boolean = false;
		
		private var _field: Field;
		
		
		public function Computer(field:Field) 
		{
			_field = field;
		}
		
		public function setDifficult(difficult: Number):void
		{
			_difficult = difficult;
		}
		
		public function getDifficult():Number
		{
			return _difficult;
		}
		
		public function setActive(active: Boolean):void
		{
			_active = active;
		}
		
		public function isActive(): Boolean
		{
			return _active;
		}
		
		public function click(who: Boolean):void
		{
			if (!isActive())
				return;
				
			
		}
	}

}