package ;

import flash.Lib;
import flash.display.Sprite;
import flash.display.Shape;
import flash.display.BitmapData;

import tonfall.display.AbstractApplication;

import sequencer.World;

class Main extends AbstractApplication 
{
	
	public static inline var NUM_NEURONS : Int = 10;
	
	public static inline var MAX_NEURONS : Int = 12;
		
	public static inline var NUM_RECEPTORS : Int = 30;
	
	public static inline var MAX_RECEPTORS : Int = 40;
	
	public static inline var COLOURS : Array<UInt> = [0xb1d25d, 0xe15249, 0x8cd9b2, 0x008a8e, 0xa6ad8f, 0x00ddd5, 0xff7659, 0xf9fb41, 0x41dafb, 0xd879ff];
	
	public static inline var MIN_PROXIMITY : Int = 160;
	
	public static inline var MIN_PROXIMITY_SQ : Int = MIN_PROXIMITY * MIN_PROXIMITY;
	
	public var texture : Shape;
	
	public function new()
	{
		super();
		
		addChild(new World());
		
		texture = new Shape();
		addChild(texture);
		
		//showSpectrum = true;
	}
	
	public static function main() 
	{
		Lib.current.addChild(new Main());
	}
	
	override public function resize() : Void
	{
		var bitmapData : BitmapData = new BitmapData(2, 2, true, 0x0);
		bitmapData.setPixel32(0, 0, 0x33000000);
		
		texture.graphics.clear();
		texture.graphics.beginBitmapFill(bitmapData);
		texture.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
		texture.graphics.endFill();
	}
}
