package;

import flixel.system.FlxBasePreloader;
import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;

@:bitmap("assets/images/ui/tankman.png") class LogoImage extends BitmapData {}
@:bitmap("assets/images/ui/preloaderbg.png") class BgImage extends BitmapData {}

class BGsprite extends Sprite
{
	public var img:Sprite;

	public function new()
	{
		super();

		img = new Sprite();

		img.addChild(new Bitmap(new BgImage(0, 0)));

		addChild(img);
	}

	public function offset(_x:Float, _y:Float)
	{
		img.x -= 1280;
		img.y -= 1280;
	}
}

class NewgroundsPreloader extends FlxBasePreloader
{
	public function new(MinDisplayTime:Float = 0, ?AllowedURLs:Array<String>)
	{
		super(MinDisplayTime, AllowedURLs);
	}

	var logo:Sprite;
	var _bg:BGsprite;

	override public function create()
	{
		super.create();
		this._width = Lib.current.stage.stageWidth;
		this._height = Lib.current.stage.stageHeight;

		var ratio:Float = this._width / 1280;

		logo = new Sprite();
		logo.addChild(new Bitmap(new LogoImage(0, 0)));
		logo.scaleX = logo.scaleY = ratio;

		_bg = new BGsprite();
		_bg.img.scaleX = _bg.img.scaleY = ratio * 2;
		_bg.offset(this._width, this._height);
		_bg.x = 640;
		_bg.y = 640;

		addChild(_bg);
		addChild(logo);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		_bg.rotation += 1;
	}
}
