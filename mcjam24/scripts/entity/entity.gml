function entity_update_fracvel ()
{
	// Check sides
	if (abs(vx) < 1 && entity_side_collision_x(sign(vx)))
	{
		x = round(x);
		vx = 0;
		show_debug_message("vx frac dead");
	}
	if (abs(vy) < 1 && entity_side_collision_y(sign(vy)))
	{
		y = round(y);
		vy = 0;
		show_debug_message("vy frac dead");
	}
	if (abs(vz) < 1 && entity_side_collision_z(sign(vz)))
	{
		z = round(z);
		vz = 0;
		show_debug_message("vz frac dead");
	}
}

#region collision
function entity_side_collision_x (_x)
{
	var _map_sx = global.mapSize[0], _map_sy = global.mapSize[1], _map_sz = global.mapSize[2],
		_tilemap = global.mapTiles,
	// Bounds
		_ty1 = max((y-sy+0) >> TILE_BIT, 0),
		_tz1 = max((z-sz+0) >> TILE_BIT, 0),
		_ty2 = min((y+sy-0) >> TILE_BIT, _map_sy-1),
		_tz2 = min((z+sz-0) >> TILE_BIT, _map_sz-1),
		_bx, // xpos aabb extent to check
		;
		
	// Determine position to check
	if (_x <= 0) // move right
		_bx = (x-sx+_x) >> TILE_BIT;
	else // move left
		_bx = (x+sx+_x) >> TILE_BIT;
		
	// Check if the AABB is in bounds
	if !(_bx < 0 || _bx >= _map_sx)
	{
		// Check for collision
		for (var yy=_ty1; yy<=_ty2; yy++)
		{
			for (var zz=_tz1; zz<=_tz2; zz++)
			{
				switch (_tilemap[_bx][yy][zz])
				{
					case eTILES.AIR:
						// nothing
						continue;
						break;
						
					default:
						return true;
						break;
				}
			}
		}
	}
	
	return false;
}

function entity_side_collision_y (_y)
{
	var _map_sx = global.mapSize[0], _map_sy = global.mapSize[1], _map_sz = global.mapSize[2],
		_tilemap = global.mapTiles,
	// Bounds
		_tx1 = max((x-sx+0) >> TILE_BIT, 0),
		_tz1 = max((z-sz+0) >> TILE_BIT, 0),
		_tx2 = min((x+sx-0) >> TILE_BIT, _map_sx-1),
		_tz2 = min((z+sz-0) >> TILE_BIT, _map_sz-1),
		_by, // ypos aabb extent to check
		;
		
	// Determine position to check
	if (_y <= 0)
		_by = (y-sy+_y) >> TILE_BIT;
	else
		_by = (y+sy+_y) >> TILE_BIT;
		
	// Check if the AABB is in bounds
	if !(_by < 0 || _by >= _map_sy)
	{
		// Check for collision
		for (var xx=_tx1; xx<=_tx2; xx++)
		{
			for (var zz=_tz1; zz<=_tz2; zz++)
			{
				switch (_tilemap[xx][_by][zz])
				{
					case eTILES.AIR:
						// nothing
						continue;
						break;
						
					default:
						return true;
						break;
				}
			}
		}
	}
	
	return false;
}

function entity_side_collision_z (_z)
{
	var _map_sx = global.mapSize[0], _map_sy = global.mapSize[1], _map_sz = global.mapSize[2],
		_tilemap = global.mapTiles,
	// Bounds
		_tx1 = max((x-sx+0) >> TILE_BIT, 0),
		_ty1 = max((y-sz+0) >> TILE_BIT, 0),
		_tx2 = min((x+sx-0) >> TILE_BIT, _map_sx-1),
		_ty2 = min((y+sz-0) >> TILE_BIT, _map_sy-1),
		_bz, // zpos aabb extent to check
		;
		
	// Determine position to check
	if (_z <= 0)
		_bz = (z-sz+_z) >> TILE_BIT;
	else
		_bz = (z+sz+_z) >> TILE_BIT;
		
	// Check if the AABB is in bounds
	if !(_bz < 0 || _bz >= _map_sz)
	{
		// Check for collision
		for (var xx=_tx1; xx<=_tx2; xx++)
		{
			for (var yy=_ty1; yy<=_ty2; yy++)
			{
				switch (_tilemap[xx][yy][_bz])
				{
					case eTILES.AIR:
						// nothing
						continue;
						break;
						
					default:
						return true;
						break;
				}
			}
		}
	}
	
	return false;
}

function entity_trymove_x (_move, _e)
{
	if (_move == 0)
		return false;
	
	if (_e == undefined) _e = id;
	with (_e)
	{
		var _map_sx = global.mapSize[0], _map_sy = global.mapSize[1], _map_sz = global.mapSize[2],
			_tilemap = global.mapTiles,
		// Bounds
			//_bx1 = (x-sx) >> TILE_BIT,			_tx1 = max(_bx1, 0),
			_ty1 = max((y-sy) >> TILE_BIT, 0),
			_tz1 = max((z-sz) >> TILE_BIT, 0),
			//_bx2 = (x+sx) >> TILE_BIT,			_tx2 = min(_bx2, _map_sx-1),
			_ty2 = min((y+sy) >> TILE_BIT, _map_sy-1),
			_tz2 = min((z+sz) >> TILE_BIT, _map_sz-1),
			_bx, // xpos aabb extent to check
			_collided = false,
			;
		
		// Determine position to check
		if (_move <= 0) // move right
			_bx = (x-sx+_move) >> TILE_BIT;
		else // move left
			_bx = (x+sx+_move) >> TILE_BIT;
		
		// Check if the AABB is in bounds
		if !(_bx < 0 || _bx >= _map_sx)
		{
			// Check for collision
			for (var yy=_ty1; yy<=_ty2; yy++)
			{
				for (var zz=_tz1; zz<=_tz2; zz++)
				{
					switch (_tilemap[_bx][yy][zz])
					{
						case eTILES.AIR:
							// nothing
							continue;
							break;
						
						default:
							_collided = true;
							break;
					}
					if (_collided)
						break;
				}
				if (_collided)
					break;
			}
		}
		
		// Resolve collision if needed
		if (!_collided)
		{
			// No collision; just move
			x += _move;
		}
		else
		{
			// Solve collision!
			if (_move <= 0) // move right
			{
				// round down right pos to tile space & add 1 tile unit and AABB extent
				// x = (_bx1 << TILE_BIT) + TILE_SZ + sx;
				x = ((_bx+1) << TILE_BIT) + sx;
			}
			else
			{
				// round down left pos to tile space & add 1px and AABB extent
				x = (_bx << TILE_BIT) - 1 - sx;
			}
		}
		return _collided;
	}
}

