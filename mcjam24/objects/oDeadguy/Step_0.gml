/// @description Update guy
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

// Spawn particle per 2 frames
life++;
if (life & 1)
{
	with (instance_create_layer(x,y,"inst", oParticle))
	{
		z = other.z;
		
		vx = random_range(-2, 2);
		vy = random_range(-2, 2);
		vz = random_range(-4, -2);
		
		sprite_index = sprParticleTrail;
		image_blend = c_red;
		image_speed = 0.25;
	}
}

if (z < -64)
	instance_destroy(id);

// Check for collision
if (map_col_aabb(x-sx, y-sy, z-sz, x+sx, y+sy, z+sz))
{
	snd_play_at(sndDed, random_range(0.9, 1.1), 1.0, x, y, z);
	
	repeat (irandom_range(16, 32))
	{
		with (instance_create_layer(x,y,"inst", oParticle))
		{
			z = other.z;
		
			vx = random_range(-16, 16);
			vy = random_range(-16, 16);
			vz = random_range(-16, 16);
		
			sprite_index = sprParticleTrail;
			image_blend = make_color_hsv(random_range(10, 40), random_range(200, 255), 255);
			image_speed = 0.5;
		}
	}
	
	instance_destroy(id);
}
