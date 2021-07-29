/// @description Draw UI
function __draw_tile (_x, _y, _sz, _tile)
{
	var _tile_data = global.defTiles[_tile],
		_tile_top_uvs = _tile_data.textures[eSIDE.ZP],
		_tile_xp_uvs = _tile_data.textures[eSIDE.XP],
		_tile_yp_uvs = _tile_data.textures[eSIDE.YP],
		;
	draw_primitive_begin_texture(pr_trianglelist, global.texAtlasTex);
		// top
		draw_vertex_texture_color(_x, _y,
									_tile_top_uvs[0], _tile_top_uvs[1]+_tile_top_uvs[3], c_white, 1);
		draw_vertex_texture_color(_x-_sz, _y-_sz*0.5,
									_tile_top_uvs[0], _tile_top_uvs[1], c_white, 1);
		draw_vertex_texture_color(_x, _y-_sz,
									_tile_top_uvs[0]+_tile_top_uvs[2], _tile_top_uvs[1], c_white, 1);
			
		draw_vertex_texture_color(_x, _y,
									_tile_top_uvs[0], _tile_top_uvs[1]+_tile_top_uvs[3], c_white, 1);
		draw_vertex_texture_color(_x, _y-_sz,
									_tile_top_uvs[0]+_tile_top_uvs[2], _tile_top_uvs[1], c_white, 1);
		draw_vertex_texture_color(_x+_sz, _y-_sz*0.5,
									_tile_top_uvs[0]+_tile_top_uvs[2], _tile_top_uvs[1]+_tile_top_uvs[3], c_white, 1);
		// y++
		draw_vertex_texture_color(_x, _y,
									_tile_yp_uvs[0], _tile_yp_uvs[1], c_ltgray, 1);
		draw_vertex_texture_color(_x+_sz, _y-_sz*0.5,
									_tile_yp_uvs[0]+_tile_yp_uvs[2], _tile_yp_uvs[1], c_ltgray, 1);
		draw_vertex_texture_color(_x, _y+_sz,
									_tile_yp_uvs[0], _tile_yp_uvs[1]+_tile_yp_uvs[3], c_ltgray, 1);
			
		draw_vertex_texture_color(_x, _y+_sz,
									_tile_yp_uvs[0], _tile_yp_uvs[1]+_tile_yp_uvs[3], c_ltgray, 1);
		draw_vertex_texture_color(_x+_sz, _y-_sz*0.5,
									_tile_yp_uvs[0]+_tile_yp_uvs[2], _tile_yp_uvs[1], c_ltgray, 1);
		draw_vertex_texture_color(_x+_sz, _y+_sz*0.5,
									_tile_yp_uvs[0]+_tile_yp_uvs[2], _tile_yp_uvs[1]+_tile_yp_uvs[3], c_ltgray, 1);
			
		// x++
		draw_vertex_texture_color(_x, _y,
									_tile_xp_uvs[0]+_tile_xp_uvs[2], _tile_xp_uvs[1], c_ltgray, 1);
		draw_vertex_texture_color(_x-_sz, _y-_sz*0.5,
									_tile_yp_uvs[0], _tile_yp_uvs[1], c_ltgray, 1);
		draw_vertex_texture_color(_x, _y+_sz,
									_tile_xp_uvs[0]+_tile_yp_uvs[2], _tile_xp_uvs[1]+_tile_xp_uvs[3], c_ltgray, 1);
			
		draw_vertex_texture_color(_x, _y+_sz,
									_tile_xp_uvs[0]+_tile_yp_uvs[2], _tile_xp_uvs[1]+_tile_xp_uvs[3], c_ltgray, 1);
		draw_vertex_texture_color(_x-_sz, _y-_sz*0.5,
									_tile_yp_uvs[0], _tile_yp_uvs[1], c_ltgray, 1);
		draw_vertex_texture_color(_x-_sz, _y+_sz*0.5,
									_tile_yp_uvs[0], _tile_yp_uvs[1]+_tile_yp_uvs[3], c_ltgray, 1);
	draw_primitive_end();
}

// UI
var _tx = window_get_width() - 16,
	_ty = 16,
	_str = "WASD and SPACE to move\nTAB to toggle mouselook (" + (global.mouseLock ? "ENABLED" : "DISABLED") + ")\nF5 to re-generate the island\nRMB to pick-er-up\nLMB to YEET\nR for RAT, T for DINK\nG to spawn a block below you\nMMXXI ZIK"
	;
