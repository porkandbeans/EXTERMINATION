package;

import npcs.Pedestrian;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.display.FlxBackdrop;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.tile.FlxTilemap;

class PlayState extends FlxState
{
	var _map:FlxOgmo3Loader;
	var _tilemap:FlxTilemap;
	var _player:Player;
	var _hud:HUD;
	var _backdrop:FlxBackdrop;
	var _peds:FlxTypedGroup<Pedestrian>;
	
	override public function create()
	{
		_backdrop = new FlxBackdrop("assets/images/Backgrounds/backdrop.png", 0.5, 0.5, true, 0, 0);
		add(_backdrop);

		_map = new FlxOgmo3Loader(
			"assets/levels/hworld.ogmo", 
			"assets/levels/NewLevel0.json");
		_tilemap = _map.loadTilemap("assets/data/tilewall.png", "walls");
		_tilemap.follow();
		_tilemap.setTileProperties(1, FlxObject.NONE);
		_tilemap.setTileProperties(2, FlxObject.ANY);
		add(_tilemap);
		_peds = new FlxTypedGroup<Pedestrian>();
		add(_peds);
		_player = new Player();
		_map.loadEntities(placeEntities, "entities");
		_player.declarePeds(_peds);
		add(_player);
		
		_hud = new HUD();
		add(_hud);

		super.create();
	}

	function placeEntities(entity:EntityData){
		switch(entity.name){
			case "player":
				_player.setPosition(entity.x, entity.y);
			case "NPC":
				_peds.add(new Pedestrian(entity.x - 16, entity.y -16));
		}
	}

	override public function update(elapsed:Float){
		collisions();
		FlxG.camera.follow(_player, PLATFORMER, 1);
		super.update(elapsed);
	}

	function collisions(){
		FlxG.collide(_tilemap, _player);
		FlxG.collide(_peds, _tilemap);
	}
}
