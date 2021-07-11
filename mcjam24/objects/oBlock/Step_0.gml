/// @description Update block
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

rx += vx * 4;
ry += vy * 4;
rz += vz * 4;

// Spawn particle per 2 frames
life++;
if (life & 1)
{
	with (instance_create_layer(x,y,"inst", oParticle))
	{
		z = other.z;
		
		vx = random_range(-2, 2);
		vy = random_range(-2, 2);
		vz = random_range(-2, 2);
		
		sprite_index = sprParticleTrail;
		image_speed = 0.25;
	}
}

if (z < -64)
	instance_destroy(id);

// Check for collision
if (map_col_aabb(x-sx, y-sy, z-sz, x+sx, y+sy, z+sz))
{
	snd_play_at(sndPlace, random_range(0.9, 1.1), 1.0, x, y, z);
	
	// Spawn block & destroy
	map_edit_set(x >> TILE_BIT, y >> TILE_BIT, z >> TILE_BIT, tile);
	
	repeat (irandom_range(16, 32))
	{
		with (instance_create_layer(x,y,"inst", oParticle))
		{
			z = other.z;
		
			vx = random_range(-16, 16);
			vy = random_range(-16, 16);
			vz = random_range(-16, 16);
		
			sprite_index = sprParticleTrail;
			image_blend = make_color_hsv(random_range(0, 255), 255, 255);
			image_speed = 0.5;
		}
	}
	
	instance_destroy(id);
}
