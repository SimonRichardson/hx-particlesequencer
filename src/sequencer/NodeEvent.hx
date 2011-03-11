package sequencer;

import flash.events.Event;

class NodeEvent extends Event 
{
	public static inline var PULSE : String = "pulse";
	
	public var octave : Float;
	
	public function new(type : String, octave : Float)
	{
		super(type, false, false);
		this.octave = octave;
	}

	override public function clone() : Event 
	{
		return new NodeEvent(type, octave);
	}
}
