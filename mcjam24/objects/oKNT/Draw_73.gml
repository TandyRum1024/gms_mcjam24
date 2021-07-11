/// @description End 3D

// Draw the water render layer finally
matrix_set(matrix_world, MAT_IDENTITY);

// 2] Water layer
shader_set(shd_tilemap_water);
shader_set_uniform_f(shader_get_uniform(shd_tilemap_water, "uTime"), current_time * 0.001);

gpu_set_alphatestenable(false); // alpha testing
while (!ds_queue_empty(renderQueueWater))
	vertex_submit(ds_queue_dequeue(renderQueueWater), pr_trianglelist, global.texAtlasTex);
shader_reset();

// Reset state
gpu_set_state(gameRenderstatePrevious);
