/*
	When the game loads, in order to prevent the menu music bleeding over into the game I make
	the player click a "begin" button before the menu is displayed. This forces an interaction, allowing
	JavaScript to play sounds.

	the menus themselves are all here in one FlxState. They are simply a bunch of different buttons
	grouped together into FlxGroups, which I then hide/display as needed.
*/

package;

import js.html.FileSystem;
import haxe.Json;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.ui.FlxUIButton;
import flixel.group.FlxGroup;
import flixel.system.FlxSound;
import flixel.util.FlxSave;
import io.newgrounds.NG;

class MenuState extends FlxState
{
	var _loginStatusText:FlxText;

	var _musicVolume:Int;
	var _gameVolume:Int;
	var _mainMenu:FlxTypedGroup<FlxUIButton>;
	var _startButton:FlxUIButton;
	var _newgameButton:FlxUIButton;
	var _optionsButton:FlxUIButton;
	var _continueButton:FlxUIButton;
	var _levelsButton:FlxUIButton;

	var _optionsMenu:FlxGroup;
	var _optionsCloseButton:FlxUIButton;
	var _musVolumeText:FlxText; // music volume label
	var _musVolumeDisp:FlxText; // music volume percentage
	var _gVolumeText:FlxText; // label
	var _gVolumeDisp:FlxText; // %
	var _volUpButton:FlxUIButton; // music +
	var _volDownButton:FlxUIButton; // music -
	var _gameVolUp:FlxUIButton; // master +
	var _gameVolDown:FlxUIButton; // master -
	var _fullscreenButton:FlxUIButton;
	// these are grouped because they need a unique graphic
	// also butts is a funny name
	var _pmButts:FlxTypedGroup<FlxUIButton>;

	var _menuMusic:FlxSound;

	var _screenWidth:Float;
	var _screenHeight:Float;
	var _buttonWidth:Float;

	var save:FlxSave;

	override public function create()
	{
		login();
		_screenWidth = FlxG.width;
		_screenHeight = FlxG.height;

		_buttonWidth = _screenWidth - 160;

		//FlxG.autoPause = true;  I think this breaks the music?

		_startButton = new FlxUIButton(0, 0, "begin", clickPlay);
		_startButton.screenCenter();
		add(_startButton);

		// === MAIN MENU CONSTRUCTORS ===
		_newgameButton = new FlxUIButton(_buttonWidth, 0, "New Game", newGame);
		add(_newgameButton);
		
		_continueButton = new FlxUIButton(_buttonWidth, 60, "Continue", continueGame);
		add(_continueButton);

		_levelsButton = new FlxUIButton(_buttonWidth, 120, "Level Select", levelsMenu);
		add(_levelsButton);

		_optionsButton = new FlxUIButton(_buttonWidth, 180, "Options", optionsMenu);
		add(_optionsButton);

		// === MAIN MENU GROUP ===
		_mainMenu = new FlxTypedGroup<FlxUIButton>();
		_mainMenu.add(_newgameButton);
		_mainMenu.add(_continueButton);
		_mainMenu.add(_levelsButton);
		_mainMenu.add(_optionsButton);
		_mainMenu.forEach(loadButtonGraphic);

		// === OPTIONS CONSTRUCTORS ===
		_optionsCloseButton = new FlxUIButton(64, FlxG.height / 2, "Back", closeOptions);
		add(_optionsCloseButton);

		_volUpButton = new FlxUIButton(_buttonWidth, 90, '+', volumeUp);
		add(_volUpButton);

		_volDownButton = new FlxUIButton(_buttonWidth - 32, 90, '-', volumeDown);
		add(_volDownButton);

		_fullscreenButton = new FlxUIButton(_buttonWidth - 46, 180, "Fullscreen", fullscreenToggle);
		add(_fullscreenButton);

		_gameVolUp = new FlxUIButton(_buttonWidth, 122, '+', gameVolUp);
		add(_gameVolUp);

		_gameVolDown = new FlxUIButton(_buttonWidth - 32, 122, '-', gameVolDown);
		add(_gameVolDown);

		_musVolumeText = new FlxText(_volUpButton.x - 200, _volUpButton.y + 8, 128, "Music volume", 12);
		add(_musVolumeText);

		_musVolumeDisp = new FlxText(_musVolumeText.x + 128, _musVolumeText.y, 64, "oops!", 12);
		add(_musVolumeDisp);

		_gVolumeText = new FlxText(_gameVolUp.x - 200, _gameVolUp.y + 8, 128, "Master volume", 12);
		add(_gVolumeText);

		_gVolumeDisp = new FlxText(_gVolumeText.x + 128, _gVolumeText.y, 64, "oops!", 12);
		add(_gVolumeDisp);

		// === OPTIONS MENU GROUP ===
		_optionsMenu = new FlxGroup();
		_optionsMenu.add(_optionsCloseButton);
		_optionsMenu.add(_volUpButton);
		_optionsMenu.add(_volDownButton);
		_optionsMenu.add(_gameVolDown);
		_optionsMenu.add(_gameVolUp);
		_optionsMenu.add(_fullscreenButton);
		_optionsMenu.add(_musVolumeText);
		_optionsMenu.add(_gVolumeText);
		_optionsMenu.add(_musVolumeDisp);
		_optionsMenu.add(_gVolumeDisp);

		_pmButts = new FlxTypedGroup<FlxUIButton>();
		_pmButts.add(_volUpButton);
		_pmButts.add(_volDownButton);
		_pmButts.add(_gameVolUp);
		_pmButts.add(_gameVolDown);
		_pmButts.forEach(loadSmallGraphics);

		_mainMenu.forEach(hideButton);
		_optionsMenu.forEach(hideButton);

		_menuMusic = FlxG.sound.load("assets/music/menu.mp3", 1, // volume
			true, // looped
			null, // group
			false // , // destroy when finished
			// true); // autoplay
		);

		FlxG.sound.music = _menuMusic;
		FlxG.sound.music.play();

		save = new FlxSave();
		save.bind("exterminationVolumes");

		// LOAD STUFF FROM SAVED DATA
		if(save.data.musicVolume != null){
			FlxG.sound.music.volume = save.data.musicVolume;
		}

		if(save.data.gameVolume != null){
			FlxG.sound.volume = save.data.gameVolume;
		}
		
		updateVolumeMus(); updateVolGame();

		super.create();
	}

