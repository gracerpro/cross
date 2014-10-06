package 
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.display.GradientType;
	import flash.system.fscommand;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	
	/**
	 * ...
	 * @author SlaFF
	 */
	public class Main extends Sprite 
	{
		private var _sceneView:int = 0; // 0 - menu, 1 - game
		
		private var _width:int = 800;
		private var _height:int = 600;

		private var _menuSurface: Sprite;
		
		// Menu
		private var _btnStart: MyButton; // stop too
		private var _btnExit: MyButton;
		
		private var _field: Field;
		private var _core: Core;

		public function Main():void 
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);

			// entry point
			
			createMenu();

			_field = new Field(this, 0, 50, this._width - 20, this._height - 71);
			_field.x = 10;
			_field.y = 10;
			
			_core = new Core(_field);
			this.addChild(_field);
			
			showSprite(_menuSurface);
		}
	
		public function getCore():Core
		{
			return _core;
		}

		private function createBackground(): void
		{
			var g:Graphics = this.graphics;
			var colors: Array = [0x8888FF, 0xBBBBFF];
			var alphas: Array = [1, 1];
			var ratios: Array = [0, 255];
			var matrix: Matrix = new Matrix;

			matrix.createGradientBox(800, 600, Math.PI / 2);
			g.lineStyle(1, 0x000000, 1);
			g.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix);
			g.drawRect(0, 0, 800, 600);
			g.endFill();
		}
		
		private function addTextField(where: Sprite, text: String, size:int, y: int, height: int):void
		{
			var stc: TextField = new TextField();
			
			stc.text = text;
			stc.x = 0;
			stc.y = y;
			stc.width = _width;
			stc.height = height;
			var format: TextFormat = new TextFormat();
			format.align = "center";
			format.color = 0x00FFFF;
			format.size = size;
			format.bold = true;
			stc.setTextFormat(format);
			_menuSurface.addChild(stc);
		}
		
		private function createMenu(): Sprite
		{
			_menuSurface = new Sprite();
			_menuSurface.visible = false;
			
			addTextField(_menuSurface, "Крестики-нолики", 60, 30, 80);
			addTextField(_menuSurface, "Version 1.0", 20, 100, 30);
			addTextField(_menuSurface, "Copyright (C) 2014, gracerpro@gmail.com", 20, 130, 40);
			
			_btnStart = new MyButton("Новая");
			var x:int = (_width - _btnStart.width) / 2;
			var y:int = (_height - 150) / 2;
			_btnStart.x = x;
			_btnStart.y = y;
			y += 50;
			_btnStart.addEventListener(MouseEvent.CLICK, onGameStart);
			_menuSurface.addChild(_btnStart);
	
			_btnExit = new MyButton("Выйти");
			_btnExit.x = x;
			_btnExit.y = y;
			y += 50;
			_btnExit.addEventListener(MouseEvent.CLICK, onGameExit);
			_menuSurface.addChild(_btnExit);
			
			this.addChild(_menuSurface);
			
			return _menuSurface;
		}
		
		public function onGameStart(e:MouseEvent): void
		{
			if (_btnStart.text == "Новая")
			{
				showSprite(_field);
				_core.startGame();
				_btnStart.text = "Закончить";
			}
			else
			{
				showSprite(_menuSurface);
				_core.endGame();
				_btnStart.text = "Новая";
			}
		}

		public function onGameExit(e:MouseEvent):void
		{
			fscommand("quit");
		}
		
		private function showSprite(sprite: Sprite):void
		{
			_menuSurface.visible = false;
			_field.visible = false;

			sprite.visible = true;
		}
	}
}