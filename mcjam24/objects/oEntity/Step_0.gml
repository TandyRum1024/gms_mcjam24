/// @description Update logic
if (global.gamePaused)
	exit;
	
// Physics
// gravity
vz -= velAccGrav;

// collision
// vertical first
if (entity_trymove_z(vz))
{
	// Resolve position
	show_debug_message("col z");
}

// friction
vx *= velFriction;
vy *= velFriction;
vz *= velFriction;
