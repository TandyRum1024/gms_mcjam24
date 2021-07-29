function map_get (_tx, _ty, _tz)
{
	// Check if the position is in bound
	if (_tx < 0 || _tx >= global.mapSize[0] ||
		_ty < 0 || _ty >= global.mapSize[1] ||
		_tz < 0 || _tz >= global.mapSize[2])
		return eTILES.AIR;
	// Set tile
	return global.mapTiles[_tx][_ty][_tz];
}


function map_edit_set (_tx, _ty, _tz, _tile)
{
	// Check if the position is in bound
	if (_tx < 0 || _tx >= global.mapSize[0] ||
		_ty < 0 || _ty >= global.mapSize[1] ||
		_tz < 0 || _tz >= global.mapSize[2])
		return false;
	// Set tile & layer
	global.mapTiles[_tx][_ty][_tz] = _tile;
	global.mapTilesLayer[_tx][_ty][_tz] = global.defTiles[_tile].layer;
	
	// Update chunk & it's neighbor
	var _cx = _tx>>MAP_CHUNK_BIT,
		_cy = _ty>>MAP_CHUNK_BIT,
		_cz = _tz>>MAP_CHUNK_BIT,
		;
	// Wow I hate this
	global.mapChunkUpdated[_cx][_cy][_cz] = true;
	if (_tx > 0 && _tx == _cx << MAP_CHUNK_BIT) // x-- side of chunk
		global.mapChunkUpdated[(_tx-1)>>MAP_CHUNK_BIT][_cy][_cz]	= true;
	if (_tx < global.mapSize[0]-1 && _tx == ((_cx+1) << MAP_CHUNK_BIT) - 1) // x++ side of chunk
		global.mapChunkUpdated[(_tx+1)>>MAP_CHUNK_BIT][_cy][_cz]	= true;
	if (_ty > 0 && _ty == _cy << MAP_CHUNK_BIT) // y-- side of chunk
		global.mapChunkUpdated[_cx][(_ty-1)>>MAP_CHUNK_BIT][_cz]	= true;
	if (_ty < global.mapSize[1]-1 && _ty == ((_cy+1) << MAP_CHUNK_BIT) - 1) // y++ side of chunk
		global.mapChunkUpdated[_cx][(_ty+1)>>MAP_CHUNK_BIT][_cz]	= true;
	if (_tz > 0 && _tz == _cz << MAP_CHUNK_BIT) // z-- side of chunk
		global.mapChunkUpdated[_cx][_cy][(_tz-1)>>MAP_CHUNK_BIT]	= true;
	if (_tz < global.mapSize[2]-1 && _tz == ((_cz+1) << MAP_CHUNK_BIT) - 1) // z++ side of chunk
		global.mapChunkUpdated[_cx][_cy][(_tz+1)>>MAP_CHUNK_BIT]	= true;
	
	with (oKNT)
	{
		generateMeshInit = false;
	}
	//global.mapChunkUpdated[_tx>>MAP_CHUNK_BIT][_ty>>MAP_CHUNK_BIT][_tz>>MAP_CHUNK_BIT] = true;
	
	return true;
}

function map_destroy ()
{
	// For all chunks free the vb
	for (var xx=0; xx<array_length(global.mapChunksVB); xx++)
	{
		for (var yy=0; yy<array_length(global.mapChunksVB[xx]); yy++)
		{
			for (var zz=0; zz<array_length(global.mapChunksVB[xx][yy]); zz++)
			{
				var _chunk_vb = global.mapChunksVB[xx][yy][zz];
				if (_chunk_vb[0] != undefined)
					vertex_delete_buffer(_chunk_vb[0]);
				if (_chunk_vb[1] != undefined)
					vertex_delete_buffer(_chunk_vb[1]);
				global.mapChunksVB[xx][yy][zz] = [undefined, undefined];
			}
		}
	}
}

