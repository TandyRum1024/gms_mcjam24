/// @description Draw tilemap
// For all chunks add to the render queue
var _chunk_sx = global.mapChunkSize[0],
	_chunk_sy = global.mapChunkSize[1],
	_chunk_sz = global.mapChunkSize[2],
	;

ds_queue_clear(renderQueueSolid);
ds_queue_clear(renderQueueWater);
for (var xx=0; xx<_chunk_sx; xx++)
{
	for (var yy=0; yy<_chunk_sy; yy++)
	{
		for (var zz=0; zz<_chunk_sz; zz++)
		{
			var _chunk_vb = global.mapChunksVB[xx][yy][zz],
				_layer_solid = _chunk_vb[0],
				_layer_water = _chunk_vb[1],
				;
			// Solid layer
			if (_layer_solid != undefined)
				ds_queue_enqueue(renderQueueSolid, _layer_solid);
			// Water layer
			if (_layer_water != undefined)
				ds_queue_enqueue(renderQueueWater, _layer_water);
		}
	}
}

// Draw the solid render layer first 
matrix_set(matrix_world, MAT_IDENTITY);

// 1] Solid layer
gpu_set_alphatestenable(true); // alpha testing
gpu_set_alphatestref(0);

shader_set(shd_tilemap);
while (!ds_queue_empty(renderQueueSolid))
	vertex_submit(ds_queue_dequeue(renderQueueSolid), pr_trianglelist, global.texAtlasTex);
shader_reset();

// Debug axis helper
/*
var _x = -32, _y = -32, _z = 0,
	_vb = vertex_create_buffer();
vertex_begin(_vb, global.mapTilemapVF);
map_vb_add(_vb, _x, _y, _z, 0, 0, 0, 0, 0, c_red, 1);
map_vb_add(_vb, _x + TILE_SZ, _y, _z, 0, 0, 0, 0, 0, c_red, 1);

map_vb_add(_vb, _x, _y, _z, 0, 0, 0, 0, 0, c_green, 1);
map_vb_add(_vb, _x, _y + TILE_SZ, _z, 0, 0, 0, 0, 0, c_green, 1);

map_vb_add(_vb, _x, _y, _z, 0, 0, 0, 0, 0, c_blue, 1);
map_vb_add(_vb, _x, _y, _z + TILE_SZ, 0, 0, 0, 0, 0, c_blue, 1);
vertex_end(_vb);
vertex_submit(_vb, pr_linelist, -1);
vertex_delete_buffer(_vb);
*/