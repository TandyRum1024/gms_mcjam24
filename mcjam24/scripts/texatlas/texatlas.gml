// Texture atlas vars def
global.texAtlasQueue = ds_list_create();
// struct holding each texture data
global.texAtlas = {};
global.texAtlasSpr = undefined;
global.texAtlasTex = undefined;

function tex_init ()
{
	ds_list_clear(global.texAtlasQueue);
}

function tex_add (_name, _spr, _idx)
{
	ds_list_add(global.texAtlasQueue, [_name, _spr, _idx]);
}

function tex_build (_atlas_w, _atlas_h)
{
	show_debug_message("tex> atlas build begin...");
	var _time_begin = current_time;
	
	// Prepare the atlas surface
	var _surf = surface_create(_atlas_w, _atlas_h),
		_next_x = 0, // position to place next texture
		_next_y = 0,
		_max_h = 0,
		;
	surface_set_target(_surf);
	
	for (var i=0; i<ds_list_size(global.texAtlasQueue); i++)
	{
		var _data = global.texAtlasQueue[| i],
			_name = _data[0], _spr = _data[1], _idx = _data[2],
			_tex_w = sprite_get_width(_spr), _tex_h = sprite_get_height(_spr),
			_place_x = _next_x+_tex_w,
			;
		show_debug_message("tex> packing texture `" + _name + "`...");
		
		if (_place_x > _atlas_w) // overflow; go to next line
		{
			_place_x = 0;
			_next_x = 0;
			_next_y += _max_h;
			_max_h = 0;
		}
		
		// Place sprite & add texture data to atlas info
		draw_sprite(_spr, _idx, _next_x, _next_y);
		global.texAtlas[$ _name] = [_next_x / _atlas_w, _next_y / _atlas_h,
									_tex_w / _atlas_w, _tex_h / _atlas_h];
		
		// Update next position
		_next_x = _place_x;
		_max_h = max(_max_h, _tex_h);
	}
	surface_reset_target();
	
	show_debug_message("tex> atlas build done (" + string(current_time - _time_begin) + " ms)");
	
	// Convert to sprite & cleanup
	if (global.texAtlasSpr != undefined)
		sprite_delete(global.texAtlasSpr);
	global.texAtlasSpr = sprite_create_from_surface(_surf, 0, 0, _atlas_w, _atlas_h, false, false, 0, 0);
	global.texAtlasTex = sprite_get_texture(global.texAtlasSpr, 0);
	surface_free(_surf);
}
