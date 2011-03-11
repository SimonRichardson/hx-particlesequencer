package util;

class Random 
{
	public static inline function generate(min : Float, max : Float) : Float
	{
		return min + (Math.random() * (max - min));
	}
}
