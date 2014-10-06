package  
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.display.GradientType;
	
	/**
	 * ...
	 * @author SlaFF
	 */
	public class MyButton extends Sprite
	{
		private var _width:int = 140;
		private var _height:int = 30;
		
		private var _label:TextField;
		private var _labelTextFormat:TextFormat;
		
		private static var _colors:Array = [0xFAD4DB, 0xEC748B];
		private static var _colors2:Array = [0xFCE4E9, 0xEF8FA3];
		private static var _alphas:Array = [1, 1];
		private static var _ratios:Array = [0, 255];
		private static var _matrix:Matrix = new Matrix();
		
		public function MyButton(text: String) 
		{
			super();
			
			_labelTextFormat = new TextFormat();
			_labelTextFormat.align = "center";
			_labelTextFormat.font = "Tahoma";
			_labelTextFormat.size = 20;
			_labelTextFormat.color = 0xFFFFFF;
			
			this.graphics.lineStyle(0, 0X820F26, 60, true, "none", "square", "round");
			_matrix.createGradientBox(_width, _height, Math.PI / 2);
			this.graphics.beginGradientFill(GradientType.LINEAR, _colors, _alphas, _ratios, _matrix);
			this.graphics.drawRect(0, 0, _width, _height);
			this.graphics.endFill();

			_label = new TextField();
			_label.x = 0;
			_label.y = 0;
			_label.width = _width;
			_label.height = _height;
			_label.mouseEnabled = false;
			_label.selectable = false;
			_label.name = "stcBtn";
			this.text = text;

			this.buttonMode = true;
			this.useHandCursor = true;
			this.mouseChildren = false;
			
			this.addChild(_label);
			
			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		private function onMouseOver(e:MouseEvent): void
		{
			this.graphics.beginGradientFill(GradientType.LINEAR, _colors2, _alphas, _ratios, _matrix);
			this.graphics.drawRect(0, 0, _width, _height);
			this.graphics.endFill();
		}
		
		private function onMouseOut(e:MouseEvent): void
		{
			this.graphics.beginGradientFill(GradientType.LINEAR, _colors, _alphas, _ratios, _matrix);
			this.graphics.drawRect(0, 0, _width, _height);
			this.graphics.endFill();
		}
		
		public function SetWidth(width:int):void
		{
			this._width = width;
		}
		
		public function SetHeight(height:int):void
		{
			this._height = height;
		}
		
		public function SetPosition(x:int, y:int):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function set text(text:String):void
		{
			_label.text = text;
			_label.setTextFormat(_labelTextFormat);
		}
		
		public function get text():String
		{
			return _label.text;
		}
	}
}