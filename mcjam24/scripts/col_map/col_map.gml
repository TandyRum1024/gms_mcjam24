/*
	Collision stuff
*/
#region ray
/// @func map_col_ray_tilemap(_tilemap, _ray_x, _ray_y, _ray_z, _ray_nx, _ray_ny, _ray_nz)
/// @desc returns array: [hit, time, tile_x, tile_y, tile_z, tile_side] of ray hitting the tilemap. the ray normals/directions are assumed to be normalized
function map_col_ray_tilemap (_tilemap, _ray_x, _ray_y, _ray_z, _ray_nx, _ray_ny, _ray_nz)
{	
	// Go read this first if y'all hadn't read this good explaination of 3D DDA algorithm
	// https://www.scratchapixel.com/lessons/advanced-rendering/introduction-acceleration-structure/grid
	static	_TILE_UNIT = TILE_SZ,
			_TILE_UNIT_INV = 1 / TILE_SZ;
	var _map_sz_x = global.mapSize[0], _map_sz_y = global.mapSize[1], _map_sz_z = global.mapSize[2],
		_map_tile = _tilemap,
		_ray_hit_t = z3d_col_ray_aabb(_ray_x, _ray_y, _ray_z, _ray_nx, _ray_ny, _ray_nz,
										0,0,0,_map_sz_x*_TILE_UNIT, _map_sz_y*_TILE_UNIT, _map_sz_z*_TILE_UNIT),
		_ray_min = _ray_hit_t[0];
	// Check if the ray intersects the grid at all
	if (_ray_min == infinity)
		return [false, infinity, 0, 0, 0, -1];
	
	// Convert ray origin to tilemap space
	// (also account for rays starting from outside of the grid
	var _ray_tx = clamp(floor((_ray_x + _ray_nx*_ray_min) * _TILE_UNIT_INV), 0, _map_sz_x-1),
		_ray_ty = clamp(floor((_ray_y + _ray_ny*_ray_min) * _TILE_UNIT_INV), 0, _map_sz_y-1),
		_ray_tz = clamp(floor((_ray_z + _ray_nz*_ray_min) * _TILE_UNIT_INV), 0, _map_sz_z-1),
	// currently visiting tile coords
		_tx = _ray_tx,
		_ty = _ray_ty,
		_tz = _ray_tz;
	
	// Calculate the travel distance required before crossing each axis of tiles
	/*
		in tilemap space where each tile has dimension of 1 it's simply the inverse of ray's normal vector
		if we assume the stepx = distance required before the ray crossing the x axis & rx = ray's x normal & assume the ray normal is normalized (= it's slope has length of 1):
		in order to find the stepx, we can find the right triangle's slope's length where x component is 1
		(so each "step" we cross the axis once)
		thus by the properties of ratio: (slope)stepx/1 = (x axis)1/rx
			=> stepx = 1 / rx AKA the inverse of ray normal
		
		Then, substituting the 1 (since we assumed that each tile has dimension of 1) with the tile size:
			stepx = <tile size x> / rx
	*/
	var	_step_x = abs(_TILE_UNIT / _ray_nx), // take the absolute value in case of ray normals being negative
		_step_y = abs(_TILE_UNIT / _ray_ny),
		_step_z = abs(_TILE_UNIT / _ray_nz);
	
	// Set up the tilemap DDA
	// Get the initial distance 'offset' required before crossing the first (next) axis
	// in general:
	// if normal x >= 0	: offsetx = (<tile space x + 1> * <tile size> - <ray offset>) / rx
	// otherwise		: offsetx = -((<ray offset> - <tile space x>) / rx)
	var _dist_x = (_ray_nx >= 0) ? ( ((_tx + 1) * _TILE_UNIT - _ray_x) / _ray_nx ) : ( (_tx * _TILE_UNIT - _ray_x) / _ray_nx ),
		_dist_y = (_ray_ny >= 0) ? ( ((_ty + 1) * _TILE_UNIT - _ray_y) / _ray_ny ) : ( (_ty * _TILE_UNIT - _ray_y) / _ray_ny ),
		_dist_z = (_ray_nz >= 0) ? ( ((_tz + 1) * _TILE_UNIT - _ray_z) / _ray_nz ) : ( (_tz * _TILE_UNIT - _ray_z) / _ray_nz ),
	// tile coords increment
		_t_step_x = sign(_ray_nx),
		_t_step_y = sign(_ray_ny),
		_t_step_z = sign(_ray_nz),
	// exiting bounds (either 0 or tilemap dimension)
		_bound_x = (_ray_nx >= 0) ? _map_sz_x : -1,
		_bound_y = (_ray_ny >= 0) ? _map_sz_y : -1,
		_bound_z = (_ray_nz >= 0) ? _map_sz_z : -1,
	// total traveled distance
		_t = infinity,
		;
	
	// Give 'er	
	var _md = min(_dist_x, _dist_y, _dist_z),
		_side = -1,
		_hit = false;
	while (true)
	{
		// Check current grid
		if (_map_tile[_tx][_ty][_tz] != 0)
		{
			_hit = true;
			break;
		}
		
		// Walk in least-traveled distance
		if (_md == _dist_x) // X
		{
			_side = eSIDE.XP;
			_tx += _t_step_x;
			if (_tx == _bound_x) // check for end
				break;
			_dist_x += _step_x;
		}
		else if (_md == _dist_y) // Y
		{
			_side = eSIDE.YP;
			_ty += _t_step_y;
			if (_ty == _bound_y) // check for end
				break;
			_dist_y += _step_y;
		}
		else // Z
		{
			_side = eSIDE.ZP;
			_tz += _t_step_z;
			if (_tz == _bound_z) // check for end
				break;
			_dist_z += _step_z;
		}
		
		// Update minimum distance
		_md = min(_dist_x, _dist_y, _dist_z);
	}
	
	// Determine actual side from ray's normal
	switch (_side)
	{
		case -1: // undetermined.. yet (probably encountered a tile right after the ray has been entered the grid)
			if (_md == _dist_x)
				_side = _t_step_x ? eSIDE.XN : eSIDE.XP;
			else if (_md == _dist_y)
				_side = _t_step_y ? eSIDE.YN : eSIDE.YP;
			else
				_side = _t_step_z ? eSIDE.ZN : eSIDE.ZP;
			_t = _ray_min;
			break;
		
		case eSIDE.XP:
			_side = _t_step_x ? eSIDE.XN : eSIDE.XP;
			_t = _dist_x-_step_x;
			break;
		case eSIDE.YP:
			_side = _t_step_y ? eSIDE.YN : eSIDE.YP;
			_t = _dist_y-_step_y;
			break;
		case eSIDE.ZP:
			_side = _t_step_z ? eSIDE.ZN : eSIDE.ZP;
			_t = _dist_z-_step_z;
			break;
	}
	return [_hit, _t, _tx, _ty, _tz, _side];
}
#endregion

#region aabb
function map_col_aabb (_x1, _y1, _z1, _x2, _y2, _z2)
{
	var _map_sx = global.mapSize[0],
		_map_sy = global.mapSize[1],
		_map_sz = global.mapSize[2],
		_tilemap = global.mapTiles,
		;
	var _tx1 = max(_x1 >> TILE_BIT, 0),
		_ty1 = max(_y1 >> TILE_BIT, 0),
		_tz1 = max(_z1 >> TILE_BIT, 0),
		_tx2 = min(_x2 >> TILE_BIT, _map_sx-1),
		_ty2 = min(_y2 >> TILE_BIT, _map_sy-1),
		_tz2 = min(_z2 >> TILE_BIT, _map_sz-1);
	
	for (var xx=_tx1; xx<=_tx2; xx++)
	{
		for (var yy=_ty1; yy<=_ty2; yy++)
		{
			for (var zz=_tz1; zz<=_tz2; zz++)
			{
				if (_tilemap[xx][yy][zz] != 0)
					return true;
			}
		}
	}
}
#endregion