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
		
		/**
		 * 
		 * @param	who
		 * @return true if sets value
		 */
		public function click(who: Boolean):Boolean
		{
			if (!isActive())
				return false;
				
			var count: int = _field.getCountX() * _field.getCountY();
			var index: int = (Math.random() * int.MAX_VALUE) % count;
			var idnexCount: int = 0;
			var arrField: Array = _field.getFieldArray();
			while (arrField[index] != Field.VALUE_EMPTY)
			{
				index++;
				if (index >= count)
					index = 0;
				idnexCount++;
				if (idnexCount >= count)
					return false;
			}
			var value: int = who ? Field.VALUE_CROSS : Field.VALUE_ZERO;
			var y: int = index / _field.getCountX();
			var x: int = index % _field.getCountX();
			_field.setSquareValue(x, y, value);
			
			return true;
		}
	}

}