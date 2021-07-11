// Global definitions
global.mapHeightmap = undefined;
global.mapTiles = [];
global.mapChunksVB = [];

function map_debug_onstep () 
{
	// keep surface alive
	if (!surface_exists(global.mapTiles))
		global.mapTiles = surface_create(global.mapSize[0], global.mapSize[1]);
}

function map_generate (_sx, _sy, _sz, _heightmap_shader, _seed)
{
	var _chunk_sx = ceil(_sx / MAP_CHUNK_SZ),
		_chunk_sy = ceil(_sy / MAP_CHUNK_SZ),
		_chunk_sz = ceil(_sz / MAP_CHUNK_SZ),
		;
	
	if (_heightmap_shader == undefined)
		_heightmap_shader = shd_mapgen_heightmap;
	if (_seed == undefined)
	{
		randomize();
		_seed = random_get_seed();
	}
	
	// Generate heightmap
	var _surf = surface_create(_sx, _sy);
	global.mapHeightmap = _surf;
	shader_set(_heightmap_shader);
	shader_set_uniform_i(shader_get_uniform(_heightmap_shader, "uSeed"), _seed);
	
	surface_set_target(_surf);
		draw_primitive_begin(pr_trianglefan);
		draw_vertex_texture(0, 0, 0, 0); // tl
		draw_vertex_texture(_sx, 0, 1, 0); // tr
		draw_vertex_texture(_sx, _sy, 1, 1); // br
		draw_vertex_texture(0, _sy, 0, 1); // bl
		draw_primitive_end();
	surface_reset_target();
	shader_reset();
	
	// Read from heightmap
	var _buff = buffer_create(4*_sx*_sy, buffer_grow, 1);
	buffer_get_surface(_buff, _surf, 0);
	
	// Clear tiles
	var _tilemap = [];
	global.mapTiles = _tilemap;
	for (var xx=0; xx<_sx; xx++)
	{
		for (var yy=0; yy<_sy; yy++)
		{
			for (var zz=0; zz<_sz; zz++)
			{
				_tilemap[xx][yy][zz] = 0;
			}
		}
	}
	
	// Reset chunk updated flag & chunk VB
	var _chunk_updated = [],
		_chunk_vb = [],
		;
	global.mapChunkUpdated = _chunk_updated;
	global.mapChunksVB = _chunk_vb;
	for (var xx=0; xx<_chunk_sx; xx++)
	{
		for (var yy=0; yy<_chunk_sy; yy++)
		{
			for (var zz=0; zz<_chunk_sz; zz++)
			{
				_chunk_updated[xx][yy][zz] = false;
				_chunk_vb[xx][yy][zz] = [undefined, undefined];
			}
		}
	}
	
	// Fill the tiles
	static	
			HEIGHT_SAND = 5,
			HEIGHT_LAVA = 4
	
	for (var xx=0; xx<_sx; xx++)
	{
		for (var yy=0; yy<_sy; yy++)
		{
			// Fetch r channel from buffer
			var _idx = ((xx + yy * _sx) << 2) + 2,
				_map_r = (buffer_peek(_buff, _idx, buffer_u8) / 255); // 0..1
			
			var _HEIGHT_DIRT = floor(max(7 - power(_map_r, 3.0) * 8, 0));
			
			// "Stack" the tiles according to its height
			var _height = round(_map_r * _sz);
			for (var zz=0; zz<=_height; zz++)
			{
				var _type = eTILES.STONE;
				if (zz < _height - _HEIGHT_DIRT)
					_type = eTILES.STONE; // stone
				else
				{
					if (_height <= HEIGHT_SAND)
						_type = eTILES.SAND; // sand
					else if (zz == _height)
						_type = eTILES.GRASS; // grass
					else
						_type = eTILES.DIRT; // dirt
				}
				_tilemap[xx][yy][zz] = _type;
				
				// update chunk updated flag
				_chunk_updated[xx >> MAP_CHUNK_BIT][yy >> MAP_CHUNK_BIT][zz >> MAP_CHUNK_BIT] = true;
			}
			
			// Add water... except it's very hot
			for (var zz=_height+1; zz<=HEIGHT_LAVA; zz++)
			{
				_tilemap[xx][yy][zz] = eTILES.LAVA;
				
				// update chunk updated flag
				_chunk_updated[xx >> MAP_CHUNK_BIT][yy >> MAP_CHUNK_BIT][zz >> MAP_CHUNK_BIT] = true;
			}
		}
	}
	
	// Sprinkle some guys
	instance_destroy(oGuy);
	repeat (irandom_range(4, 8))
	{
		var _cx = ((_sx >> 1) << TILE_BIT) + random_range(-64, 64),
			_cy = ((_sy >> 1) << TILE_BIT) + random_range(-64, 64),
		;
		with (instance_create_layer(_cx, _cy, "inst", oGuy))
		{
			z = (_sz << TILE_BIT) - 64;
		}
	}
	
	// Cleanup
	buffer_delete(_buff);
	
	// Update chunk & map size
	global.mapSize = [_sx, _sy, _sz];
	global.mapChunkSize = [_chunk_sx, _chunk_sy, _chunk_sz];
}

