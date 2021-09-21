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
		img.x -= 640;
		img.y -= 640;
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

		var ratio:Float = this._width / 1280; // This allows us to scale assets depending on the size of the screen.

		logo = new Sprite();
		logo.addChild(new Bitmap(new LogoImage(0, 0)));
		logo.scaleX = logo.scaleY = ratio;

		_bg = new BGsprite();
		_bg.img.scaleX = _bg.img.scaleY = ratio;
		_bg.offset(this._width, this._height);
		_bg.x = 640;
		_bg.y = 640;
		// _bg.x = (this._width / 2) - (_bg.img.width / 2);
		// _bg.y = (this._height / 2) - (_bg.img.height / 2);

		// logo.x = ((this._width) / 2) - ((logo.width) / 2);
		// logo.y = (this._height / 2) - ((logo.height) / 2);

		/*Font.registerFont(NGfont);
			text = new TextField();
			text.defaultTextFormat = new TextFormat("TekutekuAL", Std.int(24 * ratio), 0xffffff, false, false, false, "", "", TextFormatAlign.CENTER);
			text.text = "Loading...";
			addChild(text); */

		addChild(_bg);
		// addChild(_bg.img);

		addChild(logo);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		_bg.rotation += 1;
	}
}
