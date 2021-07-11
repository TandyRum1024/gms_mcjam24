/// @description Prepare 3D
// Set camera
var _cam = camera_get_active();
camera_set_view_mat(_cam, camera.matV);
camera_set_proj_mat(_cam, camera.matP);
camera_apply(_cam);

gameRenderstatePrevious = gpu_get_state();

// Draw skybox behind everything
//draw_clear(global.skyboxColTop);
matrix_set(matrix_world, matrix_build(camera.x, camera.y, camera.z, 0, 0, 0, global.skyboxScale, global.skyboxScale, global.skyboxScale));
gpu_set_cullmode(cull_noculling);
gpu_set_ztestenable(true); // depth test
gpu_set_zwriteenable(false); // depth writing
gpu_set_zfunc(cmpfunc_always);
vertex_submit(global.meshSkybox, pr_trianglestrip, -1);

// Set render state
gpu_set_ztestenable(true); // depth test
gpu_set_zwriteenable(true); // depth writing
gpu_set_zfunc(cmpfunc_lessequal);
gpu_set_cullmode(cull_clockwise);
