package  
{
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;

	/**
	 * ...
	 * @author SlaFF
	 */
	public class Core 
	{
		private var _mode: int = 0;
		private var _usedSquareCount: int = 0;
		private var _checkGameStatus: CheckGameStatus;
		
		private var _whoPlay: Boolean; // true - Cross, false - Zero
		
		private var _field:Field;
		
		private var _computer: Computer;
		
		private var _timer: Timer;
		
		public static var   MODE_MAX:int    = 0;
		public static const MODE_EASY:int   = MODE_MAX++;
		public static const MODE_MIDDLE:int = MODE_MAX++;
		public static const MODE_HARD:int   = MODE_MAX++;
		
		public static const END_NULL:int        = 0;
		public static const END_TERMINATE:int   = 1;
		public static const END_WIN_ZERO:int    = 2;
		public static const END_WIN_CROSS:int   = 3;
		public static const END_WIN_NOTHING:int = 4;
		
		public function Core(field:Field)
		{
			_mode = MODE_EASY;
			_field = field;
			_timer = new Timer(1000);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			
			_computer = new Computer(field);
			_computer.setDifficult(0);
			_computer.setActive(true);
			
			_checkGameStatus = new CheckGameStatus();
		}

		public function getComputer():Computer
		{
			return _computer;
		}
		
		private function onTimer(e:TimerEvent):void
		{
			_field.setTime(_timer.currentCount);
		}
		
		public function startGame():void
		{
			_usedSquareCount = 0;
			_timer.reset();
			_timer.start();
			_whoPlay = Math.floor(Math.random() * int.MAX_VALUE) % 2 == 0;
			_field.startGame(_whoPlay);
		}
		
		public function isGaming():Boolean
		{
			return _timer.running;
		}
		
		public function endGame():void
		{
			_timer.stop();
		}
		
		/**
		 * Handle Mouse clicks
		 */
		public function click(e:MouseEvent):int
		{
			if (!isGaming())
				return END_NULL;
			
			var value:int = _field.getSquareValue(e);

			if (value == Field.VALUE_NULL)
				return END_NULL;
			if (value != Field.VALUE_EMPTY)
				return END_NULL;

			if (_whoPlay)
				value = Field.VALUE_CROSS;
			else
				value = Field.VALUE_ZERO;

			var x:int = _field.getIndexX(e.localX);
			var y:int = _field.getIndexY(e.localY);
			
			_field.setSquareValue(x, y, value);
			_usedSquareCount++;

			var status:CheckGameStatus = checkGameOver(x, y)
			trace(status.status);
			if (status.status != END_NULL)
				return status.status;
			
			swapPlayers();
			
			if (_computer.isActive())
			{
				if (_computer.click(_whoPlay))
					_usedSquareCount++;
				status = checkGameOver(x, y);
				if (status.status != END_NULL)
					return status.status;
				swapPlayers();
			}

			return END_NULL;
		}
		
		private function getGameStatus(x:int, y:int, status: CheckGameStatus):void
		{
			var value: int;
			
			if (_whoPlay)
			{
				value = Field.VALUE_CROSS;
				status.status = END_WIN_CROSS;
				trace("checl for clross");
			}
			else
			{
				value = Field.VALUE_ZERO;
				status.status = END_WIN_ZERO;
				trace("check for zero");
			}
						
			var arrField:Array = _field.getFieldArray();
			
			/* 0 x x
			 * x 0 x
			 * x x 0
			 */
			// check horizontal
			// check vertical
			// check diagonal low
			// check diagonal hi
			var i:int;
			var y0: int;
			var x0: int;
			var win: Boolean;

			// Horizontal
			y0 = y * _field.getCountX();
			win = true;
			for (i = 0; i < 3; ++i)
				win &&= arrField[y0 + i] == value;
			if (win)
			{
				trace("win hor");
				status.point0.x = 0;
				status.point0.y = y;
				status.point1.x = 2;
				status.point1.y = y;
				return;
			}

			// Vertical
			win = true;
			for (i = 0; i < 3; ++i)
				win &&= arrField[_field.getCountX() * i + x] == value;
			if (win)
			{
				trace("win vert", x, y);
				status.point0.x = x;
				status.point0.y = 0;
				status.point1.x = x;
				status.point1.y = 2;
				return;
			}

			// Diagonal low
			win = true;
			for (i = 0; i < 3; ++i)
				win &&= arrField[_field.getCountX() * i + i] == value;
			if (win)
			{
				trace("win diag low");
				status.point0.x = 0;
				status.point0.y = 0;
				status.point1.x = 2;
				status.point1.y = 2;
				return;
			}
			
			// Diagonal hi
			win = true;
			for (i = 3 - 1; i >= 0; --i)
				win &&= arrField[_field.getCountX() * i + (2 - i)] == value;
			if (win)
			{
				trace("win diag hi");
				status.point0.x = 0;
				status.point0.y = 2;
				status.point1.x = 2;
				status.point1.y = 0;
				return;
			}
			
			if (isNothing())
			{
				status.status = END_WIN_NOTHING;
				return;
			}
				
			status.status = END_NULL;
		}
		
		private function checkGameOver(x:int, y:int): CheckGameStatus
		{
			var angle: int;
			var pt: Point;
			var status: CheckGameStatus = _checkGameStatus;
			
			getGameStatus(x, y, status);
			if (status.status != END_NULL)
			{
				_timer.stop();
				_field.showWin(status);
				return status;
			}
			
			return status;
		}
		
		public function isNothing():Boolean
		{
			return _usedSquareCount == _field.getCountX() * _field.getCountY();
		}
		
		private function swapPlayers():void
		{
			_whoPlay = !_whoPlay;
			_field.setWhoPlay(_whoPlay);
		}
	}

}