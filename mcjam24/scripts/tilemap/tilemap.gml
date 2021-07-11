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
	// Set tile
	global.mapTiles[_tx][_ty][_tz] = _tile;
	// Update chunk
	map_update_chunk(_tx>>MAP_CHUNK_BIT, _ty>>MAP_CHUNK_BIT, _tz>>MAP_CHUNK_BIT);
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
			}
		}
	}
}

function map_update_chunk (_cx, _cy, _cz)
{
	// Update chunk (single)
	var _map_sx = global.mapSize[0],
		_map_sy = global.mapSize[1],
		_map_sz = global.mapSize[2],
		_tilemap = global.mapTiles,
		_tiledef = global.defTiles,
		;
	var _vb_solid = vertex_create_buffer(),
		_vb_water = vertex_create_buffer(),
		_vb_groups = [_vb_solid, _vb_water], // one vb for each render group
		;
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
				var _tile = _tilemap[tx][ty][tz], // tile type
					;
				if (_tile != 0)
				{
					// Get tile data
					var _tile_data = _tiledef[_tile],
						_tile_col = c_white,
						_tile_alpha = _tile_data.alpha,
						_tile_layer = _tile_data.layer,
						_vb = _vb_groups[_tile_layer],
						;
								
					// Fill vb with tile mesh
					var _wld_x = tx << TILE_BIT,
						_wld_y = ty << TILE_BIT,
						_wld_z = tz << TILE_BIT,
						;
					#region lava hack
					/*
					// z++ floor
					if (tz+1 >= _map_sz || _tilemap[tx][ty][tz+1] <= eTILES.LAVA)
					{
						var _uvs = _tile_data.textures[eSIDE.ZP];
						map_vb_add_floor_p(_vb, _wld_x, _wld_y, _wld_z + TILE_SZ, TILE_SZ, TILE_SZ, 0,
											_uvs[0], _uvs[1], _uvs[2], _uvs[3], _tile_col, _tile_alpha);
					}
					// z-- floor
					if (tz <= 0 || _tilemap[tx][ty][tz-1] <= eTILES.LAVA)
					{
						var _uvs = _tile_data.textures[eSIDE.ZN];
						map_vb_add_floor_n(_vb, _wld_x, _wld_y, _wld_z, TILE_SZ, TILE_SZ, 0,
											_uvs[0], _uvs[1], _uvs[2], _uvs[3], _tile_col, _tile_alpha);
					}
					// x++ wall
					if (tx+1 >= _map_sx || _tilemap[tx+1][ty][tz] <= eTILES.LAVA)
					{
						var _uvs = _tile_data.textures[eSIDE.XP];
						map_vb_add_wall_n(_vb, _wld_x + TILE_SZ, _wld_y, _wld_z, 0, TILE_SZ, TILE_SZ,
											_uvs[0], _uvs[1], _uvs[2], _uvs[3], _tile_col, _tile_alpha);
					}
					// x-- wall
					if (tx <= 0 || _tilemap[tx-1][ty][tz] <= eTILES.LAVA)
					{
						var _uvs = _tile_data.textures[eSIDE.XN];
						map_vb_add_wall_p(_vb, _wld_x, _wld_y, _wld_z, 0, TILE_SZ, TILE_SZ,
											_uvs[0], _uvs[1], _uvs[2], _uvs[3], _tile_col, _tile_alpha);
					}
					// y++ wall
					if (ty+1 >= _map_sy || _tilemap[tx][ty+1][tz] <= eTILES.LAVA)
					{
						var _uvs = _tile_data.textures[eSIDE.YP];
						map_vb_add_wall_p(_vb, _wld_x, _wld_y + TILE_SZ, _wld_z, TILE_SZ, 0, TILE_SZ,
											_uvs[0], _uvs[1], _uvs[2], _uvs[3], _tile_col, _tile_alpha);
					}
					// y-- wall
					if (ty <= 0 || _tilemap[tx][ty-1][tz] <= eTILES.LAVA)
					{
						var _uvs = _tile_data.textures[eSIDE.YN];
						map_vb_add_wall_n(_vb, _wld_x, _wld_y, _wld_z, TILE_SZ, 0, TILE_SZ,
											_uvs[0], _uvs[1], _uvs[2], _uvs[3], _tile_col, _tile_alpha);
					}*/
					#endregion
					#region proper
					
					// z++ floor
					if (tz+1 >= _map_sz || _tiledef[_tilemap[tx][ty][tz+1]].layer != _tile_layer)
					{
						var _uvs = _tile_data.textures[eSIDE.ZP];
						map_vb_add_floor_p(_vb, _wld_x, _wld_y, _wld_z + TILE_SZ, TILE_SZ, TILE_SZ, 0,
											_uvs[0], _uvs[1], _uvs[2], _uvs[3], 0, 0, 1, _tile_col, _tile_alpha);
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
					
					#endregion
				}
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