	function login(){
		_loginStatusText = new FlxText();
		_loginStatusText.text = "Logging in...";
		add(_loginStatusText);
		var api_key:String = haxe.Resource.getString("api_key");
		
		NG.create(api_key);
		
		if(!NG.core.loggedIn){
			_loginStatusText.text = "You are not currently logged in to Newgrounds. This is not mandatory, but it excludes you from stuff like high-scores and medals. Click the login button to fix this.";
			NG.core.requestLogin(()->{
				_loginStatusText.text = "Logged in!";
			});
		}
	}

	// called in a loop
	function hideButton(button:FlxBasic){
		button.visible = false;
	}

	// called in a loop
	function showButton(button:FlxBasic){
		button.visible = true;
	}

	// displays the main menu
	function clickPlay(){
		_startButton.visible = false;
		_mainMenu.forEach(showButton);
	}

	// switches to PlayState.hx
	function newGame(){
		save.close();
		FlxG.sound.music.pause();
		FlxG.switchState(new PlayState());
	}

	// hides main menu and displays the options menu
	function optionsMenu(){
		_mainMenu.forEach(hideButton);
		_optionsMenu.forEach(showButton);
	}

	// hides options menu and displays the main menu
	function closeOptions(){
		_optionsMenu.forEach(hideButton);
		_mainMenu.forEach(showButton);
	}

	function continueGame(){
		// this doesn't do anything right now
	}

	function levelsMenu(){
		// this doesn't do anything right now
	}

	function volumeUp(){
		FlxG.sound.music.volume += 0.1;
		save.data.musicVolume = FlxG.sound.music.volume;
		updateVolumeMus();
	}

	function volumeDown(){
		FlxG.sound.music.volume -= 0.1;
		save.data.musicVolume = FlxG.sound.music.volume;
		updateVolumeMus();
	}

	// assigns the graphic to use for the main menu buttons
	function loadButtonGraphic(button:FlxUIButton){
		//button.loadGraphic("assets/images/ui/bloodbutton.png");
		button.loadGraphicsUpOverDown("assets/images/ui/bloodFrames.png");
		button.label.offset.set(25, -25);
		button.label.color = FlxColor.WHITE; // vscode says this doesn't do anything and grays it, but it works.
	}

	// loads the graphics for the + and - buttons in the options menu
	function loadSmallGraphics(button:FlxUIButton){
		//button.setGraphicSize(32,32);
		button.loadGraphicsUpOverDown("assets/images/ui/buttonframes.png");
		//button.loadGraphic("assets/images/ui/buttonSmall.png");
		button.label.offset.set(0, -6);
		button.label.color = FlxColor.WHITE; // vscode says this doesn't do anything and grays it, but it works.
	}

	function fullscreenToggle(){
		FlxG.fullscreen = !FlxG.fullscreen;
		FlxG.fullscreen ? _fullscreenButton.label.text="Fullscreen't" : _fullscreenButton.label.text="Fullscreen";
	}

	function gameVolUp(){
		FlxG.sound.volume += 0.1;
		save.data.gameVolume = FlxG.sound.volume;
		updateVolGame();
	}

	function gameVolDown(){
		FlxG.sound.volume -= 0.1;
		save.data.gameVolume = FlxG.sound.volume;
		updateVolGame();
	}


	// these two functions grab the value of FlxG.sound's music and global volumes, then round their floating points away and multiply their values by 100 so you get 10%, 20%, etc
	function updateVolumeMus(){
		_musVolumeDisp.text = Math.round(FlxG.sound.music.volume * 100) + '%';
	}

	function updateVolGame(){
		_gVolumeDisp.text = Math.round(FlxG.sound.volume * 100) + '%';
	}
}
