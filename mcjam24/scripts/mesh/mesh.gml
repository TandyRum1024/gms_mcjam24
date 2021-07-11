// Initialize debug mesh
#macro MAT_IDENTITY global.matIdentity
global.matIdentity = matrix_build_identity();

vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_texcoord();
vertex_format_add_normal();
vertex_format_add_colour();
global.meshVF = vertex_format_end();

// Wireframe mesh
var _vb = vertex_create_buffer();
vertex_begin(_vb, global.meshVF);
	// x
	vertex_position_3d(_vb, -1, -1, -1);
	vertex_texcoord(_vb, 0, 0); vertex_normal(_vb, 0, 0, 1); vertex_colour(_vb, 0xFF00FF, 1);
	vertex_position_3d(_vb, 1, -1, -1);
	vertex_texcoord(_vb, 0, 0); vertex_normal(_vb, 0, 0, 1); vertex_colour(_vb, 0xFF00FF, 1);

	vertex_position_3d(_vb, -1, 1, -1);
	vertex_texcoord(_vb, 0, 0); vertex_normal(_vb, 0, 0, 1); vertex_colour(_vb, 0xFF00FF, 1);
	vertex_position_3d(_vb, 1, 1, -1);
	vertex_texcoord(_vb, 0, 0); vertex_normal(_vb, 0, 0, 1); vertex_colour(_vb, 0xFF00FF, 1);

	vertex_position_3d(_vb, -1, -1, 1);
	vertex_texcoord(_vb, 0, 0); vertex_normal(_vb, 0, 0, 1); vertex_colour(_vb, 0xFF00FF, 1);
	vertex_position_3d(_vb, 1, -1, 1);
	vertex_texcoord(_vb, 0, 0); vertex_normal(_vb, 0, 0, 1); vertex_colour(_vb, 0xFF00FF, 1);

	vertex_position_3d(_vb, -1, 1, 1);
	vertex_texcoord(_vb, 0, 0); vertex_normal(_vb, 0, 0, 1); vertex_colour(_vb, 0xFF00FF, 1);
	vertex_position_3d(_vb, 1, 1, 1);
	vertex_texcoord(_vb, 0, 0); vertex_normal(_vb, 0, 0, 1); vertex_colour(_vb, 0xFF00FF, 1);

	// y
	vertex_position_3d(_vb, -1, -1, -1);
	vertex_texcoord(_vb, 0, 0); vertex_normal(_vb, 0, 0, 1); vertex_colour(_vb, 0xFF00FF, 1);
	vertex_position_3d(_vb, -1, 1, -1);
	vertex_texcoord(_vb, 0, 0); vertex_normal(_vb, 0, 0, 1); vertex_colour(_vb, 0xFF00FF, 1);
	
	vertex_position_3d(_vb, 1, -1, -1);
	vertex_texcoord(_vb, 0, 0); vertex_normal(_vb, 0, 0, 1); vertex_colour(_vb, 0xFF00FF, 1);
	vertex_position_3d(_vb, 1, 1, -1);
	vertex_texcoord(_vb, 0, 0); vertex_normal(_vb, 0, 0, 1); vertex_colour(_vb, 0xFF00FF, 1);
	
	vertex_position_3d(_vb, -1, -1, 1);
	vertex_texcoord(_vb, 0, 0); vertex_normal(_vb, 0, 0, 1); vertex_colour(_vb, 0xFF00FF, 1);
	vertex_position_3d(_vb, -1, 1, 1);
	vertex_texcoord(_vb, 0, 0); vertex_normal(_vb, 0, 0, 1); vertex_colour(_vb, 0xFF00FF, 1);

	vertex_position_3d(_vb, 1, -1, 1);
	vertex_texcoord(_vb, 0, 0); vertex_normal(_vb, 0, 0, 1); vertex_colour(_vb, 0xFF00FF, 1);
	vertex_position_3d(_vb, 1, 1, 1);
	vertex_texcoord(_vb, 0, 0); vertex_normal(_vb, 0, 0, 1); vertex_colour(_vb, 0xFF00FF, 1);
	
	// z
	vertex_position_3d(_vb, -1, -1, -1);
	vertex_texcoord(_vb, 0, 0); vertex_normal(_vb, 0, 0, 1); vertex_colour(_vb, 0xFF00FF, 1);
	vertex_position_3d(_vb, -1, -1, 1);
	vertex_texcoord(_vb, 0, 0); vertex_normal(_vb, 0, 0, 1); vertex_colour(_vb, 0xFF00FF, 1);
	
	vertex_position_3d(_vb, 1, -1, -1);
	vertex_texcoord(_vb, 0, 0); vertex_normal(_vb, 0, 0, 1); vertex_colour(_vb, 0xFF00FF, 1);
	vertex_position_3d(_vb, 1, -1, 1);
	vertex_texcoord(_vb, 0, 0); vertex_normal(_vb, 0, 0, 1); vertex_colour(_vb, 0xFF00FF, 1);
	
	vertex_position_3d(_vb, -1, 1, -1);
	vertex_texcoord(_vb, 0, 0); vertex_normal(_vb, 0, 0, 1); vertex_colour(_vb, 0xFF00FF, 1);
	vertex_position_3d(_vb, -1, 1, 1);
	vertex_texcoord(_vb, 0, 0); vertex_normal(_vb, 0, 0, 1); vertex_colour(_vb, 0xFF00FF, 1);
	
	vertex_position_3d(_vb, 1, 1, -1);
	vertex_texcoord(_vb, 0, 0); vertex_normal(_vb, 0, 0, 1); vertex_colour(_vb, 0xFF00FF, 1);
	vertex_position_3d(_vb, 1, 1, 1);
	vertex_texcoord(_vb, 0, 0); vertex_normal(_vb, 0, 0, 1); vertex_colour(_vb, 0xFF00FF, 1);
