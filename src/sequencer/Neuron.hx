package sequencer;

import util.Random;

import flash.display.Shape;
import flash.display.BlendMode;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;

class Neuron extends Node 
{
	private static var COUNT : UInt = 0;
	
	private var _timer : Timer;
	
	private var _inner : Shape;
	private var _outer : Shape;
	
	private var _pulse : Shape;
	
	private var _lifeTimer : Timer;
	
	public function new()
	{
		super();
		
		radius = 30;
		
		_inner = new Shape();

		_outer = new Shape();
		_outer.blendMode = BlendMode.ADD;
		
		_graphics.addChild(_outer);
		_graphics.addChild(_inner);
	}
	
	override public function init() : Void 
	{
		super.init();
		
		octave = (COUNT++) % 3;
		
		_timer = new Timer(Random.generate(600, 1200));
		_timer.addEventListener(TimerEvent.TIMER, onTimer);
		_timer.start();
		
		_lifeTimer = new Timer(200, 1);
		_lifeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, handleTimerComplete);
		
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}

	private function onEnterFrame(event : Event) : Void 
	{
		wander();
	}

	override public function pulse(octave : Float) : Void 
	{
		super.pulse(octave);
		
		_lifeTimer.reset();
		
		_pulse = makePulse();
		
		_lifeTimer.start();
	}
	
	override public function draw() : Void 
	{
		var len : Int = 7;
		
		_inner.graphics.clear();
		_inner.graphics.lineStyle(3, colour);
		_inner.graphics.moveTo(-len, 0);
		_inner.graphics.lineTo(len, 0);
		_inner.graphics.moveTo(0, -len);
		_inner.graphics.lineTo(0, len);
		
		_outer.graphics.clear();
		_outer.graphics.lineStyle(10, colour, 0.15);
		_outer.graphics.beginFill(colour, 0.8);
		_outer.graphics.drawCircle(0, 0, radius);
		_outer.graphics.endFill();
	}
	
	private function handleTimerComplete(event : TimerEvent) : Void
	{
		if(_pulse!=null)
		{
			killPulse(_pulse);
		}
	}
	
	override public function destroy() : Void 
	{
		super.destroy();
		
		_timer.stop();
		_timer.removeEventListener(TimerEvent.TIMER, onTimer);
		_timer = null;
		
		_lifeTimer.stop();
		_lifeTimer.removeEventListener(TimerEvent.TIMER, handleTimerComplete);
		_lifeTimer = null;
		
		removeEventListener(Event.ENTER_FRAME, onEnterFrame);
	}

	private function onTimer(event : TimerEvent) : Void 
	{
		pulse(5);
	}
}
