/// @description Insert description here
// You can write your code in this editor

if (generateRequest > 0)
{
	global.mouseLock = false;
	generateRequest--;
}
else if (generateRequest == 0)
{
	//global.mapSize = [64, 64, 32];
	global.mapSize = [irandom_range(32, 128), irandom_range(32, 128), irandom_range(24, 48)];
	
	// Generate done
	map_generate(global.mapSize[0], global.mapSize[1], global.mapSize[2]);
	
	// to next progress
	generateRequest = -1;
	// generateMeshProgress = 0;
	generateMeshInit = false;
	map_update_chunks_updated_gradually_prep();
	// Clear the previous VBs
	map_destroy();
}
else if (generateRequest == -1)
{
	// Build VB
	// map_update_chunks_updated();
	generateMeshAllocatedTime = generateMeshAllocatedTimeFirstGen;
	map_update_chunks_updated_gradually();
	
	// Hold player in place
	with (player)
	{
		x = (global.mapSize[0] >> 1) << TILE_BIT;
		y = (global.mapSize[1] >> 1) << TILE_BIT;
		z = (global.mapSize[2] + 3) << TILE_BIT;
	}
	
	// Done
	if (generateMeshDone)
	{
		show_debug_message("ALL CHUNKS MESHGEN DONE");
		global.mouseLock = true;
		generateMeshAllocatedTime = generateMeshAllocatedTimeNormal;
		generateRequest = -2;
	}
}

// Map regen button
if (keyboard_check_pressed(vk_f5))
{
	generateRequest = 1;
}

#region Screen resizing
var _ww = window_get_width(), _wh = window_get_height();
if (_ww != 0 && _ww != winW ||
	_wh != 0 && _wh != winH)
{
	// resize surface
	surface_resize(application_surface, _ww, _wh);
	display_set_gui_size(_ww, _wh);
	
	winW = _ww;
	winH = _wh;
}
#endregion

#region Camera
// FPS cam & Player pilot
var _cam_pan_x = 0, _cam_pan_y = 0, _plr = player, _dist = cameraOrbitDist;
if (global.mouseLock)
{
	var _mx = window_mouse_get_x(),
		_my = window_mouse_get_y(),
		_cx = window_get_width() >> 1,
		_cy = window_get_height() >> 1,
		_dx = _mx - _cx,
		_dy = _my - _cy,
		;
	
	_cam_pan_x = (_dx/_cx) * 360 * global.mouseSensitivity;
	_cam_pan_y = (_dy/_cy) * 360 * global.mouseSensitivity;
	window_mouse_set(_cx, _cy);
	
	if (keyboard_check_pressed(vk_tab) || !window_has_focus() || os_is_paused())
		global.mouseLock = false;
}
else
{
	if (keyboard_check_pressed(vk_tab))
		global.mouseLock = true;
}

with (camera)
{
	rotH += _cam_pan_x;
	rotV = clamp(rotV + _cam_pan_y, -89, 89);
	update();
	
	if (instance_exists(_plr))
	{
		x = _plr.x;
		y = _plr.y;
		z = _plr.eyeZ;
		update();
	}
	
	audio_listener_position(x, y, z);
	audio_listener_orientation(x-fwdX, y-fwdY, z+fwdZ, 0, 0, 1);
	audio_falloff_set_model(audio_falloff_exponent_distance);
}
with (oPlayer)
{
	aimX = other.camera.fwdX;
	aimY = other.camera.fwdY;
	aimZ = other.camera.fwdZ;
	
	groundFwdX = other.camera.fwdAimX;
	groundFwdY = other.camera.fwdAimY;
	groundFwdZ = other.camera.fwdAimZ;
	groundSideX = other.camera.sideX;
	groundSideY = other.camera.sideY;
	groundSideZ = other.camera.sideZ;
}
/*
var _fwd = keyboard_check(ord("W")) - keyboard_check(ord("S")),
	_sid = keyboard_check(ord("A")) - keyboard_check(ord("D")),
	_rise = keyboard_check(vk_space) - keyboard_check(vk_control),
	_speed = 4,
	;
with (camera)
{
	x += (fwdX * _fwd + sideX * _sid) * _speed;
	y += (fwdY * _fwd + sideY * _sid) * _speed;
	z += (fwdZ * _fwd + sideZ * _sid) * _speed + _rise * _speed;
	update();
}*/
#endregion

if (generateRequest == -2)
{
	// Build all the updated chunks VBs gradually
	if (!generateMeshInit)
		map_update_chunks_updated_gradually_prep();
	if (!generateMeshDone)
		map_update_chunks_updated_gradually();
}

#region Debug UI
if (global.debugUI)
{
	imguigml_set_window_pos("mapgen", 32, 32, EImGui_Cond.Once);
	imguigml_set_window_size("mapgen", 256, 256, EImGui_Cond.Once);
	if (imguigml_begin("mapgen", undefined)[0])
	{
		// Map regen button
		if (imguigml_button("regen"))
		{
			map_generate(global.mapSize[0], global.mapSize[1], global.mapSize[2]);
			map_update_chunks_updated();
		}
		
		// Draw heightmap texture
		var _tex_pos = imguigml_get_cursor_screen_pos();
		imguigml_drawlist_add_surface(global.mapHeightmap, _tex_pos[0], _tex_pos[1]);
		
		imguigml_end();
	}
	
	imguigml_set_window_pos("debug", window_get_width() - 256, 32, EImGui_Cond.Once);
	imguigml_set_window_size("debug", 256, 256, EImGui_Cond.Once);
	if (imguigml_begin("debug", undefined)[0])
	{
		imguigml_begin_tab_bar("debug_tab");
		{
			// Performance
			imguigml_begin_tab_item("perf");
			{
				imguigml_text_colored(1, 1, 1, 1, "fps: ");
				imguigml_same_line();
				imguigml_text_colored(1, 0.5, 0, 1, string(fps) + " ");
				imguigml_same_line();
				imguigml_text_colored(1, 0.5, 0, 1, fps_real);
				
				imguigml_end_tab_item();
			}
			// Camera
			imguigml_begin_tab_item("camera");
			{
				// position
				imguigml_text_colored(1, 1, 1, 1, "pos: ");
				imguigml_same_line();
				imguigml_text_colored(1, 0.5, 0, 1, [camera.x, camera.y, camera.z]);
				// rotation
				imguigml_text_colored(1, 1, 1, 1, "rot h/v: ");
				imguigml_same_line();
				imguigml_text_colored(1, 0.5, 0, 1, [camera.rotH, camera.rotV]);
				// fwd/side vec
				imguigml_text_colored(1, 1, 1, 1, "fwd: ");
				imguigml_same_line();
				imguigml_text_colored(1, 0.5, 0, 1, [camera.fwdX, camera.fwdY, camera.fwdZ]);
				imguigml_text_colored(1, 1, 1, 1, "side: ");
				imguigml_same_line();
				imguigml_text_colored(1, 0.5, 0, 1, [camera.sideX, camera.sideY, camera.sideZ]);
				
				imguigml_end_tab_item();
			}
			
			imguigml_end_tab_bar();
		}
		
		imguigml_end();
	}
}
#endregion