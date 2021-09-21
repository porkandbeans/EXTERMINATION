package;

import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.Lib;
import openfl.display.BitmapData;
import flixel.FlxSprite;
import flixel.system.FlxBasePreloader;

@:bitmap("assets/images/ui/tankman.png") class LogoImage extends BitmapData {}
@:bitmap("assets/images/ui/preloaderbg.png") class BgImage extends BitmapData {}

class NewgroundsPreloader extends FlxBasePreloader
{
	public function new(MinDisplayTime:Float = 0, ?AllowedURLs:Array<String>)
	{
		super(MinDisplayTime, AllowedURLs);
	}

	var logo:Sprite;
	var bg:Sprite;

	override public function create()
	{
		this._width = Lib.current.stage.stageWidth;
		this._height = Lib.current.stage.stageHeight;

		var ratio:Float = this._width / 1280; // This allows us to scale assets depending on the size of the screen.

		logo = new Sprite();
		logo.addChild(new Bitmap(new LogoImage(0, 0)));
		logo.scaleX = logo.scaleY = ratio;

		bg = new Sprite();
		bg.addChild(new Bitmap(new BgImage(0, 0)));
		bg.scaleX = bg.scaleY = ratio;
		// logo.x = ((this._width) / 2) - ((logo.width) / 2);
		// logo.y = (this._height / 2) - ((logo.height) / 2);
		addChild(bg);
		addChild(logo);

		super.create();
	}
}