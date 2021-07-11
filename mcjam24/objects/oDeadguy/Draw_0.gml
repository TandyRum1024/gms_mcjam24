/// @description Draw dead guy
var _cam = oKNT.camera;
gpu_set_alphatestenable(true); // alpha testing
gpu_set_alphatestref(0);

matrix_set(matrix_world, matrix_build(x, y, z, -_cam.rotV + 90, 0, _cam.rotH - 90, 1, 1, 1));
draw_sprite_ext(sprite_index, image_index, 0, 0, image_xscale, image_yscale, life * 5, image_blend, image_alpha);
