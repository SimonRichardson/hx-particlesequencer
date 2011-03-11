package sequencer;

import flash.display.Shape;
import flash.display.Sprite;
import flash.display.Graphics;
import flash.display.BlendMode;
import flash.events.Event;
import flash.events.MouseEvent;

import util.Random;

class Node extends Sprite 
{
	private inline static var TWO_PI : Float = Math.PI * 2.0;
	
	public var radius : Float;
	public var pulseCut : Float;
	public var colour : UInt;
	public var g : Graphics;
	
	public var octave : Float;
	
	private var _angle : Float;
	private var _speed : Float;
	private var _maxStep : Float;
	
	public var _drag : Sprite;
	public var _graphics : Sprite;
	
	public function new()
	{
		super();
		
		radius = 0.0;
		pulseCut = 0.55;
		colour = 0xFFFFFF;
		
		_angle = Random.generate(0, TWO_PI);
		_speed = Random.generate(0.2, TWO_PI);
		_maxStep = Random.generate(0, Math.PI * 0.15);
		
		_drag = new Sprite();
		_graphics = new Sprite();
		
		colour = Main.COLOURS[Math.floor(Random.generate(0, Main.COLOURS.length))];
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}
	
	public function init() : Void
	{
		g = _graphics.graphics;
		
		x = Random.generate(0, stage.stageWidth);
		y = Random.generate(0, stage.stageHeight);
		
		_graphics.mouseEnabled = false;
		_graphics.mouseChildren = false;
		
		_drag.buttonMode = true;
		_drag.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		
		_drag.graphics.beginFill(0x0, 0);
		_drag.graphics.drawCircle(0, 0, radius + 4);
		_drag.graphics.endFill();
		
		addChild(_graphics);
		addChild(_drag);
	}

	public function pulse(ocatve : Float) : Void
	{
		dispatchEvent(new NodeEvent(NodeEvent.PULSE, ocatve));
	}
	
	public function makePulse() : Shape
	{
		var p : Shape = new Shape();
		p.blendMode = BlendMode.ADD;
		
		p.graphics.clear();
		p.graphics.beginFill(colour);
		p.graphics.drawCircle(0, 0, radius);
		p.graphics.drawCircle(0, 0, radius * pulseCut);
		p.graphics.endFill();
		p.alpha = 0.2;
		
		_graphics.addChildAt(p, 0);
		
		return p;
	}
	
	public function killPulse(p : Shape) : Void
	{
		_graphics.removeChild(p);
		p = null;
	}

	public function draw() : Void
	{
		g.clear();
		g.lineStyle(10, colour, 0.15);
		g.beginFill(colour, 0.8);
		g.drawCircle(0, 0, radius);
		g.endFill();
	}

	public function wander() : Void
	{
		_angle += Random.generate(-_maxStep, _maxStep);
		x += Math.cos(_angle) * _speed;
		y += Math.sin(_angle) * _speed;
		
		var w : Int = stage.stageWidth;
		var h : Int = stage.stageHeight;
		
		x = x < 0 ? w : x > w ? 0 : x;
		y = y < 0 ? h : y > h ? 0 : y;
	}

	public function destroy() : Void
	{
		
	}

	private function onAddedToStage(event : Event) : Void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		init();
	}
	
	private function onMouseDown(event : MouseEvent) : Void 
	{
		startDrag();
		stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
	}

	private function onMouseUp(event : MouseEvent) : Void 
	{
		stopDrag();
		stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
	}
}
