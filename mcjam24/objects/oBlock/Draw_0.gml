/// @description Draw block
var _tile_data = global.defTiles[tile], _tile_uvs = _tile_data.textures;
matrix_set(matrix_world, matrix_build(x, y, z, rx, ry, rz, TILE_SZ, TILE_SZ, TILE_SZ));

shader_set(shd_tile);
var _uvs = shader_get_uniform(shd_tile, "uUVs");

shader_set_uniform_f_array(_uvs, _tile_uvs[eSIDE.XP]);
vertex_submit(global.meshTileXP, pr_trianglelist, global.texAtlasTex);

shader_set_uniform_f_array(_uvs, _tile_uvs[eSIDE.YP]);
vertex_submit(global.meshTileYP, pr_trianglelist, global.texAtlasTex);

shader_set_uniform_f_array(_uvs, _tile_uvs[eSIDE.ZP]);
vertex_submit(global.meshTileZP, pr_trianglelist, global.texAtlasTex);

shader_set_uniform_f_array(_uvs, _tile_uvs[eSIDE.XN]);
vertex_submit(global.meshTileXN, pr_trianglelist, global.texAtlasTex);

shader_set_uniform_f_array(_uvs, _tile_uvs[eSIDE.YN]);
vertex_submit(global.meshTileYN, pr_trianglelist, global.texAtlasTex);

shader_set_uniform_f_array(_uvs, _tile_uvs[eSIDE.ZN]);
vertex_submit(global.meshTileZN, pr_trianglelist, global.texAtlasTex);

shader_reset();