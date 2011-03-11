package sequencer;

import flash.Vector;

import tonfall.core.BlockInfo;
import tonfall.core.Processor;
import tonfall.core.Engine;
import tonfall.core.TimeConversion;
import tonfall.core.TimeEventNote;
import tonfall.poly.PolySynth;
import tonfall.poly.simple.SimplePolySynthVoiceFactory;
import tonfall.effects.Delay;

class Voice extends Processor 
{
	private var _generator : PolySynth;
	private var _delay : Delay;
	private var _queue : Vector<Int>;

	public function new()
	{
		super();
		
		_generator = new PolySynth(SimplePolySynthVoiceFactory.INSTANCE);
		_delay = new Delay(Math.floor(TimeConversion.barsToMillis(3.0 / 16.0, Engine.getInstance().bpm)));
		_queue = new Vector<Int>();
		
		engine.processors.push(this);
		engine.processors.push(_generator);
		engine.processors.push(_delay);

		_delay.input = _generator.output;
		engine.input = _delay.output;
	}

	public function queue(note : Int) : Void
	{
		_queue.push(note);
	}

	override public function process(info : BlockInfo) : Void 
	{
		var index : Int = Math.floor(info.barFrom * 16.0);
		var position : Float = index / 16.0;
	
		while( position < info.barTo )
		{
			if( position >= info.barFrom )
			{
				var n = _queue.length;
				for(i in 0...n)
				{
					var event : TimeEventNote = new TimeEventNote();
				
					event.barPosition = position;
					event.note = _queue[i];
					event.barDuration = 1.0 / 16.0;
					_generator.addTimeEvent(event);
				}
			
				_queue.length = 0;
			}

			position += 1.0 / 16.0;
			++index;
		}
	}
}
