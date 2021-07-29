/// @description Gibs!
// Inherit the parent event
event_inherited();

image_index = irandom_range(0, image_number-1);
image_speed = 0;
// block size
sx = 7;
sy = 7;
sz = 7;

// fun stuff
life = 0;
dir = choose(-1, 1);

// gravity
velAccGrav = -0.25;
velMaxGrav = -16;
