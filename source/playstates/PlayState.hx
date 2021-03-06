package playstates;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import guns.Bullet;
import guns.Sawblade;
import guns.SawbladeSpawner;
import npcs.Cop;
import npcs.NPC;
import npcs.Ped01;
import objects.Crate;
import objects.Levelgoal;
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
	var _levelPath:String;
	var _sawBlade:Bullet;

	// pickups
	var _pistolAmmo:FlxTypedGroup<PistolAmmo>;
	var _rifleAmmo:FlxTypedGroup<RifleAmmo>;
	var _rifles:FlxTypedGroup<RiflePickup>;
	var _pistols:FlxTypedGroup<PistolPickup>;

	// helper groups
	var _objects:FlxGroup;
	var _pickups:FlxGroup;
	var _bullets:FlxGroup;
	var _copBullets:FlxGroup;
	var _sawblades:FlxTypedGroup<SawbladeSpawner>;
	var _crates:FlxTypedGroup<Crate>;

	// specific groups
	var _peds:FlxTypedGroup<Ped01>;
	var _cops:FlxTypedGroup<Cop>;
	var _pistolBullets:FlxTypedGroup<Bullet>;
	var _rifleBullets:FlxTypedGroup<Bullet>;

	public function new(dirpath:String)
	{
		super();
		_levelPath = dirpath;
	}

	override public function create()
	{
		// set the background image
		_backdrop = new FlxBackdrop("assets/images/Backgrounds/backdrop.png", 0.5, 0.5, true, 0, 0);

		// load the level data
		_map = new FlxOgmo3Loader("assets/levels/hworld.ogmo", _levelPath);
		_tilemap = _map.loadTilemap("assets/data/tilewall.png", "walls");
		_tilemap.follow();

		// declare which blocks are solid and collide with stuff
		_tilemap.setTileProperties(1, FlxObject.NONE);
		_tilemap.setTileProperties(2, FlxObject.ANY);

		// === ACTORS ===
		_peds = new FlxTypedGroup<Ped01>();
		_cops = new FlxTypedGroup<Cop>();
		_player = new Player();

		// === GUN STUFF ===
		_pistolBullets = new FlxTypedGroup<Bullet>(20);
		_rifleBullets = new FlxTypedGroup<Bullet>(12);

		// === PICKUP DECLARATIONS ===
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
		_objects.add(_peds);
		_objects.add(_cops);


		// === PICKUPS GROUP ===
		_pickups = new FlxGroup();
		_pickups.add(_pistolAmmo);
		_pickups.add(_rifleAmmo);
		_pickups.add(_rifles);
		_pickups.add(_pistols);

		// === BULLETS GROUP ===
		_bullets = new FlxGroup();
		_copBullets = new FlxGroup();
		_bullets.add(_pistolBullets);
		_bullets.add(_rifleBullets);

		// === SAWBLADES AND OTHER STUFF ===
		_sawblades = new FlxTypedGroup<SawbladeSpawner>();
		_crates = new FlxTypedGroup<Crate>();

		_map.loadEntities(placeEntities, "entities");
		var _addthese = new Array<FlxBasic>();

		_addthese = [
			_backdrop, _tilemap, _peds, _cops, _player, _pistolBullets, _rifleBullets, _hud, _pistolAmmo, _rifleAmmo, _rifles, _pistols, _player.hitreg,
			_sawblades, _crates
		];
		_objects.add(_crates);

		for (item in _addthese)
		{
			add(item);
		}

		// === ENEMY BULLETS ===
		_cops.forEach(loadMags); // always after _copBullets = new...
		_sawblades.forEach(addBlades);

		super.create();
	}

	public function placeEntities(entity:EntityData)
	{
		switch (entity.name)
		{
			case "player":
				_player.setPosition(entity.x, entity.y);
				return;
			case "NPC":
				_peds.add(new Ped01(entity.x - 16, entity.y - 16));
				return;
			case "cop":
				_cops.add(new Cop(entity.x - 16, entity.y - 16));
				return;
			case "pistolammo":
				_pistolAmmo.add(new PistolAmmo(entity.x, entity.y - 4));
				return;
			case "rifleammo":
				_rifleAmmo.add(new RifleAmmo(entity.x, entity.y - 4));
				return;
			case "rifle":
				_rifles.add(new RiflePickup(entity.x, entity.y));
				return;
			case "pistol":
				_pistols.add(new PistolPickup(entity.x, entity.y));
				return;
			case "sawbladespawner":
				_sawblades.add(new SawbladeSpawner(entity.x, entity.y));
				return;
			case "break_crate":
				_crates.add(new Crate(entity.x, entity.y));
				return;
		}
	}

	override public function update(elapsed:Float)
	{
		collisions();
		pauseListen();
		_peds.forEach(checkNPCvision);
		_cops.forEach(checkNPCvision);
		FlxG.camera.follow(_player, PLATFORMER, 1);
		super.update(elapsed);
	}

	/**
		Listens for key input to pause the game.
	**/
	function pauseListen()
	{
		FlxG.collide(_player, _tilemap);
		if (FlxG.keys.justPressed.P)
		{
			_objects.forEach((obj:FlxBasic) ->
			{
				obj.active = !obj.active;
			});
			_hud.pauseGame();
			_player.setHealth(10);
		}
	}

	// === CHECK NPC VISION FOR PLAYER ===
	function checkNPCvision(npc:NPC)
	{
		npc.lookForPlayer(_tilemap, _player);
	}

	public function collisions()
	{
		FlxG.collide(_objects, _tilemap, objectCollide);
		FlxG.collide(_crates, _objects);
		FlxG.overlap(_crates, _bullets, breakBox);
		FlxG.overlap(_peds, _player.hitreg, npcStab);
		FlxG.overlap(_cops, _player.hitreg, npcStab);
		FlxG.overlap(_peds, _rifleBullets, riflenpcShot); // check for rifle shots first
		FlxG.overlap(_cops, _rifleBullets, riflenpcShot); // as the pistol bullets will override
		FlxG.overlap(_peds, _bullets, npcShot);
		FlxG.overlap(_cops, _bullets, npcShot);
		FlxG.overlap(_player, _pickups, pickupItem);
		FlxG.overlap(_copBullets, _player, playerShot);
		FlxG.overlap(_objects, _player, playerObjectOverlap);
	}
	function breakBox(box:Crate, bullet:Bullet)
	{
		box.kill();
	}
	function playerObjectOverlap(obj:Dynamic, player:Player)
	{
		if (obj is Sawblade)
		{
			obj.hurtPlayer(player);
		}
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

	function npcStab(sprite1:NPC, sprite2:FlxObject)
	{
		sprite2.active ? sprite1.getStabbed() : return;
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

	/**
		kills (destroys) bullets when they collide with walls
	**/
	function bulletWall(obj1:FlxObject, tmap:FlxTilemap)
	{
		// specifically kills bullets on impact with world boundaries
		obj1.kill();
	}

	function objectCollide(obj1:FlxObject, tmap:FlxTilemap)
	{
		if ((obj1 is Bullet) || (obj1 is Sawblade))
		{
			obj1.kill();
		}
	}

	/**
		Pick up an item.
		@param	player	Should be obvious
		@param	item	The item the player will collect
	**/
	function pickupItem(player:Player, item:Pickup)
	{
		item.get(player);
		player.updateHUD();
	}

	/**
		declares new FlxTypedGroup<CopBullet> for each cop in the playstate, then passes the group to the cop's Pistol class.
	**/
	function loadMags(cop:Cop)
	{
		var copBullets:FlxTypedGroup<Bullet> = new FlxTypedGroup<Bullet>(5);
		cop.initPistol(copBullets);
		add(copBullets);
		_objects.add(copBullets);
		_copBullets.add(copBullets);
	}

	function playerShot(bull:Bullet, player:Player)
	{
		bull.hurtPlayer(player);
	}
	/**
		adds each sawblade to the scene
	**/
	function addBlades(parent:SawbladeSpawner)
	{
		add(parent.sawblade);
		_objects.add(parent.sawblade);
	}
}