// @desc Updates single block for given chunk's VBs
function map_update_chunk_block (_chunk_vb, _tx, _ty, _tz, _map_sx, _map_sy, _map_sz, _tilemap, _tilelayer, _tiledef)
{
	// Check #1: out of bounds
	if (_tx < 0 || _tx >= _map_sx ||
		_ty < 0 || _ty >= _map_sy ||
		_tz < 0 || _tz >= _map_sz)
		return;
	
	var _tile = _tilemap[_tx][_ty][_tz], // current tile type
		_layer = _tilelayer[_tx][_ty][_tz],
		;
	// Check #2: empty tiles
	if (_layer == eLAYER.NONE)
		return;
	
	// Get tile data
	var _tile_data = _tiledef[_tile],
		_tile_col = c_white,
		_tile_alpha = _tile_data.alpha,
		// _tile_layer = _tile_data.layer,
		_vb = _chunk_vb[_layer],
		;
								
	// Fill vb with tile mesh
	var _wld_x = _tx << TILE_BIT,
		_wld_y = _ty << TILE_BIT,
		_wld_z = _tz << TILE_BIT,
		;
	// z++ floor
	if (_tz+1 >= _map_sz || _tilelayer[_tx][_ty][_tz+1] != _layer)
	{
		var _uvs = _tile_data.textures[eSIDE.ZP],
			_x = _wld_x, _y = _wld_y, _z = _wld_z + TILE_SZ,
			_x2 = _x + TILE_SZ, _y2 = _y + TILE_SZ, _z2 = _z,
			_u = _uvs[0], _v = _uvs[1],
			_u2 = _u+_uvs[2], _v2 = _v+_uvs[3],
			;
		// 1st tri
		//map_vb_add(_vb, _x, _y, _z, _u, _v, 0, 0, 1, _tile_col, _tile_alpha);
		vertex_position_3d(_vb, _x, _y, _z); vertex_texcoord(_vb, _u, _v); vertex_normal(_vb, 0, 0, 1); vertex_colour(_vb, _tile_col, _tile_alpha);
		//map_vb_add(_vb, _x2, _y, _z, _u2, _v, 0, 0, 1, _tile_col, _tile_alpha);
		vertex_position_3d(_vb, _x2, _y, _z); vertex_texcoord(_vb, _u2, _v); vertex_normal(_vb, 0, 0, 1); vertex_colour(_vb, _tile_col, _tile_alpha);
		//map_vb_add(_vb, _x2, _y2, _z2, _u2, _v2, 0, 0, 1, _tile_col, _tile_alpha);
		vertex_position_3d(_vb, _x2, _y2, _z2); vertex_texcoord(_vb, _u2, _v2); vertex_normal(_vb, 0, 0, 1); vertex_colour(_vb, _tile_col, _tile_alpha);
		// 2st tri
		//map_vb_add(_vb, _x, _y, _z, _u, _v, 0, 0, 1, _tile_col, _tile_alpha);
		vertex_position_3d(_vb, _x, _y, _z); vertex_texcoord(_vb, _u, _v); vertex_normal(_vb, 0, 0, 1); vertex_colour(_vb, _tile_col, _tile_alpha);
		//map_vb_add(_vb, _x2, _y2, _z2, _u2, _v2, 0, 0, 1, _tile_col, _tile_alpha);
		vertex_position_3d(_vb, _x2, _y2, _z2); vertex_texcoord(_vb, _u2, _v2); vertex_normal(_vb, 0, 0, 1); vertex_colour(_vb, _tile_col, _tile_alpha);
		//map_vb_add(_vb, _x, _y2, _z2, _u, _v2, 0, 0, 1, _tile_col, _tile_alpha);
		vertex_position_3d(_vb, _x, _y2, _z2); vertex_texcoord(_vb, _u, _v2); vertex_normal(_vb, 0, 0, 1); vertex_colour(_vb, _tile_col, _tile_alpha);
		//map_vb_add_floor_p(_vb, _wld_x, _wld_y, _wld_z + TILE_SZ, TILE_SZ, TILE_SZ, 0,
		//					_uvs[0], _uvs[1], _uvs[2], _uvs[3], 0, 0, 1, _tile_col, _tile_alpha);
	}
	// z-- floor
	if (_tz <= 0 || _tilelayer[_tx][_ty][_tz-1] != _layer)
	{
		var _uvs = _tile_data.textures[eSIDE.ZN],
			_x = _wld_x, _y = _wld_y, _z = _wld_z,
			_x2 = _x + TILE_SZ, _y2 = _y + TILE_SZ, _z2 = _z,
			_u = _uvs[0], _v = _uvs[1],
			_u2 = _u+_uvs[2], _v2 = _v+_uvs[3],
			;
		// 1st tri
		//map_vb_add(_vb, _x, _y, _z, _u, _v, 0, 0, -1, _tile_col, _tile_alpha);
		vertex_position_3d(_vb, _x, _y, _z); vertex_texcoord(_vb, _u, _v); vertex_normal(_vb, 0, 0, -1); vertex_colour(_vb, _tile_col, _tile_alpha);
		//map_vb_add(_vb, _x2, _y2, _z2, _u2, _v2, 0, 0, -1, _tile_col, _tile_alpha);
		vertex_position_3d(_vb, _x2, _y2, _z2); vertex_texcoord(_vb, _u2, _v2); vertex_normal(_vb, 0, 0, -1); vertex_colour(_vb, _tile_col, _tile_alpha);
		//map_vb_add(_vb, _x2, _y, _z, _u2, _v, 0, 0, -1, _tile_col, _tile_alpha);
		vertex_position_3d(_vb, _x2, _y, _z); vertex_texcoord(_vb, _u2, _v); vertex_normal(_vb, 0, 0, -1); vertex_colour(_vb, _tile_col, _tile_alpha);
		// 2st tri
		//map_vb_add(_vb, _x, _y, _z, _u, _v, 0, 0, -1, _tile_col, _tile_alpha);
		vertex_position_3d(_vb, _x, _y, _z); vertex_texcoord(_vb, _u, _v); vertex_normal(_vb, 0, 0, -1); vertex_colour(_vb, _tile_col, _tile_alpha);
		//map_vb_add(_vb, _x, _y2, _z2, _u, _v2, 0, 0, -1, _tile_col, _tile_alpha);
		vertex_position_3d(_vb, _x, _y2, _z2); vertex_texcoord(_vb, _u, _v2); vertex_normal(_vb, 0, 0, -1); vertex_colour(_vb, _tile_col, _tile_alpha);
		//map_vb_add(_vb, _x2, _y2, _z2, _u2, _v2, 0, 0, -1, _tile_col, _tile_alpha);
		vertex_position_3d(_vb, _x2, _y2, _z2); vertex_texcoord(_vb, _u2, _v2); vertex_normal(_vb, 0, 0, -1); vertex_colour(_vb, _tile_col, _tile_alpha);
		//map_vb_add_floor_n(_vb, _wld_x, _wld_y, _wld_z, TILE_SZ, TILE_SZ, 0,
		//					_uvs[0], _uvs[1], _uvs[2], _uvs[3], 0, 0, -1, _tile_col, _tile_alpha);
	}
	// x++ wall
	if (_tx+1 >= _map_sx || _tilelayer[_tx+1][_ty][_tz] != _layer)
	{
		var _uvs = _tile_data.textures[eSIDE.XP],
			_x = _wld_x + TILE_SZ, _y = _wld_y, _z = _wld_z,
			_x2 = _x, _y2 = _y + TILE_SZ, _z2 = _z + TILE_SZ,
			_u2 = _uvs[0], _v2 = _uvs[1],
			_u = _u2+_uvs[2], _v = _v2+_uvs[3],
			;
		// 1st tri
		//map_vb_add(_vb, _x, _y, _z, _u, _v, 1, 0, 0, _tile_col, _tile_alpha);
		vertex_position_3d(_vb, _x, _y, _z); vertex_texcoord(_vb, _u, _v); vertex_normal(_vb, 1, 0, 0); vertex_colour(_vb, _tile_col, _tile_alpha);
		//map_vb_add(_vb, _x2, _y2, _z, _u2, _v, 1, 0, 0, _tile_col, _tile_alpha);
		vertex_position_3d(_vb, _x2, _y2, _z); vertex_texcoord(_vb, _u2, _v); vertex_normal(_vb, 1, 0, 0); vertex_colour(_vb, _tile_col, _tile_alpha);
		//map_vb_add(_vb, _x2, _y2, _z2, _u2, _v2, 1, 0, 0, _tile_col, _tile_alpha);
		vertex_position_3d(_vb, _x2, _y2, _z2); vertex_texcoord(_vb, _u2, _v2); vertex_normal(_vb, 1, 0, 0); vertex_colour(_vb, _tile_col, _tile_alpha);
		// 2st tri
		//map_vb_add(_vb, _x, _y, _z, _u, _v, 1, 0, 0, _tile_col, _tile_alpha);
		vertex_position_3d(_vb, _x, _y, _z); vertex_texcoord(_vb, _u, _v); vertex_normal(_vb, 1, 0, 0); vertex_colour(_vb, _tile_col, _tile_alpha);
		//map_vb_add(_vb, _x2, _y2, _z2, _u2, _v2, 1, 0, 0, _tile_col, _tile_alpha);
		vertex_position_3d(_vb, _x2, _y2, _z2); vertex_texcoord(_vb, _u2, _v2); vertex_normal(_vb, 1, 0, 0); vertex_colour(_vb, _tile_col, _tile_alpha);
		//map_vb_add(_vb, _x, _y, _z2, _u, _v2, 1, 0, 0, _tile_col, _tile_alpha);
		vertex_position_3d(_vb, _x, _y, _z2); vertex_texcoord(_vb, _u, _v2); vertex_normal(_vb, 1, 0, 0); vertex_colour(_vb, _tile_col, _tile_alpha);
		//map_vb_add_wall_n(_vb, _wld_x + TILE_SZ, _wld_y, _wld_z, 0, TILE_SZ, TILE_SZ,
		//					_uvs[0], _uvs[1], _uvs[2], _uvs[3], 1, 0, 0, _tile_col, _tile_alpha);
	}
	// x-- wall
	if (_tx <= 0 || _tilelayer[_tx-1][_ty][_tz] != _layer)
	{
		var _uvs = _tile_data.textures[eSIDE.XN],
			_x = _wld_x, _y = _wld_y, _z = _wld_z,
			_x2 = _x, _y2 = _y + TILE_SZ, _z2 = _z + TILE_SZ,
			_u2 = _uvs[0], _v2 = _uvs[1],
			_u = _u2+_uvs[2], _v = _v2+_uvs[3],
			;
		// 1st tri
		//map_vb_add(_vb, _x, _y, _z, _u, _v, -1, 0, 0, _tile_col, _tile_alpha);
		vertex_position_3d(_vb, _x, _y, _z); vertex_texcoord(_vb, _u, _v); vertex_normal(_vb, -1, 0, 0); vertex_colour(_vb, _tile_col, _tile_alpha);
		//map_vb_add(_vb, _x2, _y2, _z2, _u2, _v2, -1, 0, 0, _tile_col, _tile_alpha);
		vertex_position_3d(_vb, _x2, _y2, _z2); vertex_texcoord(_vb, _u2, _v2); vertex_normal(_vb, -1, 0, 0); vertex_colour(_vb, _tile_col, _tile_alpha);
		//map_vb_add(_vb, _x2, _y2, _z, _u2, _v, -1, 0, 0, _tile_col, _tile_alpha);
		vertex_position_3d(_vb, _x2, _y2, _z); vertex_texcoord(_vb, _u2, _v); vertex_normal(_vb, -1, 0, 0); vertex_colour(_vb, _tile_col, _tile_alpha);
		// 2st tri
		//map_vb_add(_vb, _x, _y, _z, _u, _v, -1, 0, 0, _tile_col, _tile_alpha);
		vertex_position_3d(_vb, _x, _y, _z); vertex_texcoord(_vb, _u, _v); vertex_normal(_vb, -1, 0, 0); vertex_colour(_vb, _tile_col, _tile_alpha);
		//map_vb_add(_vb, _x, _y, _z2, _u, _v2, -1, 0, 0, _tile_col, _tile_alpha);
		vertex_position_3d(_vb, _x, _y, _z2); vertex_texcoord(_vb, _u, _v2); vertex_normal(_vb, -1, 0, 0); vertex_colour(_vb, _tile_col, _tile_alpha);
		//map_vb_add(_vb, _x2, _y2, _z2, _u2, _v2, -1, 0, 0, _tile_col, _tile_alpha);
		vertex_position_3d(_vb, _x2, _y2, _z2); vertex_texcoord(_vb, _u2, _v2); vertex_normal(_vb, -1, 0, 0); vertex_colour(_vb, _tile_col, _tile_alpha);
		//map_vb_add_wall_p(_vb, _wld_x, _wld_y, _wld_z, 0, TILE_SZ, TILE_SZ,
		//					_uvs[0], _uvs[1], _uvs[2], _uvs[3], -1, 0, 0, _tile_col, _tile_alpha);
	}
	// y++ wall
	if (_ty+1 >= _map_sy || _tilelayer[_tx][_ty+1][_tz] != _layer)
	{
		var _uvs = _tile_data.textures[eSIDE.YP],
			_x = _wld_x, _y = _wld_y + TILE_SZ, _z = _wld_z,
			_x2 = _x + TILE_SZ, _y2 = _y, _z2 = _z + TILE_SZ,
			_u2 = _uvs[0], _v2 = _uvs[1],
			_u = _u2+_uvs[2], _v = _v2+_uvs[3],
			;
		// 1st tri
		//map_vb_add(_vb, _x, _y, _z, _u, _v, -1, 0, 0, _tile_col, _tile_alpha);
		vertex_position_3d(_vb, _x, _y, _z); vertex_texcoord(_vb, _u, _v); vertex_normal(_vb, 0, 1, 0); vertex_colour(_vb, _tile_col, _tile_alpha);
		//map_vb_add(_vb, _x2, _y2, _z2, _u2, _v2, -1, 0, 0, _tile_col, _tile_alpha);
		vertex_position_3d(_vb, _x2, _y2, _z2); vertex_texcoord(_vb, _u2, _v2); vertex_normal(_vb, 0, 1, 0); vertex_colour(_vb, _tile_col, _tile_alpha);
		//map_vb_add(_vb, _x2, _y2, _z, _u2, _v, -1, 0, 0, _tile_col, _tile_alpha);
		vertex_position_3d(_vb, _x2, _y2, _z); vertex_texcoord(_vb, _u2, _v); vertex_normal(_vb, 0, 1, 0); vertex_colour(_vb, _tile_col, _tile_alpha);
		// 2st tri
		//map_vb_add(_vb, _x, _y, _z, _u, _v, -1, 0, 0, _tile_col, _tile_alpha);
		vertex_position_3d(_vb, _x, _y, _z); vertex_texcoord(_vb, _u, _v); vertex_normal(_vb, 0, 1, 0); vertex_colour(_vb, _tile_col, _tile_alpha);
		//map_vb_add(_vb, _x, _y, _z2, _u, _v2, -1, 0, 0, _tile_col, _tile_alpha);
		vertex_position_3d(_vb, _x, _y, _z2); vertex_texcoord(_vb, _u, _v2); vertex_normal(_vb, 0, 1, 0); vertex_colour(_vb, _tile_col, _tile_alpha);
		//map_vb_add(_vb, _x2, _y2, _z2, _u2, _v2, -1, 0, 0, _tile_col, _tile_alpha);
		vertex_position_3d(_vb, _x2, _y2, _z2); vertex_texcoord(_vb, _u2, _v2); vertex_normal(_vb, 0, 1, 0); vertex_colour(_vb, _tile_col, _tile_alpha);
		//map_vb_add_wall_p(_vb, _wld_x, _wld_y + TILE_SZ, _wld_z, TILE_SZ, 0, TILE_SZ,
		//					_uvs[0], _uvs[1], _uvs[2], _uvs[3], 0, 1, 0, _tile_col, _tile_alpha);
	}
	// y-- wall
	if (_ty <= 0 || _tilelayer[_tx][_ty-1][_tz] != _layer)
	{
		var _uvs = _tile_data.textures[eSIDE.YN],
			_x = _wld_x, _y = _wld_y, _z = _wld_z,
			_x2 = _x + TILE_SZ, _y2 = _y, _z2 = _z + TILE_SZ,
			_u2 = _uvs[0], _v2 = _uvs[1],
			_u = _u2+_uvs[2], _v = _v2+_uvs[3],
			;
		// 1st tri
		//map_vb_add(_vb, _x, _y, _z, _u, _v, 1, 0, 0, _tile_col, _tile_alpha);
		vertex_position_3d(_vb, _x, _y, _z); vertex_texcoord(_vb, _u, _v); vertex_normal(_vb, 0, -1, 0); vertex_colour(_vb, _tile_col, _tile_alpha);
		//map_vb_add(_vb, _x2, _y2, _z, _u2, _v, 1, 0, 0, _tile_col, _tile_alpha);
		vertex_position_3d(_vb, _x2, _y2, _z); vertex_texcoord(_vb, _u2, _v); vertex_normal(_vb, 0, -1, 0); vertex_colour(_vb, _tile_col, _tile_alpha);
		//map_vb_add(_vb, _x2, _y2, _z2, _u2, _v2, 1, 0, 0, _tile_col, _tile_alpha);
		vertex_position_3d(_vb, _x2, _y2, _z2); vertex_texcoord(_vb, _u2, _v2); vertex_normal(_vb, 0, -1, 0); vertex_colour(_vb, _tile_col, _tile_alpha);
		// 2st tri
		//map_vb_add(_vb, _x, _y, _z, _u, _v, 1, 0, 0, _tile_col, _tile_alpha);
		vertex_position_3d(_vb, _x, _y, _z); vertex_texcoord(_vb, _u, _v); vertex_normal(_vb, 0, -1, 0); vertex_colour(_vb, _tile_col, _tile_alpha);
		//map_vb_add(_vb, _x2, _y2, _z2, _u2, _v2, 1, 0, 0, _tile_col, _tile_alpha);
		vertex_position_3d(_vb, _x2, _y2, _z2); vertex_texcoord(_vb, _u2, _v2); vertex_normal(_vb, 0, -1, 0); vertex_colour(_vb, _tile_col, _tile_alpha);
		//map_vb_add(_vb, _x, _y, _z2, _u, _v2, 1, 0, 0, _tile_col, _tile_alpha);
		vertex_position_3d(_vb, _x, _y, _z2); vertex_texcoord(_vb, _u, _v2); vertex_normal(_vb, 0, -1, 0); vertex_colour(_vb, _tile_col, _tile_alpha);
		//map_vb_add_wall_n(_vb, _wld_x, _wld_y, _wld_z, TILE_SZ, 0, TILE_SZ,
		//					_uvs[0], _uvs[1], _uvs[2], _uvs[3], 0, -1, 0, _tile_col, _tile_alpha);
	}
}

