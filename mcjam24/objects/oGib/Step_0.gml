/// @description Update gib
if (global.gamePaused)
	exit;

// Gravity
if (vz > velMaxGrav)
	vz += velAccGrav;
else
	vz = velMaxGrav;

x += vx;
y += vy;
z += vz;

// Spawn particle per 4 frames
life++;
if ((life >> 1) & 1)
{
	with (instance_create_layer(x,y,"inst", oParticle))
	{
		z = other.z;
		
		vx = random_range(-2, 2);
		vy = random_range(-2, 2);
		vz = random_range(0.5, 2);
		
		sprite_index = sprParticleTrail;
		image_speed = 0.25;
	}
}

if (z < -64)
	instance_destroy(id);

// Check for collision
var _bounce = false, _stopbounce = false, _bouncevel = 0;
// Bounce
if (entity_side_collision_x(vx))
{
	vx *= -0.5;
	_bounce = true;
	_bouncevel = max(_bouncevel, abs(vx));
}
if (entity_side_collision_y(vy))
{
	vy *= -0.5;
	_bounce = true;
	_bouncevel = max(_bouncevel, abs(vy));
}
if (entity_side_collision_z(vz))
{
	vz *= -0.5;
	_bounce = true;
	_bouncevel = max(_bouncevel, abs(vz));
	_stopbounce = abs(vz) <= 2;
}
if (_bounce)
	snd_play_at(sndBonk, random_range(0.9, 1.1), clamp(_bouncevel/16, 0, 1), x, y, z);

// Explode after 3s or when it stops bouncing
if (life > room_speed * 3 || _stopbounce)
{
	snd_play_at(sndBoom, random_range(1.2, 2), 0.25, x, y, z);
	make_explosion(x, y, z - TILE_SZ * 0.5, TILE_SZ * 1, 0, 8);
	instance_destroy(id);
}