function entity_trymove_y (_move, _e)
{
	if (_move == 0)
		return false;
	
	if (_e == undefined) _e = id;
	with (_e)
	{
		var _map_sx = global.mapSize[0], _map_sy = global.mapSize[1], _map_sz = global.mapSize[2],
			_tilemap = global.mapTiles,
		// Bounds
			_tx1 = max((x-sx) >> TILE_BIT, 0),
			//_ty1 = max((y-sy) >> TILE_BIT, 0),
			_tz1 = max((z-sz) >> TILE_BIT, 0),
			_tx2 = min((x+sx) >> TILE_BIT, _map_sx-1),
			//_ty2 = min((y+sy) >> TILE_BIT, _map_sy-1),
			_tz2 = min((z+sz) >> TILE_BIT, _map_sz-1),
			_by, // ypos aabb extent to check
			_collided = false,
			;
		
		// Determine position to check
		if (_move <= 0) // move up
			_by = (y-sy+_move) >> TILE_BIT;
		else // move down
			_by = (y+sy+_move) >> TILE_BIT;
		
		// Check if the AABB is in bounds
		if !(_by < 0 || _by >= _map_sx)
		{
			// Check for collision
			for (var zz=_tz1; zz<=_tz2; zz++)
			{
				for (var xx=_tx1; xx<=_tx2; xx++)
				{
					switch (_tilemap[xx][_by][zz])
					{
						case eTILES.AIR:
							// nothing
							continue;
							break;
						
						default:
							_collided = true;
							break;
					}
					if (_collided)
						break;
				}
				if (_collided)
					break;
			}
		}
		
		// Resolve collision if needed
		if (!_collided)
		{
			// No collision; just move
			y += _move;
		}
		else
		{
			// Solve collision!
			if (_move <= 0) // move up
			{
				// round down top pos to tile space & add 1 tile unit and AABB extent
				// y = (_by1 << TILE_BIT) + TILE_SZ + sy;
				y = ((_by+1) << TILE_BIT) + sy;
			}
			else
			{
				// round down bottom pos to tile space & add 1px and AABB extent
				y = (_by << TILE_BIT) - 1 - sy;
			}
		}
		return _collided;
	}
}

function entity_trymove_z (_move, _e)
{
	if (_move == 0)
		return false;
	
	if (_e == undefined) _e = id;
	with (_e)
	{
		var _map_sx = global.mapSize[0], _map_sy = global.mapSize[1], _map_sz = global.mapSize[2],
			_tilemap = global.mapTiles,
		// Bounds
			_bx1 = (x-sx) >> TILE_BIT,			_tx1 = max(_bx1, 0),
			_by1 = (y-sy) >> TILE_BIT,			_ty1 = max(_by1, 0),
			//_bz1 = (z-sz+_move) >> TILE_BIT,	_tz1 = max(_bz1, 0),
			_bx2 = (x+sx) >> TILE_BIT,			_tx2 = min(_bx2, _map_sx-1),
			_by2 = (y+sy) >> TILE_BIT,			_ty2 = min(_by2, _map_sy-1),
			//_bz2 = (z+sz+_move) >> TILE_BIT,	_tz2 = min(_bz2, _map_sz-1),
			_bz, // zpos aabb extent to check
			_collided = false,
			;
		
		// Determine position to check
		if (_move <= 0) // move down
			_bz = (z-sz+_move) >> TILE_BIT;
		else // move up
			_bz = (z+sz+_move) >> TILE_BIT;
		
		// Check if the AABB is in bounds
		if !(_bz < 0 || _bz >= _map_sz)
		{
			// Check for collision
			for (var xx=_tx1; xx<=_tx2; xx++)
			{
				for (var yy=_ty1; yy<=_ty2; yy++)
				{
					switch (_tilemap[xx][yy][_bz])
					{
						case eTILES.AIR:
							// nothing
							continue;
							break;
						
						default:
							_collided = true;
							break;
					}
					if (_collided)
						break;
				}
				if (_collided)
					break;
			}
		}
		
		// Resolve collision if needed
		if (!_collided)
		{
			// No collision; just move
			z += _move;
		}
		else
		{
			// Solve collision!
			if (_move <= 0) // move up
			{
				// round down bottom pos to tile space & add 1 tile unit and AABB extent
				// z = (_bz1 << TILE_BIT) + TILE_SZ + sz;
				z = ((_bz+1) << TILE_BIT) + sz;
			}
			else
			{
				// round down top pos to tile space & add 1px and AABB extent
				z = (_bz << TILE_BIT) - 1 - sz;
			}
		}
		return _collided;
	}
}
#endregion