// @desc Updates given chunk's VBs
function map_update_chunk (_cx, _cy, _cz)
{
	// Update chunk (single)
	var _map_sx = global.mapSize[0],
		_map_sy = global.mapSize[1],
		_map_sz = global.mapSize[2],
		_tilemap = global.mapTiles,
		_tilelayer = global.mapTilesLayer,
		_tiledef = global.defTiles,
		;
	var _vb_solid = vertex_create_buffer(),
		_vb_water = vertex_create_buffer(),
		_vb_groups = [_vb_solid, _vb_water], // one vb for each render group
		;
	
	// Build the chunk's VB
	vertex_begin(_vb_solid, global.mapTilemapVF);
	vertex_begin(_vb_water, global.mapTilemapVF);
	var _tx = _cx << MAP_CHUNK_BIT,
		_tx2 = min((_cx+1) << MAP_CHUNK_BIT, _map_sx),
		_ty = _cy << MAP_CHUNK_BIT,
		_ty2 = min((_cy+1) << MAP_CHUNK_BIT, _map_sy),
		_tz = _cz << MAP_CHUNK_BIT,
		_tz2 = min((_cz+1) << MAP_CHUNK_BIT, _map_sz);
	for (var tx=_tx; tx<_tx2; tx++)
	{
		for (var ty=_ty; ty<_ty2; ty++)
		{
			for (var tz=_tz; tz<_tz2; tz++)
			{
				map_update_chunk_block(_vb_groups, tx, ty, tz, _map_sx, _map_sy, _map_sz, _tilemap, _tilelayer, _tiledef);
			}
		}
	}
	vertex_end(_vb_solid);
	vertex_end(_vb_water);
				
	// Freeze vb and store to grid
	if (vertex_get_number(_vb_solid) > 0)
		vertex_freeze(_vb_solid);
	else
	{
		vertex_delete_buffer(_vb_solid);
		_vb_solid = undefined;
	}
	if (vertex_get_number(_vb_water) > 0)
		vertex_freeze(_vb_water);
	else
	{
		vertex_delete_buffer(_vb_water);
		_vb_water = undefined;
	}
	
	global.mapChunksVB[_cx][_cy][_cz] = [_vb_solid, _vb_water];
}

