/// @description Insert description here
if (global.gamePaused)
	exit;
	
if (vz > velMaxGrav)
	vz += velAccGrav;
else
	vz = velMaxGrav;

// collision
// vertical
if (entity_trymove_z(vz))
{
	// Set velocity
	vz = 0;
}

// vs. block
with (oBlock)
{
	// minkowski sum or something
	var _x1 = x - sx - other.sx,
		_y1 = y - sy - other.sy,
		_z1 = z - sz - other.sz,
		_x2 = x + sx + other.sx,
		_y2 = y + sy + other.sy,
		_z2 = z + sz + other.sz;
	if (other.x >= _x1 && other.x <= _x2 &&
		other.y >= _y1 && other.y <= _y2 &&
		other.z >= _z1 && other.z <= _z2
		)
	{
		// ded
		snd_play_at(choose(sndImpact1, sndImpact2), random_range(0.9, 1.1), 1.0, x, y, z);
		
		repeat (irandom_range(2, 4))
		{
			with (instance_create_layer(x,y,"inst", oParticle))
			{
				z = other.z;
		
				vx = random_range(-4, 4);
				vy = random_range(-4, 4);
				vz = random_range(-4, 4);
		
				sprite_index = sprParticleTrail;
				image_blend = make_color_hsv(0, 0, random_range(200, 255));
				image_speed = 0.5;
				image_xscale = 4;
				image_yscale = 4;
			}
		}
		
		with (instance_create_layer(x,y,"inst", oDeadguy))
		{
			z = other.z;
			vx = other.vx;
			vy = other.vy;
			vz = max(other.vz, 0) + 4;
		}
		
		instance_destroy(other);
		instance_destroy(id);
	}
}
