package sequencer;

import flash.display.Shape;
import flash.display.Sprite;
import flash.display.Graphics;
import flash.display.BlendMode;
import flash.events.TimerEvent;
import flash.utils.Timer;

class Synapse extends Sprite 
{
	public var input : Node;
	public var output : Node;
	
	private var _timer : Timer;
	
	public function new(input : Node, output : Node)
	{
		super();
		
		this.input = input;
		this.output = output;
		mouseEnabled = mouseChildren = false;
		
		blendMode = BlendMode.ADD;
		
		_timer = new Timer(100, 1);
		_timer.addEventListener(TimerEvent.TIMER_COMPLETE, handleTimerComplete);
	}

	public function fire() : Void
	{
		var dx : Float = output.x - input.x;
		var dy : Float = output.y - input.y;
		var len : Float = Math.sqrt(dx * dx + dy * dy);
		
		_timer.reset();
		_timer.delay = Math.floor(len * 5);
		_timer.start();
	}
	
	private function handleTimerComplete(event : TimerEvent) : Void
	{
		pulse(input.octave);
	}
	
	private function pulse(octave : Float) : Void
	{
		output.pulse(octave);
	}

	public function draw() : Void
	{
		graphics.clear();
		
		var dx : Float = output.x - input.x;
		var dy : Float = output.y - input.y;
		var dSq : Float = dx * dx + dy * dy;
		alpha = 1 - (dSq / Main.MIN_PROXIMITY_SQ);
		
		graphics.lineStyle(12, 0xFFFFFF, 0.1);
		graphics.moveTo(input.x, input.y);
		graphics.lineTo(output.x, output.y);
		
		graphics.lineStyle(1, 0xFFFFFF, 0.4);
		graphics.moveTo(input.x, input.y);
		graphics.lineTo(output.x, output.y);
		
		graphics.beginFill(0xFFFFFF, 0.6);
		graphics.drawCircle(input.x, input.y, 2);
		graphics.endFill();
		
		graphics.beginFill(0xFFFFFF, 0.6);
		graphics.drawCircle(output.x, output.y, 2);
		graphics.endFill();
	}

	public function destroy() : Void
	{
		if(_timer != null)
		{
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, handleTimerComplete);
			_timer.stop();
			_timer = null;
		}
	}
}