function map_update_chunks_updated ()
{
	show_debug_message("map> updating chunks...");
	var _time_begin = current_time;
	
	var _chunk_sx = global.mapChunkSize[0],
		_chunk_sy = global.mapChunkSize[1],
		_chunk_sz = global.mapChunkSize[2],
		;
	
	// Clear the previous vb
	map_destroy();
	
	// For all chunks update the tilemap vb
	for (var xx=0; xx<_chunk_sx; xx++)
	{
		for (var yy=0; yy<_chunk_sy; yy++)
		{
			for (var zz=0; zz<_chunk_sz; zz++)
			{
				if (global.mapChunkUpdated[xx][yy][zz])
				{
					show_debug_message("map> build chunk vb for " + string([xx, yy, zz]) );
					var _time = current_time;
					map_update_chunk(xx, yy, zz);
					show_debug_message("\t> done (" + string(current_time - _time) + " ms)");
				}
				
				// Reset chunk updated flag
				global.mapChunkUpdated[xx][yy][zz] = false;
			}
		}
	}
	
	show_debug_message("map> updating chunks done. (" + string(current_time - _time_begin) + " ms)");
}

/// @desc Prepares realtime / lazy chunk meshing
function map_update_chunks_updated_gradually_prep ()
{
	if (!generateMeshInit)
	{
		show_debug_message("map> updating chunks begin...");
	
		// Prepare the first VBs
		generateMeshChunkVBs = [vertex_create_buffer(), vertex_create_buffer()]; // list of VBs (one for each render layers)
		vertex_begin(generateMeshChunkVBs[0], global.mapTilemapVF);
		vertex_begin(generateMeshChunkVBs[1], global.mapTilemapVF);
		// Prepare the progress counters
		generateMeshBeginTime = current_time;
		generateMeshChunkBeginTime = current_time;
		generateMeshProgress = 0;
		generateMeshChunkX = 0;
		generateMeshChunkY = 0;
		generateMeshChunkZ = 0;
		generateMeshBlockX = 0;
		generateMeshBlockY = 0;
		generateMeshBlockZ = 0; // if generateMeshBlockZ == chunk tile size then it means we must move onto the next chunk
		generateMeshBlockBaseX = 0;
		generateMeshBlockBaseY = 0;
		generateMeshBlockBaseZ = 0;
		generateMeshDone = false;
		generateMeshInit = true;
		
		// Find first chunk to be updated
		while (!global.mapChunkUpdated[generateMeshChunkX][generateMeshChunkY][generateMeshChunkZ])
		{
			generateMeshChunkX++;
			if (generateMeshChunkX >= global.mapChunkSize[0]) // x axis overflow
			{
				generateMeshChunkX = 0;
				generateMeshChunkY++;
				if (generateMeshChunkY >= global.mapChunkSize[1]) // y axis overflow
				{
					generateMeshChunkY = 0;
					generateMeshChunkZ++;
					
					// Check if were done with updating chunks
					if (generateMeshChunkZ >= global.mapChunkSize[2])
					{
						generateMeshDone = true;
						break;
					}
				}
			}
		}
		generateMeshProgress =	(generateMeshChunkX << MAP_CHUNK_BIT) +
								((global.mapChunkSize[0] * generateMeshChunkY) << MAP_CHUNK_BIT) +
								((global.mapChunkSize[0] * global.mapChunkSize[1] * generateMeshChunkZ) << MAP_CHUNK_BIT);
		generateMeshBlockBaseX = (generateMeshChunkX << MAP_CHUNK_BIT);
		generateMeshBlockBaseY = (generateMeshChunkY << MAP_CHUNK_BIT);
		generateMeshBlockBaseZ = (generateMeshChunkZ << MAP_CHUNK_BIT);
	}
}

