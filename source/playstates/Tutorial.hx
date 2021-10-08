package playstates;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.addons.editors.ogmo.FlxOgmo3Loader.EntityData;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import playstates.tutorial_assets.Tutorial_goal;
import playstates.tutorial_assets.Tutorial_target;

class Tutorial extends PlayState
{
	var spawnPoint1:FlxPoint;
	var spawnPoint2:FlxPoint;
	var spawnPoint3:FlxPoint;
	var tut_goals:FlxTypedGroup<Tutorial_goal>;
	var tut_targets:FlxTypedGroup<Tutorial_target>;
	var tutStage:Int = 0;
	var pistolTarget:Tutorial_target;

	override public function create()
	{
		tut_goals = new FlxTypedGroup<Tutorial_goal>();
		tut_targets = new FlxTypedGroup<Tutorial_target>();

		super.create();
		add(tut_goals);
		add(tut_targets);
		add(pistolTarget);

		// add(_player);
		/**
			TODO:
				figure out how layers work
				and put that damn target behind the player
				idk what to do with this and I have no internet
				so I can't look it up
		**/
	}

	override public function placeEntities(entity:EntityData)
	{
		super.placeEntities(entity);
		switch (entity.name)
		{
			case "tutspawn1":
				spawnPoint1 = new FlxPoint(entity.x, entity.y);
				return;
			case "tutspawn2":
				spawnPoint2 = new FlxPoint(entity.x, entity.y);
				return;
			case "tutspawn3":
				spawnPoint3 = new FlxPoint(entity.x, entity.y);
				return;
			case "tutorial_goal":
				tut_goals.add(new Tutorial_goal(entity.x, entity.y));
				return;
			case "tutorial_target1":
				tut_targets.add(new Tutorial_target(entity.x, entity.y));
				return;
			case "tutorial_target2":
				pistolTarget = new Tutorial_target(entity.x, entity.y);
				tut_targets.add(pistolTarget);
				return;
		}
	}

	override public function collisions()
	{
		super.collisions();
		FlxG.overlap(_player, tut_goals, advanceTut1);
		FlxG.overlap(_player.hitreg, tut_targets, breakTarget);
		FlxG.overlap(_bullets, tut_targets, advanceTut2);
	}

	function advanceTut1(obj:Dynamic, obj0:Dynamic) // I don't actually want the params
	{
		_player.x = spawnPoint1.x;
		_player.y = spawnPoint1.y - 16;
	}

	function advanceTut2(obj:Dynamic, obj0:Dynamic)
	{
		_player.x = spawnPoint3.x;
		_player.y = spawnPoint3.y - 16;
	}

	function breakTarget(obj:Dynamic, obj0:Dynamic)
	{
		_player.x = spawnPoint2.x;
		_player.y = spawnPoint2.y - 16;
	}
}