vertex_end(_vb);
vertex_freeze(_vb);
global.meshWireboxCenter = _vb;

// Sky cylinder
global.skyboxColTop = 0xe8e8ca;
global.skyboxColBottom = 0xdea8a6;
global.skyboxScale = 1024;
var _vb = vertex_create_buffer();
vertex_begin(_vb, global.meshVF);
var _skybox_iteration = 64, _skybox_step = (360/_skybox_iteration);
for (var i=0; i<_skybox_iteration; i++)
{
	var _x1 = lengthdir_x(1, i*_skybox_step),
		_y1 = lengthdir_y(1, i*_skybox_step),
		_x2 = lengthdir_x(1, (i+1)*_skybox_step),
		_y2 = lengthdir_y(1, (i+1)*_skybox_step),
		;
	if (i > 0) // add degenerate point
	{
		vertex_position_3d(_vb, 0, 0, -1);
		vertex_texcoord(_vb, 0, 0); vertex_normal(_vb, 0, 0, 1); vertex_colour(_vb, global.skyboxColBottom, 1);
	}
	
	vertex_position_3d(_vb, 0, 0, -1);
	vertex_texcoord(_vb, 0, 0); vertex_normal(_vb, 0, 0, 1); vertex_colour(_vb, global.skyboxColBottom, 1);
	
	vertex_position_3d(_vb, _x1, _y1, -1);
	vertex_texcoord(_vb, 0, 0); vertex_normal(_vb, 0, 0, 1); vertex_colour(_vb, global.skyboxColBottom, 1);
	
	vertex_position_3d(_vb, _x2, _y2, -1);
	vertex_texcoord(_vb, 0, 0); vertex_normal(_vb, 0, 0, 1); vertex_colour(_vb, global.skyboxColBottom, 1);
	
	vertex_position_3d(_vb, _x1, _y1, 1);
	vertex_texcoord(_vb, 0, 0); vertex_normal(_vb, 0, 0, 1); vertex_colour(_vb, global.skyboxColTop, 1);
	
	vertex_position_3d(_vb, _x2, _y2, 1);
	vertex_texcoord(_vb, 0, 0); vertex_normal(_vb, 0, 0, 1); vertex_colour(_vb, global.skyboxColTop, 1);
	
	vertex_position_3d(_vb, 0, 0, 1);
	vertex_texcoord(_vb, 0, 0); vertex_normal(_vb, 0, 0, 1); vertex_colour(_vb, global.skyboxColTop, 1);
	
	if (i < _skybox_iteration-1) // add degenerate point
	{
		vertex_position_3d(_vb, 0, 0, 1);
		vertex_texcoord(_vb, 0, 0); vertex_normal(_vb, 0, 0, 1); vertex_colour(_vb, global.skyboxColTop, 1);
	}
}
vertex_end(_vb);
vertex_freeze(_vb);
global.meshSkybox = _vb;

// Tile mesh
// z++
var _vb = vertex_create_buffer();
vertex_begin(_vb, global.meshVF);
	map_vb_add_floor_p(_vb, -0.5, -0.5, 0.5, 1, 1, 0,
						0, 0, 1, 1, 0, 0, 1, c_white, 1);
	//vertex_position_3d(_vb, -0.5, 0.5, 0.5);
	//vertex_texcoord(_vb, 1, 0); vertex_normal(_vb, 0, 0, 1); vertex_colour(_vb, c_white, 1);
	//vertex_position_3d(_vb, 0.5, 0.5, 0.5);
	//vertex_texcoord(_vb, 0, 0); vertex_normal(_vb, 0, 0, 1); vertex_colour(_vb, c_white, 1);
	//vertex_position_3d(_vb, -0.5, -0.5, 0.5);
	//vertex_texcoord(_vb, 1, 1); vertex_normal(_vb, 0, 0, 1); vertex_colour(_vb, c_white, 1);
	//vertex_position_3d(_vb, 0.5, -0.5, 0.5);
	//vertex_texcoord(_vb, 0, 1); vertex_normal(_vb, 0, 0, 1); vertex_colour(_vb, c_white, 1);
