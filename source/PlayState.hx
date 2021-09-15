package;

import npcs.NPC;
import npcs.Ped01;
import npcs.Cop;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import guns.Bullet;
import pickups.Pickup;
import pickups.ammo.PistolAmmo;
import pickups.ammo.RifleAmmo;
import pickups.guns.PistolPickup;
import pickups.guns.RiflePickup;

class PlayState extends FlxState
{
	// === PRIVATE VARS ===
	// it has actually just occurred to me that there aren't actually going to be any public vars
	// because this is where everything happens.
	// I'm still going to keep the underscore naming convention as I find
	// it helps to distinguish between the vars that I made and which are inherited
	var _map:FlxOgmo3Loader;
	var _tilemap:FlxTilemap;
	var _player:Player;
	var _hud:HUD;
	var _backdrop:FlxBackdrop;
	var _npcs:FlxTypedGroup<Ped01>;
	var _cops:FlxTypedGroup<Cop>;
	var _pistolBullets:FlxTypedGroup<Bullet>;
	var _rifleBullets:FlxTypedGroup<Bullet>;

	// pickups
	var _pistolAmmo:FlxTypedGroup<PistolAmmo>;
	var _rifleAmmo:FlxTypedGroup<RifleAmmo>;
	var _rifles:FlxTypedGroup<RiflePickup>;
	var _pistols:FlxTypedGroup<PistolPickup>;

	// helper groups
	var _objects:FlxGroup;
	var _pickups:FlxGroup;
	var _bullets:FlxGroup;

	override public function create()
	{
		// set the background image
		_backdrop = new FlxBackdrop("assets/images/Backgrounds/backdrop.png", 0.5, 0.5, true, 0, 0);

		// load the level data
		_map = new FlxOgmo3Loader("assets/levels/hworld.ogmo", "assets/levels/NewLevel0.json");
		_tilemap = _map.loadTilemap("assets/data/tilewall.png", "walls");
		_tilemap.follow();

		// declare which blocks are solid and collide with stuff
		_tilemap.setTileProperties(1, FlxObject.NONE);
		_tilemap.setTileProperties(2, FlxObject.ANY);

		// === ACTORS ===
		_npcs = new FlxTypedGroup<Ped01>();
		_cops = new FlxTypedGroup<Cop>();
		_player = new Player();

		// === PICKUP DECLARATIONS ===
		_pistolBullets = new FlxTypedGroup<Bullet>(20);
		_rifleBullets = new FlxTypedGroup<Bullet>(12);

		// === GUN STUFF ===
		_player.declareBullets(_pistolBullets, _rifleBullets); // the player needs these for his weapon classes
		_pistolAmmo = new FlxTypedGroup<PistolAmmo>();
		_rifleAmmo = new FlxTypedGroup<RifleAmmo>();
		_rifles = new FlxTypedGroup<RiflePickup>();
		_pistols = new FlxTypedGroup<PistolPickup>();

		// === HEADS-UP DISPLAY ===
		_hud = new HUD();
		_player.hud = _hud;
		_player.updateHUD();

		// === OBJECTS GROUP
		_objects = new FlxGroup();
		_objects.add(_player);
		_objects.add(_pistolBullets);
		_objects.add(_rifleBullets);
		_objects.add(_tilemap);
		_objects.add(_npcs);
		_objects.add(_cops);

		// === PICKUPS GROUP ===
		_pickups = new FlxGroup();
		_pickups.add(_pistolAmmo);
		_pickups.add(_rifleAmmo);
		_pickups.add(_rifles);
		_pickups.add(_pistols);

		// === BULLETS GROUP ===
		_bullets = new FlxGroup();
		_bullets.add(_pistolBullets);
		_bullets.add(_rifleBullets);

		_map.loadEntities(placeEntities, "entities");
		var _addthese = new Array<FlxBasic>();
		
		_addthese = [
			_backdrop, _tilemap, _npcs, _cops, _player, _pistolBullets,
			_rifleBullets, _hud, _pistolAmmo, _rifleAmmo, _rifles, _pistols,
			_player.hitreg
		];

		for(item in _addthese){
			add(item);
		}

		super.create();
	}

	function placeEntities(entity:EntityData)
	{
		switch (entity.name)
		{
			case "player":
				_player.setPosition(entity.x, entity.y);
			case "NPC":
				_npcs.add(new Ped01(entity.x - 16, entity.y - 16));
			case "cop":
				_cops.add(new Cop(entity.x - 16, entity.y - 16));
			case "pistolammo":
				_pistolAmmo.add(new PistolAmmo(entity.x, entity.y - 4));
			case "rifleammo":
				_rifleAmmo.add(new RifleAmmo(entity.x, entity.y - 4));
			case "rifle":
				_rifles.add(new RiflePickup(entity.x, entity.y));
			case "pistol":
				_pistols.add(new PistolPickup(entity.x, entity.y));
		}
	}

	override public function update(elapsed:Float)
	{
		collisions();
		pauseListen();
		FlxG.camera.follow(_player, PLATFORMER, 1);
		super.update(elapsed);
	}

	// === PAUSE THE GAME ===
	function pauseListen(){
		if(FlxG.keys.justPressed.P){
			_objects.forEach((obj:FlxBasic) -> {
				obj.active = !obj.active;
			});
			_hud.pauseGame();
		}
	}
	function collisions()
	{
		FlxG.collide(_objects, _tilemap, objectCollide);
		FlxG.overlap(_npcs, _player.hitreg, npcStab);
		FlxG.overlap(_npcs, _rifleBullets, riflenpcShot); // check for rifle shots first
		FlxG.overlap(_cops, _rifleBullets, riflenpcShot); // as the pistol bullets will override
		FlxG.overlap(_npcs, _bullets, npcShot);
		FlxG.overlap(_cops, _bullets, npcShot);
		FlxG.overlap(_player, _pickups, pickupItem);
	}

	// callback when NPCs are shot
	function npcShot(sprite1:NPC, sprite2:FlxObject)
	{
		if (sprite1.health > 0)
		{
			sprite2.kill();
			sprite1.getStabbed();
		}
	}

	function npcStab(sprite1:NPC, sprite2:FlxObject){
		sprite2.active?sprite1.getStabbed():return;
	}

	// unique callback for penetrating shots
	// difference is, the bullet doesn't get killed
	function riflenpcShot(sprite1:NPC, sprite2:Bullet)
	{
		if (sprite1.health > 0)
		{
			sprite1.getStabbed();
		}
	}

	function bulletWall(obj1:FlxObject, tmap:FlxTilemap)
	{
		// specifically kills bullets on impact with world boundaries
		obj1.kill();
	}

	function objectCollide(obj1:FlxObject, tmap:FlxTilemap){
		if((obj1 is Bullet)){
			obj1.kill();
		}
	}

	function pickupItem(player:Player, item:Pickup)
	{
		item.get(player);
		player.updateHUD();
	}
}
