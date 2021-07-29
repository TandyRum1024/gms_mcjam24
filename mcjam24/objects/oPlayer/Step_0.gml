/// @description Update logic
if (global.gamePaused)
	exit;

// Movement
var _fwd = keyboard_check(ord("W")) - keyboard_check(ord("S")),
	_sid = keyboard_check(ord("A")) - keyboard_check(ord("D")),
	_jump = keyboard_check(vk_space) - keyboard_check(vk_control),
	_grab = mouse_check_button_pressed(mb_right),
	_yeet = mouse_check_button_pressed(mb_left),
	_rat = keyboard_check_pressed(ord("R")),
	_platform = keyboard_check_pressed(ord("G")),
	_speed = keyboard_check(vk_shift) ? 2 : 1,
	;

if (_fwd != 0 || _sid != 0)
{
	vx = (groundFwdX * _fwd + groundSideX * _sid) * _speed;
	vy = (groundFwdY * _fwd + groundSideY * _sid) * _speed;
	//vz = (groundFwdZ * _fwd + groundSideZ * _sid) * _speed;
}

if (keyboard_check(vk_space))
	vz = _jump * _speed * 2;

// Player tile grabbing
// Raycast & check if theres any tile in range
var _result = map_col_ray_tilemap(global.mapTiles, x, y, eyeZ, aimX, aimY, aimZ),
	_t = _result[1], _tx = _result[2], _ty = _result[3], _tz = _result[4],
	;
if (_t <= playerGrabRange)
{
	// hit!
	playerAimTile = map_get(_tx, _ty, _tz);
}
else
{
	playerAimTile = eTILES.AIR;
}

if (_grab && playerAimTile != eTILES.AIR)
{
	ds_list_add(playerHoldingTile, playerAimTile);
	map_edit_set(_tx, _ty, _tz, eTILES.AIR);
	
	snd_play(sndMine, random_range(0.8, 1.2), 1);
}

// YEET
if (_yeet && !ds_list_empty(playerHoldingTile) &&
	playerHoldingTile[| ds_list_size(playerHoldingTile)-1] != eTILES.AIR)
{
	var _throwntile = playerHoldingTile[| ds_list_size(playerHoldingTile)-1];
	with (instance_create_layer(x, y, "inst", oBlock))
	{
		z = other.eyeZ;
		
		vx = other.aimX * 8;
		vy = other.aimY * 8;
		vz = other.aimZ * 8 + 4;
		
		tile = _throwntile;
	}
	
	ds_list_delete(playerHoldingTile, ds_list_size(playerHoldingTile)-1);
	snd_play(sndThrow, random_range(0.8, 1.2), 1);
}

// RAT
if (_rat)
{
	with (instance_create_layer(x, y, "inst", oRat))
	{
		z = other.eyeZ;
		vx = other.aimX * 8;
		vy = other.aimY * 8;
		vz = other.aimZ * 8 + 6;
	}
	
	snd_play(sndThrow, random_range(0.8, 1.2), 1);
}

// PLATFORM
if (_platform)
{
	var _tx = x >> TILE_BIT,
		_ty = y >> TILE_BIT,
		_tz = (z-sz-4) >> TILE_BIT;
	map_edit_set(_tx, _ty, _tz, 1);
}

// GUY
if (keyboard_check_pressed(ord("T")))
{
	with (instance_create_layer(x, y, "inst", oGuy))
		z = other.eyeZ;
	
	//snd_play(sndThrow, random_range(0.8, 1.2), 1);
}

// Physics
// gravity
if (!grounded && !keyboard_check(vk_space))
{
	if (vz > velMaxGrav)
		vz += velAccGrav;
	else
		vz = velMaxGrav;
}

// collision
// vertical first
if (entity_trymove_z(vz))
{
	// Set velocity
	//show_debug_message("col z");
	vz = 0;
}
// horizontal
if (entity_trymove_x(vx))
{
	// Set velocity
	//show_debug_message("col x");
	vx = 0;
}
if (entity_trymove_y(vy))
{
	// Set velocity
	//show_debug_message("col y");
	vy = 0;
}

var _grounded = entity_side_collision_z(-1);
if (!grounded && _grounded)
{
	// Land
	groundMoveCtr = 0;
	snd_play(sndStepLand, random_range(0.9, 1.1), 1);
}
grounded = _grounded;

// Upadte move counter
if (grounded)
{
	groundMoveCtr += point_distance(0,0,vx, vy);
	if (groundMoveCtr > 16) // footstep
	{
		snd_play(groundMoveStep ? sndStep2 : sndStep1, random_range(-0.1, 0.1) + 1.0, random_range(0.4, 0.6));
		groundMoveCtr = 0;
		groundMoveStep ^= 1;
	}
}

// friction
vx *= velFriction;	
vy *= velFriction;
//vz *= velFriction;

// Update player eye position
eyeZ = z + sz * 0.75;

// Handle fraction part of velocity
//entity_update_fracvel();