vertex_end(_vb);
vertex_freeze(_vb);
global.meshTileZP = _vb;
// z--
var _vb = vertex_create_buffer();
vertex_begin(_vb, global.meshVF);
	map_vb_add_floor_n(_vb, -0.5, -0.5, -0.5, 1, 1, 0,
						0, 0, 1, 1, 0, 0, -1, c_white, 1);
vertex_end(_vb);
vertex_freeze(_vb);
global.meshTileZN = _vb;

// x++
var _vb = vertex_create_buffer();
vertex_begin(_vb, global.meshVF);
	map_vb_add_wall_n(_vb, 0.5, -0.5, -0.5, 0, 1, 1,
						0, 0, 1, 1, 1, 0, 0, c_white, 1);
vertex_end(_vb);
vertex_freeze(_vb);
global.meshTileXP = _vb;

// x--
var _vb = vertex_create_buffer();
vertex_begin(_vb, global.meshVF);
	map_vb_add_wall_p(_vb, -0.5, -0.5, -0.5, 0, 1, 1,
						0, 0, 1, 1, -1, 0, 0, c_white, 1);
vertex_end(_vb);
vertex_freeze(_vb);
global.meshTileXN = _vb;

// y++
var _vb = vertex_create_buffer();
vertex_begin(_vb, global.meshVF);
	map_vb_add_wall_p(_vb, -0.5, 0.5, -0.5, 1, 0, 1,
						0, 0, 1, 1, 0, 1, 0, c_white, 1);
vertex_end(_vb);
vertex_freeze(_vb);
global.meshTileYP = _vb;

// y--
var _vb = vertex_create_buffer();
vertex_begin(_vb, global.meshVF);
	map_vb_add_wall_n(_vb, -0.5, -0.5, -0.5, 1, 0, 1,
						0, 0, 1, 1, 0, -1, 0, c_white, 1);
vertex_end(_vb);
vertex_freeze(_vb);
global.meshTileYN = _vb;
/*
// z++ floor
					if (tz+1 >= _map_sz || _tiledef[_tilemap[tx][ty][tz+1]].layer != _tile_layer)
					{
						var _uvs = _tile_data.textures[eSIDE.ZP];
						
					}
					// z-- floor
					if (tz <= 0 || _tiledef[_tilemap[tx][ty][tz-1]].layer != _tile_layer)
					{
						var _uvs = _tile_data.textures[eSIDE.ZN];
						map_vb_add_floor_n(_vb, _wld_x, _wld_y, _wld_z, TILE_SZ, TILE_SZ, 0,
											_uvs[0], _uvs[1], _uvs[2], _uvs[3], 0, 0, -1, _tile_col, _tile_alpha);
					}
					// x++ wall
					if (tx+1 >= _map_sx || _tiledef[_tilemap[tx+1][ty][tz]].layer != _tile_layer)
					{
						var _uvs = _tile_data.textures[eSIDE.XP];
						map_vb_add_wall_n(_vb, _wld_x + TILE_SZ, _wld_y, _wld_z, 0, TILE_SZ, TILE_SZ,
											_uvs[0], _uvs[1], _uvs[2], _uvs[3], 1, 0, 0, _tile_col, _tile_alpha);
					}
					// x-- wall
					if (tx <= 0 || _tiledef[_tilemap[tx-1][ty][tz]].layer != _tile_layer)
					{
						var _uvs = _tile_data.textures[eSIDE.XN];
						map_vb_add_wall_p(_vb, _wld_x, _wld_y, _wld_z, 0, TILE_SZ, TILE_SZ,
											_uvs[0], _uvs[1], _uvs[2], _uvs[3], -1, 0, 0, _tile_col, _tile_alpha);
					}
					// y++ wall
					if (ty+1 >= _map_sy || _tiledef[_tilemap[tx][ty+1][tz]].layer != _tile_layer)
					{
						var _uvs = _tile_data.textures[eSIDE.YP];
						map_vb_add_wall_p(_vb, _wld_x, _wld_y + TILE_SZ, _wld_z, TILE_SZ, 0, TILE_SZ,
											_uvs[0], _uvs[1], _uvs[2], _uvs[3], 0, 1, 0, _tile_col, _tile_alpha);
					}
					// y-- wall
					if (ty <= 0 || _tiledef[_tilemap[tx][ty-1][tz]].layer != _tile_layer)
					{
						var _uvs = _tile_data.textures[eSIDE.YN];
						map_vb_add_wall_n(_vb, _wld_x, _wld_y, _wld_z, TILE_SZ, 0, TILE_SZ,
											_uvs[0], _uvs[1], _uvs[2], _uvs[3], 0, -1, 0, _tile_col, _tile_alpha);
					}
*/