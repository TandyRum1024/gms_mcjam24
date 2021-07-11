/// @description Debug draw
if (global.debugPhysics)
{
	matrix_set(matrix_world, matrix_build(x, y, z, 0, 0, 0, sx, sy, sz));
	vertex_submit(global.meshWireboxCenter, pr_linelist, -1);
}
