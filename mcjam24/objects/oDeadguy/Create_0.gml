/// @description Dead guy
// Inherit the parent event
event_inherited();

// block size
sx = 7;
sy = 7;
sz = 7;

// gravity
//velAccGrav = 0.1; //-0.25;
velAccGrav = -0.25;

image_speed = 0;
life = 0;

emitter = audio_emitter_create();
audio_emitter_falloff(emitter, 200, 400, 1.5);
audio_emitter_position(emitter, x, y, z);
scream = audio_play_sound_on(emitter, choose(sndScream1, sndScream2, sndScream3, sndScream4, sndScream4, sndScream5), 0, 0);

die = function () {
	repeat (irandom_range(32, 64))
	{
		with (instance_create_layer(x,y,"inst", oParticle))
		{
			z = other.z;
		
			vx = random_range(-32, 32);
			vy = random_range(-32, 32);
			vz = random_range(-32, 32);
		
			sprite_index = sprParticleTrail;
			image_blend = make_color_hsv(random_range(0, 255), random_range(200, 255), 255);
			image_speed = 0.5;
			var _scale = random_range(1, 2);
			image_xscale = _scale;
			image_yscale = _scale;
		}
	}
	repeat (irandom_range(3, 6))
	{
		with (instance_create_layer(x,y,"inst", oGib))
		{
			z = other.z;
			
			vx = random_range(-16, 16);
			vy = random_range(-16, 16);
			vz = random_range(-16, 16);
		}
	}
	/*
	snd_play_at(choose(sndPop1, sndPop2), random_range(0.95, 1.05), 1.0, x, y, z, 256, 512);
	*/
	snd_play_at(choose(sndGib1, sndGib2, sndGib1, sndGib2, sndGib1, sndGib2, sndGib3), random_range(0.95, 1.05), 1.0, x, y, z, 256, 512);
	
	instance_destroy(id);
}