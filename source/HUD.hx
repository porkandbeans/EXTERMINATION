package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;

class HUD extends FlxTypedGroup<FlxSprite>
{
	var _healthBar:FlxBar;
	var _health:Float;
	var _pistolAmmo:Int;
	var _current_wep:Int;

	var _ammoText:FlxText;
	var _gun:FlxText;

	var _pauseTxt:FlxText;
	var _pauseSound:FlxSound;

	var _dialogueWindow:TextWindow;

	public function new()
	{
		super();

		_current_wep = 0;
		_gun = new FlxText(0, 2, 0, "0", 8);
		add(_gun);

		_ammoText = new FlxText(FlxG.width - 20, 0, 20, "0", 8);
		add(_ammoText);

		_pauseTxt = new FlxText(FlxG.width / 2, FlxG.height / 2, 0, "PAUSE", 20);
		_pauseTxt.screenCenter();
		add(_pauseTxt);
		_pauseTxt.visible = false;

		_pauseSound = FlxG.sound.load("assets/sounds/sound_effects/ui/pause.wav");

		_healthBar = new FlxBar(10, 15, LEFT_TO_RIGHT, 200, 20, null, "_health", 0, 20, true);
		_healthBar.createFilledBar(null, FlxColor.GREEN, true, FlxColor.BLACK);
		_healthBar.alpha = 0;
		add(_healthBar);

		_dialogueWindow = new TextWindow(10, FlxG.height - 110);
		add(_dialogueWindow);
		add(_dialogueWindow._textSprite);

		_dialogueWindow.visible = false;
		_dialogueWindow._textSprite.visible = false;

		forEach(function(sprite)
		{ // ???????
			sprite.scrollFactor.set(0, 0);
		}); // ¯\_(ツ)_/¯ if it works, it works.*/
	}

	public function updateBar(x:Float)
	{
		_healthBar.value = x;

		if (_health < 20)
		{
			FlxTween.tween(_healthBar, {alpha: 1}, 0.33);
		}
		else
		{
			FlxTween.tween(_healthBar, {alpha: 0}, 0.33);
		}
	}

	public function updateGun(gun:Int, ammo:Int)
	{
		_current_wep = gun;
		switch (_current_wep)
		{
			case 0:
				_gun.text = "Knife";
				_ammoText.visible = false;
				return;
			case 1:
				_gun.text = "Pistol";
				_ammoText.visible = true;
				_ammoText.text = Std.string(ammo);
				return;
			case 2:
				_gun.text = "Rifle";
				_ammoText.visible = true;
				_ammoText.text = Std.string(ammo);
				return;
		}
	}

	public function pauseGame()
	{
		_pauseTxt.visible = !_pauseTxt.visible;
		_pauseSound.play(true);
	}
	public function showDialogue(strings:Array<String>)
	{
		_dialogueWindow.visible = true;
		_dialogueWindow._textSprite.visible = true;
		_dialogueWindow.setText(strings);
	}

	public function getDialogueState():Bool
	{
		return _dialogueWindow.visible;
	}
}

class TextWindow extends FlxSprite
{
	var _strings:Array<String>;

	public var _textSprite:FlxText;

	var currentString:Int = 0;

	public function setText(strings:Array<String>)
	{
		_strings = strings;
		_textSprite.text = strings[0];
	}

	public function new(x:Float, y:Float)
	{
		super(x, y);
		makeGraphic(FlxG.width - 20, 100, FlxColor.BLACK);
		_textSprite = new FlxText(x, y, this.width);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		if (FlxG.keys.anyJustPressed([SPACE]) && visible) // if the dialogue window is currently visible and player just pressed spacebar
		{
			currentString++;
			if (_strings[currentString] != null)
			{
				_textSprite.text = _strings[currentString];
			}
			else
			{
				visible = false;
				_textSprite.visible = false;
				currentString = 0;
			}
		}
	}
}
