/// @description NPC
// Inherit the entity
event_inherited();

// Guy size
sx = 10;
sy = 10;
sz = 12;

// Animation
image_speed = 0.25;

die = function (_vx, _vy, _vz, _x, _y, _z) {
	if (_x == undefined) _x = x;
	if (_y == undefined) _y = y;
	if (_z == undefined) _z = z;
	
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
		
	with (instance_create_layer(_x,_y,"inst", oDeadguy))
	{
		z = _z;
		//vx = other.vx * 0.5;
		//vy = other.vy * 0.5;
		//vz = max(other.vz * 0.5, 0) + 8;
		vx = _vx;
		vy = _vy;
		vz = max(_vz, 0) + 2;
	}
	
	instance_destroy(id);
}