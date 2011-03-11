package sequencer;

import flash.Vector;
import flash.display.Sprite;
import flash.events.Event;
import flash.utils.TypedDictionary;

class World extends Sprite 
{
	private var _neurons : Vector<Neuron>;
	private var _synapses : Vector<Synapse>;
	private var _receptors : Vector<Receptor>;
	private var _connections : TypedDictionary<Node, TypedDictionary<Receptor, Synapse>>;
	private var _voice : Voice;

	private var _numNeurons : Int;
	private var _numReceptors : Int;
	
	public var numNeurons(getNumNeurons, setNumNeurons) : Int;
	public var numReceptors(getNumReceptors, setNumReceptors) : Int;

	public function new()
	{
		super();
		
		_neurons = new Vector<Neuron>();
		_synapses = new Vector<Synapse>();
		_receptors = new Vector<Receptor>();
		_connections = new TypedDictionary<Node, TypedDictionary<Receptor, Synapse>>();
		_voice = new Voice();
		
		numNeurons = Main.NUM_NEURONS;
		numReceptors = Main.NUM_RECEPTORS;
		
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}

	public function update() : Void
	{
		var i : Int, j : Int;
		var dx : Float, dy : Float, dSq : Float;
		var n : Neuron, r : Receptor, s : Synapse;
		
		var nc : Int = _neurons.length;
		var rc : Int = _receptors.length;
		
		for(i in 0...nc)
		{
			n = _neurons[i];
			
			for(j in 0...rc)
			{
				r = _receptors[j];
				
				dx = r.x - n.x;
				dy = r.y - n.y;
				dSq = dx * dx + dy * dy;
				
				var vs : TypedDictionary<Receptor, Synapse> = _connections.get(n);
				
				if(dSq <= Main.MIN_PROXIMITY_SQ)
				{
					// connect
					if(vs.get(r) == null)
					{
						s = new Synapse(n, r);
						addChildAt(s, 0);
						
						vs.set(r, s);
						_synapses.push(s);
					}
				}
				else
				{
					// disconnect
					if(vs.get(r) != null)
					{
						s = vs.get(r);
						removeChild(s);
						
						vs.delete(r);
						_synapses.splice(_synapses.indexOf(s), 1);
						
						s.destroy();
						s = null;
					}
				}
			}
		}
		
		var sc : Int = _synapses.length;
		for(i in 0...sc)
		{
			s = _synapses[i];
			
			if(s.input.parent != null && s.output.parent != null)
			{
				s.draw();
			}
			else
			{
				_synapses.splice(i, 1);
				removeChild(s);
				s.destroy();
				s = null;
			}
		}
		
		// render
		nc = _neurons.length;
		for(i in 0...nc)
		{
			_neurons[i].draw();
		}
		rc = _receptors.length;
		for(i in 0...nc)
		{
			_receptors[i].draw();
		}
	}

	private function onEnterFrame(event : Event) : Void 
	{
		update();
	}

	private function onNeuronFired(event : NodeEvent) : Void 
	{
		if(Std.is(event.target, Neuron))
		{
			var n : Neuron = cast(event.target, Neuron);
			var synapsis : TypedDictionary<Receptor, Synapse> = _connections.get(n);
			for(i in synapsis)
			{
				synapsis.get(i).fire();
			}
		}
	}
	
	private function onReceptorPulse(event : NodeEvent) : Void 
	{
		if(Std.is(event.target, Receptor))
		{
			var r : Receptor = cast(event.target, Receptor);
			_voice.queue(Math.floor(r.note + (event.octave * 10)));
		}
	}

	//	----------------------------------------------------------------
	//	MUTATORS
	//	----------------------------------------------------------------

	public function getNumNeurons() : Int
	{
		return _numNeurons;
	}

	public function setNumNeurons(value : Int) : Int
	{
		var n : Neuron;
		
		if(_numNeurons < value)
		{
			while(_numNeurons < value)
			{
				n = new Neuron();
				n.addEventListener(NodeEvent.PULSE, onNeuronFired);
				addChild(n);
			
				_connections.set(n, new TypedDictionary<Receptor, Synapse>());
				_neurons.push(n);
			
				++_numNeurons;
			}
		}
		else if(_numNeurons > value)
		{
			while(_numNeurons > value)
			{
				n = _neurons.pop();
				n.removeEventListener(NodeEvent.PULSE, onNeuronFired);
				removeChild(n);
				
				_connections.delete(n);
				
				n.destroy();
				n = null;
				
				--_numNeurons;
			}
		}
		
		return _numNeurons;
	}

	public function getNumReceptors() : Int
	{
		return _numReceptors;
	}

	public function setNumReceptors(value : Int) : Int
	{
		var r : Receptor;
		
		if(_numReceptors < value)
		{
			while(_numReceptors < value)
			{
				r = new Receptor();
				r.addEventListener(NodeEvent.PULSE, onReceptorPulse);
				addChild(r);
				
				_receptors.push(r);
				++_numReceptors;
			}
		}
		else if(_numReceptors > value)
		{
			while(_numReceptors > value)
			{
				r = _receptors.pop();
				r.removeEventListener(NodeEvent.PULSE, onReceptorPulse);
				removeChild(r);
				r.destroy();
				r = null;
				
				--_numReceptors;
			}
		}
		
		return _numReceptors;
	}
}