/// @desc Processes as many blocks & chunks VB in given time window before returning control to main game loop (aka lazy update)
function map_update_chunks_updated_gradually ()
{
	var _time_begin = current_time;	
	var _map_sx = global.mapSize[0],
		_map_sy = global.mapSize[1],
		_map_sz = global.mapSize[2],
		_chunk_sx = global.mapChunkSize[0],
		_chunk_sy = global.mapChunkSize[1],
		_chunk_sz = global.mapChunkSize[2],
		_tilemap = global.mapTiles,
		_tilelayer = global.mapTilesLayer,
		_tiledef = global.defTiles,
		;
	
	// Do as many stuffs as possible in allocated time
	while (!generateMeshDone && (current_time - _time_begin) < generateMeshAllocatedTime)
	{
		// Update current block
		if (generateMeshBlockZ < MAP_CHUNK_SZ) // still more blocks to update
		{
			map_update_chunk_block(generateMeshChunkVBs,
							generateMeshBlockBaseX + generateMeshBlockX,
							generateMeshBlockBaseY + generateMeshBlockY,
							generateMeshBlockBaseZ + generateMeshBlockZ,
							_map_sx, _map_sy, _map_sz, _tilemap, _tilelayer, _tiledef);
		
			// Onto the next block
			generateMeshProgress++;
			generateMeshBlockX++;
			if (generateMeshBlockX >= MAP_CHUNK_SZ) // x axis overflow
			{
				generateMeshBlockX = 0;
				generateMeshBlockY++;
				if (generateMeshBlockY >= MAP_CHUNK_SZ) // y axis overflow
				{
					generateMeshBlockY = 0;
					generateMeshBlockZ++;
				}
			}
		}
		else // move onto next chunk
		{
			// Before that finish the current chunk's vertex buffer
			vertex_end(generateMeshChunkVBs[0]);
			vertex_end(generateMeshChunkVBs[1]);
			if (vertex_get_number(generateMeshChunkVBs[0]))
				vertex_freeze(generateMeshChunkVBs[0]);
			else
			{
				vertex_delete_buffer(generateMeshChunkVBs[0]);
				generateMeshChunkVBs[0] = undefined;
			}
			if (vertex_get_number(generateMeshChunkVBs[1]))
				vertex_freeze(generateMeshChunkVBs[1]);
			else
			{
				vertex_delete_buffer(generateMeshChunkVBs[1]);
				generateMeshChunkVBs[1] = undefined;
			}
			show_debug_message("map> building chunk vb for " + string([generateMeshChunkX, generateMeshChunkY, generateMeshChunkZ]) + " done (" + string(current_time - generateMeshChunkBeginTime) + " ms)");
			// Reset chunk updated flag & replace actual rendered VB for chunk
			var _vbs = global.mapChunksVB[generateMeshChunkX][generateMeshChunkY][generateMeshChunkZ];
			if (_vbs[0] != undefined)
				vertex_delete_buffer(_vbs[0]);
			if (_vbs[1] != undefined)
				vertex_delete_buffer(_vbs[1]);
			global.mapChunkUpdated[generateMeshChunkX][generateMeshChunkY][generateMeshChunkZ] = false;
			global.mapChunksVB[generateMeshChunkX][generateMeshChunkY][generateMeshChunkZ] = generateMeshChunkVBs;
		
			// Update next chunk & block positions
			var _found = false;
			while (!_found)
			{
				// Update currently updating chunk position
				generateMeshChunkX++;
				if (generateMeshChunkX >= _chunk_sx) // x axis overflow
				{
					generateMeshChunkX = 0;
					generateMeshChunkY++;
					if (generateMeshChunkY >= _chunk_sy) // y axis overflow
					{
						generateMeshChunkY = 0;
						generateMeshChunkZ++;
						
						// Check if were done with updating chunks
						if (generateMeshChunkZ >= _chunk_sz)
						{
							generateMeshDone = true;
							break;
						}
					}
				}
			
				// Check if current chunk requires updating
				var _updated = global.mapChunkUpdated[generateMeshChunkX][generateMeshChunkY][generateMeshChunkZ];
				if (_updated)
				{
					show_debug_message("map> building chunk vb for " + string([generateMeshChunkX, generateMeshChunkY, generateMeshChunkZ]) + "...");
					generateMeshChunkBeginTime = current_time;
					generateMeshBlockX = 0;
					generateMeshBlockY = 0;
					generateMeshBlockZ = 0;
					generateMeshBlockBaseX = (generateMeshChunkX << MAP_CHUNK_BIT);
					generateMeshBlockBaseY = (generateMeshChunkY << MAP_CHUNK_BIT);
					generateMeshBlockBaseZ = (generateMeshChunkZ << MAP_CHUNK_BIT);
					generateMeshChunkVBs = [vertex_create_buffer(), vertex_create_buffer()]; // list of VBs (one for each render layers)
					vertex_begin(generateMeshChunkVBs[0], global.mapTilemapVF);
					vertex_begin(generateMeshChunkVBs[1], global.mapTilemapVF);
					break;
				}
			}
		
			if (generateMeshDone)
			{
				show_debug_message("map> updating chunks done. (" + string(current_time - generateMeshBeginTime) + " ms)");
			}
		}
	}
}

function map_update_chunks_all ()
{
	show_debug_message("map> updating chunks...");
	var _time_begin = current_time;
	
	var _chunk_sx = global.mapChunkSize[0],
		_chunk_sy = global.mapChunkSize[1],
		_chunk_sz = global.mapChunkSize[2],
		;
	
	// Clear the previous vb
	map_destroy();
	
	// For all chunks update the tilemap vb
	for (var xx=0; xx<_chunk_sx; xx++)
	{
		for (var yy=0; yy<_chunk_sy; yy++)
		{
			for (var zz=0; zz<_chunk_sz; zz++)
			{
				show_debug_message("map> build chunk vb for " + string([xx, yy, zz]) );
				var _time = current_time;
				map_update_chunk(xx, yy, zz);
				show_debug_message("\t> done (" + string(current_time - _time) + " ms)");
				
				// Reset chunk updated flag
				global.mapChunkUpdated[xx][yy][zz] = false;
			}
		}
	}
	
	show_debug_message("map> updating chunks done. (" + string(current_time - _time_begin) + " ms)");
}
