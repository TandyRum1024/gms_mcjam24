// Tile definitions
#macro MAP_CHUNK_SZ 32
#macro MAP_CHUNK_BIT 5
#macro TILE_SZ 16
#macro TILE_BIT 4
//global.mapSize = [128, 128, 32];
global.mapSize = [32, 32, 16];
global.mapChunkSize = [128/MAP_CHUNK_SZ, 128/MAP_CHUNK_SZ, 32/MAP_CHUNK_SZ];
global.mapChunkUpdated = []; // chunk updated flag

enum eTILES {
	AIR=0,
	LAVA,
	SAND,
	DIRT,
	GRASS,
	STONE
}
enum eSIDE {
	XP = 0,
	YP,
	ZP,
	XN,
	YN,
	ZN
}
enum eLAYER {
	NONE = -1,
	SOLID = 0,
	WATER
}

global.defTiles = [
	{
		name: "air",
		col: c_white,
		alpha: 1,
		layer: eLAYER.NONE,
		textures: undefined
	},
	{
		name: "lava",
		col: c_red,
		alpha: 0.5,
		layer: eLAYER.WATER, // render layer: water
		textures: [
			"lava",	// x++
			"lava",	// y++
			"lava",		// z++
			"lava",	// x--
			"lava",	// y--
			"lava",	// z--
		]
	},
	{
		name: "sand",
		col: c_yellow,
		alpha: 1,
		layer: eLAYER.SOLID,
		textures: [
			"sand_side",	// x++
			"sand_side",	// y++
			"sand_top",		// z++
			"sand_side",	// x--
			"sand_side",	// y--
			"sand_bottom",	// z--
		]
	},
	{
		name: "dirt",
		col: 0x2299FF,
		alpha: 1,
		layer: eLAYER.SOLID,
		textures: [
			"dirt_side",
			"dirt_side",
			"dirt_top",
			"dirt_side",
			"dirt_side",
			"dirt_bottom",
		]
	},
	{
		name: "grass",
		col: 0x00FF00,
		alpha: 1,
		layer: eLAYER.SOLID,
		textures: [
			"grass_side",
			"grass_side",
			"grass_top",
			"grass_side",
			"grass_side",
			"grass_bottom",
		]
	},
	{
		name: "stone",
		col: c_ltgray,
		alpha: 1,
		layer: eLAYER.SOLID,
		textures: [
			"stone_side",
			"stone_side",
			"stone_top",
			"stone_side",
			"stone_side",
			"stone_bottom",
		]
	},
];

vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_texcoord();
vertex_format_add_normal();
vertex_format_add_colour();
global.mapTilemapVF = vertex_format_end();

function tiledef_link_textures ()
{
	var _error_side = global.texAtlas[$ "error_side"],
		_error_top = global.texAtlas[$ "error_top"],
		_error_bottom = global.texAtlas[$ "error_bottom"],
		;
	
	for (var i=0; i<array_length(global.defTiles); i++)
	{
		var _def = global.defTiles[i],
			_tex = _def.textures,
			_atlas,
			;
		
		if (_tex == undefined) // all undefined
		{
			_tex[eSIDE.XP] = _error_side;
			_tex[eSIDE.YP] = _error_side;
			_tex[eSIDE.XN] = _error_side;
			_tex[eSIDE.YN] = _error_side;
			_tex[eSIDE.ZP] = _error_top;
			_tex[eSIDE.ZN] = _error_bottom;
		}
		else
		{
			// Fetch texture uvs by name, substitute it w/ uv info
			// x++
			_atlas = global.texAtlas[$ _tex[eSIDE.XP]];
			_tex[eSIDE.XP] = _atlas!=undefined ? _atlas : _error_side;
			// y++
			_atlas = global.texAtlas[$ _tex[eSIDE.YP]];
			_tex[eSIDE.YP] = _atlas!=undefined ? _atlas : _error_side;
			// z++
			_atlas = global.texAtlas[$ _tex[eSIDE.ZP]];
			_tex[eSIDE.ZP] = _atlas!=undefined ? _atlas : _error_top;
			// x--
			_atlas = global.texAtlas[$ _tex[eSIDE.XN]];
			_tex[eSIDE.XN] = _atlas!=undefined ? _atlas : _error_side;
			// y--
			_atlas = global.texAtlas[$ _tex[eSIDE.YN]];
			_tex[eSIDE.YN] = _atlas!=undefined ? _atlas : _error_side;
			// z--
			_atlas = global.texAtlas[$ _tex[eSIDE.ZN]];
			_tex[eSIDE.ZN] = _atlas!=undefined ? _atlas : _error_bottom;
		}
		_def.textures = _tex;
	}
}
