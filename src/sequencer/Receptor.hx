package sequencer;

import util.Random;

import flash.display.Shape;
import flash.display.BlendMode;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;


class Receptor extends Node 
{
	private static var SCALE : Array<Int> = [0,2,5,7,9,12,14,17];
	
	private static inline var OCTAVE : Int = 19;

	public var note : Int;
	
	private var _pulse : Shape;
	
	private var _lifeTimer : Timer;

	public function new()
	{
		super();
		
		note = SCALE[Math.floor(Random.generate(0, SCALE.length))];
				
		blendMode = BlendMode.ADD;
		radius = 20 - ((note / 19) * 15);
		
		note += (OCTAVE * 3);
		
		_lifeTimer = new Timer(200, 1);
		_lifeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, handleTimerComplete);
	}

	override public function init() : Void 
	{
		super.init();
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	override public function pulse(octave : Float) : Void 
	{
		super.pulse(octave);
		
		_lifeTimer.reset();
		
		_pulse = makePulse();
		
		_lifeTimer.start();
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
		
		_lifeTimer.stop();
		_lifeTimer.removeEventListener(TimerEvent.TIMER, handleTimerComplete);
		_lifeTimer = null;
		
		removeEventListener(Event.ENTER_FRAME, onEnterFrame);
	}

	private function onEnterFrame(event : Event) : Void 
	{
		wander();
	}
}
