function make_explosion(_x, _y, _z, _halfradius, _halfradius_guys, _knockback)
{
	var _map_sx = global.mapSize[0],
		_map_sy = global.mapSize[1],
		_map_sz = global.mapSize[2],
		_x1 = clamp((_x - _halfradius) >> TILE_BIT, 0, _map_sx-1),
		_y1 = clamp((_y - _halfradius) >> TILE_BIT, 0, _map_sy-1),
		_z1 = clamp((_z - _halfradius) >> TILE_BIT, 0, _map_sz-1),
		_x2 = clamp((_x + _halfradius) >> TILE_BIT, 0, _map_sx-1),
		_y2 = clamp((_y + _halfradius) >> TILE_BIT, 0, _map_sy-1),
		_z2 = clamp((_z + _halfradius) >> TILE_BIT, 0, _map_sz-1),
		;
	
	// Remove tiles
	for (var xx=_x1; xx<=_x2; xx++)
	{
		for (var yy=_y1; yy<=_y2; yy++)
		{
			for (var zz=_z1; zz<=_z2; zz++)
			{
				var _tile = global.mapTiles[xx][yy][zz];
				if (_tile != eTILES.AIR)
				{
					// Calculate knockback
					var _wx = ((xx << TILE_BIT) + (TILE_SZ>>1)),
						_wy = ((yy << TILE_BIT) + (TILE_SZ>>1)),
						_wz = ((zz << TILE_BIT) + (TILE_SZ>>1)),
						_dx = _wx - _x,
						_dy = _wy - _y,
						_dz = _wz - _z,
						_mag = point_distance_3d(0,0,0,_dx,_dy,_dz),
						;
					_dx /= _mag;
					_dy /= _mag;
					_dz /= _mag;
					var _kb = (1.0-_mag/_halfradius) * _knockback;
					if (_kb > 0)
					{
						// Remove & replace with thrown brick
						with (instance_create_layer(_wx, _wy, "inst", oBlock))
						{
							z = _wz;
							vx = _dx * _kb;
							vy = _dy * _kb;
							vz = max(abs(_dz * _kb), abs(_dz * _knockback));
							tile = _tile;
						}
						map_edit_set(xx,yy,zz, eTILES.AIR);
					}
				}
			}
		}
	}
	
	// Create explosion particle
	with (instance_create_layer(_x,_y,"inst", oParticle))
	{
		z = _z;
		sprite_index = sprNuke;
		//image_speed = 0.5;
	}
	
	// Kill nearby guys
	var _guys = ds_list_create();
	collision_circle_list(_x, _y, _halfradius_guys, oGuy, false, false, _guys, true);
	for (var i=0 ;i<ds_list_size(_guys); i++)
	{
		var _guy = _guys[| i];
		with (_guy)
		{
			var _vx = x - _x,
				_vy = y - _y,
				_vz = z - _z,
				_mag = point_distance_3d(0,0,0,_vx,_vy,_vz),
				_kb = (1.0-_mag/_halfradius_guys)*_knockback,
				;
			_vx /= _mag;
			_vy /= _mag;
			_vz /= _mag;
			die(_vx*_kb, _vy*_kb, _vz*_kb);
		}
	}
	ds_list_destroy(_guys);
	
	// Shake camera
	var _vx = oPlayer.x - _x,
		_vy = oPlayer.y - _y,
		_vz = oPlayer.z - _z,
		_mag = point_distance_3d(0,0,0,_vx,_vy,_vz),
		_kb = (1.0-_mag/(TILE_SZ*32))*_knockback,
		;
	if (_kb > 0)
	{
		_vx /= _mag;
		_vy /= _mag;
		_vz /= _mag;
		with (oKNT.camera)
		{
			shake += _kb * 0.025;
			ox += _vx * _kb * 0.01;
			oy += _vy * _kb * 0.01;
			oz += _vz * _kb * 0.01;
			vx += random_range(-_kb, _kb) * 0.01;
			vy += random_range(-_kb, _kb) * 0.01;
			vz += random_range(-_kb, _kb) * 0.01;
		}
	}
}