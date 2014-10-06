package
{
	import flash.display.Graphics;
	import flash.display.Shader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.globalization.DateTimeFormatter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.display.Bitmap;
	import flash.display.GradientType;
	
	/**
	 * ...
	 * @author SlaFF
	 */
	public class Field extends Sprite
	{
		private var _main:Main;
		
		private var _countX:int = 3;
		private var _countY:int = 3;
		
		private var _oldSelectX:int = -1;
		private var _oldSelectY:int = -1;
		
		private var _squareSizeX:int;
		private var _squareSizeY:int;
		
		private var _left:int;
		private var _top:int;
		private var _width:int;
		private var _height:int;

		private var _selectSquare:Shape;
		
		private var _stcScope: TextField;
		private var _stcTimer: TextField;
		private var _stcWhoPlay: TextField;
		private var _stcGameOver: TextField;
		private var _panelFormatText:TextFormat;

		private var _arrField:Array;
		
		public static const VALUE_NULL:int  = -2;
		public static const VALUE_EMPTY:int = -1;
		public static const VALUE_ZERO:int  =  0;
		public static const VALUE_CROSS:int =  1;
		
		public function Field(main:Main, left:int, top:int, width:int, height:int)
		{
			_main = main;
			_left = left;
			_top = top;
			_width = width;
			_height = height;

			_squareSizeX = _width / _countX;
			_squareSizeY = _height / _countY;
			
			_arrField = new Array(this._countX * this._countY);
			
			_selectSquare = new Shape();
			_selectSquare.graphics.lineStyle(3, 0xFF0000, 1);
			_selectSquare.graphics.moveTo(0, 0);
			_selectSquare.graphics.lineTo(0, _squareSizeY);
			_selectSquare.graphics.lineTo(_squareSizeX, _squareSizeY);
			_selectSquare.graphics.lineTo(_squareSizeX, 0);
			_selectSquare.graphics.lineTo(0, 0);
			_selectSquare.visible = false;
			
			this.addChild(_selectSquare);
			
			_panelFormatText = new TextFormat(null, 25, 0xFFFF00);
			_panelFormatText.align = "left";
			_panelFormatText.bold = true;

			_stcTimer = new TextField();
			_stcTimer.x = _width - 150;
			_stcTimer.y = 0;
			_stcTimer.width = 90;
			_stcTimer.height = 40;
			this.addChild(_stcTimer);
			
			_stcWhoPlay = new TextField();
			_stcWhoPlay.x = 10;
			_stcWhoPlay.y = 0;
			_stcWhoPlay.width = 200;
			_stcWhoPlay.height = 70;
			this.addChild(_stcWhoPlay);
			
			var btnStartGame:MyButton = new MyButton("Закончить");
			btnStartGame.x = (_width - btnStartGame.width) / 2;
			btnStartGame.y = 0;
			btnStartGame.addEventListener(MouseEvent.CLICK, _main.onGameStart);
			this.addChild(btnStartGame);
			
			_stcGameOver = new TextField();
			_stcGameOver.x = 0;
			_stcGameOver.width = _width;
			_stcGameOver.y  = (_height - 70) / 2;
			_stcGameOver.height = 100;
			this.addChild(_stcGameOver);
			
			this.useHandCursor = true;
			this.buttonMode = true;
		}
		
		public function setTime(seconds:int):void
		{
			_stcTimer.text = seconds.toString();
			_stcTimer.setTextFormat(_panelFormatText);
		}
		
		public function setWhoPlay(who: Boolean):void
		{
			_stcWhoPlay.text = "ходят: " + (who ? "крестики" : "нолики");
			_stcWhoPlay.setTextFormat(_panelFormatText);
		}
		
		public function getCountX():int
		{
			return _countX;
		}
		
		public function getCountY():int
		{
			return _countY;
		}
		
		public function getFieldArray():Array
		{
			return _arrField;
		}
		
		public function getIndexX(mouseX:int):int
		{
			return (mouseX - _left) / _squareSizeX;
		}
		
		public function getIndexY(mouseY:int):int
		{
			return (mouseY - _top) / _squareSizeY;
		}
	
		private function onMouseClick(e:MouseEvent):void
		{
			_main.getCore().click(e);
		}
		
		public function isEmptySquare(x:int, y:int):Boolean
		{
			return true;
		}
		
		public function getSquareValue(e:MouseEvent): int
		{
			if (!isWithinField(e))
				return Field.VALUE_NULL;
				
			var x:int = getIndexX(e.localX);
			var y:int = getIndexY(e.localY);

			return _arrField[y * _countX + x];
		}
		
		public function setSquareValue(x:int, y:int, value:int):void
		{
			var index:int = y * _countX + x;
			if (index >= _countX * _countY)
				throw new "Bad index";

			_arrField[index] = value;
			
			var g:Graphics = this.graphics;
			
			g.lineStyle(10, 0x008040, 1);
			
			if (value == VALUE_ZERO)
			{
				g.drawCircle(_squareSizeX * (x + 0.5)  + _left, _squareSizeY * (y + 0.5)  + _top, 50); 
			}
			if (value == VALUE_CROSS)
			{
				const w:int = 40;
				const h:int = 40;
				var x0:int = _squareSizeX * (x + 0.5)  + _left;
				var y0:int = _squareSizeY * (y + 0.5)  + _top;

				g.beginFill(0x00AA55);
				g.moveTo(x0 - w, y0 - h);
				g.lineTo(x0 + w, y0 + h);
				g.moveTo(x0 - w, y0 + h);
				g.lineTo(x0 + w, y0 - h);
				g.endFill();
			}
		}
		
		public function startGame(who: Boolean):void
		{
			clear();
			drawBackground();
			draw();
			
			setWhoPlay(who);
			setTime(0);
			
			this.addEventListener(MouseEvent.CLICK, onMouseClick);
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		public function showWin(status: CheckGameStatus):void
		{
			var g:Graphics = this.graphics;

			var winner:String;
			switch (status.status)
			{
				case Core.END_WIN_CROSS: winner = "Выиграли крестики"; break;
				case Core.END_WIN_ZERO: winner = "Выиграли нолики"; break;
				case Core.END_WIN_NOTHING: winner = "Ничья"; break;
				default:
					throw "Unknown winner";
			}
			setGameOverText(winner);
			
			// Draw line
			trace("status: ", status.status);
			if (status.status == Core.END_WIN_CROSS || status.status == Core.END_WIN_ZERO)
			{
				g.lineStyle(20, 0x800080, 0.5, true);
				var x: int = (Math.random() * int.MAX_VALUE) % 150 - 75;
				var y: int = (Math.random() * int.MAX_VALUE) % 150 - 75;
				g.moveTo(_squareSizeX * (status.point0.x + 0.5) + x, _squareSizeY * (status.point0.y + 0.5) + _top + y);
				x = (Math.random() * int.MAX_VALUE) % 20 - 10;
				y = (Math.random() * int.MAX_VALUE) % 20 - 10;
				g.lineTo(_squareSizeX * (status.point1.x + 0.5) + x, _squareSizeY * (status.point1.y + 0.5) + _top + y);
			}

			this.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.removeEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		public function isWithinField(e:MouseEvent):Boolean
		{
			return !(e.localX < _left || e.localX > _left + _width - 1) &&  // TODO: -1 hack
				   !(e.localY < _top || e.localY > _top + _height - 2);     // TODO: -2 hack
		}

		private function onMouseMove(e:MouseEvent):void
		{
			if (!isWithinField(e))
				return;

			var x:int = (e.localX - _left) / _squareSizeX;
			var y:int = (e.localY - _top) / _squareSizeY;
			
			if (_oldSelectX != x || _oldSelectY != y)
			{
				_selectSquare.x = x * _squareSizeX + _left;
				_selectSquare.y = y * _squareSizeY + _top;
				_selectSquare.visible = true;
			}
			
			_oldSelectX = x;
			_oldSelectY = y;
		}

	/*	private function onKeyDown(e:KeyboardEvent):void
		{
			if (_oldSelectX < 0 || _oldSelectY < 0)
				return;
			
			var index:int = 0;
				
			switch (e.keyCode)
			{
				case Keyboard.LEFT:
					if (_oldSelectX <= 0)
						return;
					_oldSelectX--;
					break;
				case Keyboard.UP:
					if (_oldSelectY <= 0)
						return;
					_oldSelectY--;
					break;
				case Keyboard.RIGHT:
					if (_oldSelectX >= _countX - 1)
						return;
					_oldSelectX++;
					break;
				case Keyboard.DOWN:
					if (_oldSelectY >= _countY - 1)
						return;
					_oldSelectY++;
					break;
			}
			_selectSquare.x = _oldSelectX * _squareSizeX;
			_selectSquare.y = _oldSelectY * _squareSizeY;
		}*/
		
		public function clear():void
		{
			for (var i:int = this._countX * this._countY - 1; i >= 0; --i)
			{
				_arrField[i] = VALUE_EMPTY;
			}
			_selectSquare.visible = false;
			_stcGameOver.visible = false;
		}
		
		public function draw():void
		{
			var g:Graphics = this.graphics;
			var dx:int = _width / _countX;
			var dy:int = _height / _countY;
			var x:int;
			var y:int;
			var i:int;
			
			g.lineStyle(2, 0x000000);
			
			y = this._top + _height;
			for (i = 0; i <= this._countX; ++i)
			{
				x = _left + i * dx;
				g.moveTo(x, _top);
				g.lineTo(x, y);
			}
			
			x = this._left + _width;
			for (i = 0; i <= this._countX; ++i)
			{
				y = _top + i * dy;
				g.moveTo(_left, y);
				g.lineTo(x, y);
			}
		}
		
		private function drawBackground(): void
		{
			var g:Graphics = this.graphics;
			var colors: Array = [0x8888FF, 0xBBBBFF];
			var alphas: Array = [1, 1];
			var ratios: Array = [0, 255];
			var matrix: Matrix = new Matrix;

			matrix.createGradientBox(800, 600, Math.PI / 2);
			g.lineStyle(1, 0x000000, 1);
			g.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix);
			g.drawRect(_left, _top, _width, _height);
			g.endFill();
		}
		
		public function setGameOverText(text: String):void
		{
			var format:TextFormat = new TextFormat();
			format.size = 70;
			format.bold = true;
			format.italic = true;
			format.color = 0xFF8000;
			format.align = "center";
			_stcGameOver.text = text;
			_stcGameOver.setTextFormat(format);
			_stcGameOver.visible = true;
			
			_selectSquare.visible = false;
		}
	}

}