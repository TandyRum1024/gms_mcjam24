/// @description Player object
// Inherit entity
event_inherited();

// Player size
sx = 5;
sy = 5;
sz = 10;

// Player eye position
eyeZ = z + sz * 0.75;
// Player aim
aimX = 0;
aimY = 0;
aimZ = 0;
// Player directions relative to ground (for moving)
groundFwdX = 0;
groundFwdY = 0;
groundFwdZ = 0;
groundSideX = 0;
groundSideY = 0;
groundSideZ = 0;

// Player status
playerHoldingTile = ds_list_create(); //eTILES.AIR;
playerAimTile = eTILES.AIR;
playerGrabRange = TILE_SZ * 3;

grounded = false;
groundMoveCtr = 0;
groundMoveStep = 0;
// Player movements

