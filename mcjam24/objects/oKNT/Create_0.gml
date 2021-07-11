/// @description Game master or something
global.debugUI = false;
global.debugPhysics = false;

global.mouseLock = false;
global.mouseSensitivity = 0.1;
global.gamePaused = false;

generateRequest = 1;

// Prepare the tiles
function tex_add_spr (_name, _spr)
{
	tex_add(_name + "_top", _spr, 0);
	tex_add(_name + "_side", _spr, 1);
	tex_add(_name + "_bottom", _spr, 2);
}

tex_init();
tex_add("blank", sprTileFullbright, 0);
tex_add_spr("sand", sprTileSand);
tex_add_spr("dirt", sprTileDirt);
tex_add_spr("grass", sprTileGrass);
tex_add_spr("stone", sprTileStone);
tex_add_spr("error", sprTileTest);
tex_add("lava", sprTileLava, 0);
tex_build(512, 512);
tiledef_link_textures();

// Test: generate maps from perlin noise
map_generate(1, 1, 1);
map_update_chunks_updated();

// Summon player
player = instance_create_layer((global.mapSize[0] >> 1) << TILE_BIT,
								(global.mapSize[1] >> 1) << TILE_BIT, "inst", oPlayer);
with (player)
{
	z = (global.mapSize[2] + 3) << TILE_BIT;
}

#region Graphics
// Screen scaling
winW = window_get_width();
winH = window_get_height();

// temp. render state
gameRenderstatePrevious = undefined;

// Rendering group queue
renderQueueSolid = ds_queue_create(); // solid layer
renderQueueWater = ds_queue_create(); // water layer

// Camera
cameraOrbitDist = 128;
camera = {
	x: 0,
	y: 0,
	z: 0,
	rotH: 0,
	rotV: 0,
	
	fwdX: 0,
	fwdY: 0,
	fwdZ: 0,
	fwdAimX: 0,
	fwdAimY: 0,
	fwdAimZ: 0,
	sideX: 0,
	sideY: 0,
	sideZ: 0,
	
	fov: 80,
	znear: 0.1,
	zfar: 4096,
	
	matV: undefined,
	matP: undefined,
	
	update: function () {
		fwdAimX = lengthdir_x(1, rotH);
		fwdAimY = lengthdir_y(1, rotH);
		fwdAimZ = 0;
		fwdX = fwdAimX * lengthdir_x(1, rotV);
		fwdY = fwdAimY * lengthdir_x(1, rotV);
		fwdZ = lengthdir_y(1, rotV);
		
		sideX = -fwdAimY;
		sideY = fwdAimX;
		sideZ = 0;
		
		matV = matrix_build_lookat(x, y, z, x+fwdX, y+fwdY, z+fwdZ, 0, 0, -1);
		matP = matrix_build_projection_perspective_fov(fov, window_get_width()/window_get_height(), znear, zfar);
	}
};
camera.update();
#endregion

// Summon the IMGUI object
instance_create_depth(0, 0, -42424242, imgui);