draw_set_halign(2); draw_set_valign(0);
draw_text_color(_tx + 2, _ty + 2, _str, c_black, c_black, c_black, c_black, 1.0);
draw_text_color(_tx, _ty, _str, c_yellow, c_yellow, c_yellow, c_yellow, 1.0);

// Viewmodel
if (instance_exists(player))
{
	var _viewmodel_scale = 4,
		_viewmodel_spr = [sprViewmodel, 0],
		_viewmodel_tiles = player.playerHoldingTile,
		;
	if (!ds_list_empty(_viewmodel_tiles)) // player is holding something
	{
		_viewmodel_spr = [sprViewmodel, 2];
	}
	else if (player.playerAimTile != eTILES.AIR) // player can grab something
	{
		_viewmodel_spr = [sprViewmodel, 1];
	}
	
	// draw the viewmodel sprite
	var _viewmodel_x = window_get_width(),
		_viewmodel_y = window_get_height(),
		_viewmodel_tile_x = _viewmodel_x - sprite_get_width(_viewmodel_spr[0]) * _viewmodel_scale * 0.5,
		_viewmodel_tile_y = _viewmodel_y - sprite_get_height(_viewmodel_spr[0]) * _viewmodel_scale * 0.5 - (16 + sin(current_time * 0.002 * pi) * 16) * _viewmodel_scale,
		_viewmodel_tile_sz = sprite_get_width(_viewmodel_spr[0]) * _viewmodel_scale * 0.4,
		;
	draw_sprite_ext(_viewmodel_spr[0], _viewmodel_spr[1], _viewmodel_x, _viewmodel_y, _viewmodel_scale, _viewmodel_scale, 0, c_white, 1);
	// tiles if needed
	if (!ds_list_empty(_viewmodel_tiles))
	{
		for (var i=0; i<ds_list_size(_viewmodel_tiles); i++)
		{
			__draw_tile(_viewmodel_tile_x, _viewmodel_tile_y, _viewmodel_tile_sz, _viewmodel_tiles[|i]);
			_viewmodel_tile_y -= _viewmodel_tile_sz * 0.75;
		}
	}
}

// Generating indicator
if (generateRequest != -2)
{
	draw_clear(c_black);
	var _tx = window_get_width() * 0.5,
		_ty = window_get_height() * 0.5,
		_str = "GENERATING..."
		;
	
	draw_set_halign(1); draw_set_valign(1);
	draw_text_transformed_color(_tx, _ty, _str, 4, 4, 0, c_yellow, c_yellow, c_yellow, c_yellow, 1.0);
	
	// Progress
	switch (generateRequest)
	{
		default:
			break;
		case 0: // worldgen
			_ty = window_get_height() * 0.75;
			draw_set_halign(1); draw_set_valign(1);
			draw_text_transformed_color(_tx, _ty, "Generating world...", 4, 4, 0, c_gray, c_gray, c_gray, c_gray, 1.0);
			break;
		case -1: // chunk update
			_ty = window_get_height() * 0.75;
			draw_set_halign(1); draw_set_valign(1);
			draw_text_transformed_color(_tx, _ty, "Generating mesh...", 4, 4, 0, c_gray, c_gray, c_gray, c_gray, 1.0);
			
			_ty += 128;
			var _max_tiles = (global.mapSize[0] * global.mapSize[1] * global.mapSize[2]),
				_current_tiles = generateMeshProgress,
				_bar_wid = window_get_width() * 0.5,
				;
			// progress bar
			draw_rectangle_color(_tx - _bar_wid * 0.5, _ty - 32, _tx + _bar_wid * 0.5, _ty + 32, c_gray, c_gray, c_gray, c_gray, false);
			draw_rectangle_color(_tx - _bar_wid * 0.5, _ty - 32, _tx - _bar_wid * 0.5 + (_bar_wid * _current_tiles/_max_tiles), _ty + 32, c_white, c_white, c_white, c_white, false);
			// text
			draw_text_transformed_color(_tx, _ty, string(_current_tiles) + "/" + string(_max_tiles), 4, 4, 0, c_black, c_black, c_black, c_black, 1.0);
			break;
	}
}