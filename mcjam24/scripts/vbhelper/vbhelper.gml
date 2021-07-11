function map_vb_add (_vb, _x, _y, _z, _u, _v, _nx, _ny, _nz, _col, _alpha)
{
	vertex_position_3d(_vb, _x, _y, _z);
	vertex_texcoord(_vb, _u, _v);
	vertex_normal(_vb, _nx, _ny, _nz);
	vertex_colour(_vb, _col, _alpha);
}

#region old
function map_vb_add_floor_p (_vb, _x, _y, _z, _xs, _ys, _zs, _u, _v, _us, _vs, _nx, _ny, _nz, _col, _alpha)
{
	var _x2 = _x + _xs,
		_y2 = _y + _ys,
		_z2 = _z + _zs,
		_u2 = _u + _us,
		_v2 = _v + _vs;
	
	//var //_norm = z3d_calc_normal(_x, _y, _z, _x2, _y, _z, _x2, _y2, _z2),
	//		_nx = _norm[0],
	//		_ny = _norm[1],
	//		_nz = _norm[2],
	//		;
	
	// 1st tri
	//map_vb_add(_vb, _x, _y, _z, _u, _v, _nx, _ny, _nz, _col, _alpha);
	vertex_position_3d(_vb, _x, _y, _z);
	vertex_texcoord(_vb, _u, _v);
	vertex_normal(_vb, _nx, _ny, _nz);
	vertex_colour(_vb, _col, _alpha);
		
	//map_vb_add(_vb, _x2, _y, _z, _u2, _v, _nx, _ny, _nz, _col, _alpha);
	vertex_position_3d(_vb, _x2, _y, _z);
	vertex_texcoord(_vb, _u2, _v);
	vertex_normal(_vb, _nx, _ny, _nz);
	vertex_colour(_vb, _col, _alpha);
		
	//map_vb_add(_vb, _x2, _y2, _z2, _u2, _v2, _nx, _ny, _nz, _col, _alpha);
	vertex_position_3d(_vb, _x2, _y2, _z2);
	vertex_texcoord(_vb, _u2, _v2);
	vertex_normal(_vb, _nx, _ny, _nz);
	vertex_colour(_vb, _col, _alpha);
		
	// 2st tri
	// map_vb_add(_vb, _x, _y, _z, _u, _v, _nx, _ny, _nz, _col, _alpha);
	vertex_position_3d(_vb, _x, _y, _z);
	vertex_texcoord(_vb, _u, _v);
	vertex_normal(_vb, _nx, _ny, _nz);
	vertex_colour(_vb, _col, _alpha);
		
	//map_vb_add(_vb, _x2, _y2, _z2, _u2, _v2, _nx, _ny, _nz, _col, _alpha);
	vertex_position_3d(_vb, _x2, _y2, _z2);
	vertex_texcoord(_vb, _u2, _v2);
	vertex_normal(_vb, _nx, _ny, _nz);
	vertex_colour(_vb, _col, _alpha);
		
	//map_vb_add(_vb, _x, _y2, _z2, _u, _v2, _nx, _ny, _nz, _col, _alpha);
	vertex_position_3d(_vb, _x, _y2, _z2);
	vertex_texcoord(_vb, _u, _v2);
	vertex_normal(_vb, _nx, _ny, _nz);
	vertex_colour(_vb, _col, _alpha);
}
function map_vb_add_floor_n (_vb, _x, _y, _z, _xs, _ys, _zs, _u, _v, _us, _vs, _nx, _ny, _nz, _col, _alpha)
{
	var _x2 = _x + _xs,
		_y2 = _y + _ys,
		_z2 = _z + _zs,
		_u2 = _u + _us,
		_v2 = _v + _vs;
	
	//var //_norm = z3d_calc_normal(_x, _y, _z, _x2, _y2, _z2, _x2, _y, _z),
	//		_nx = _norm[0],
	//		_ny = _norm[1],
	//		_nz = _norm[2],
	//		;
	// 1st tri
	//map_vb_add(_vb, _x, _y, _z, _u, _v, _nx, _ny, _nz, _col, _alpha);
	vertex_position_3d(_vb, _x, _y, _z);
	vertex_texcoord(_vb, _u, _v);
	vertex_normal(_vb, _nx, _ny, _nz);
	vertex_colour(_vb, _col, _alpha);
		
	//map_vb_add(_vb, _x2, _y2, _z2, _u2, _v2, _nx, _ny, _nz, _col, _alpha);
	vertex_position_3d(_vb, _x2, _y2, _z2);
	vertex_texcoord(_vb, _u2, _v2);
	vertex_normal(_vb, _nx, _ny, _nz);
	vertex_colour(_vb, _col, _alpha);
		
	//map_vb_add(_vb, _x2, _y, _z, _u2, _v, _nx, _ny, _nz, _col, _alpha);
	vertex_position_3d(_vb, _x2, _y, _z);
	vertex_texcoord(_vb, _u2, _v);
	vertex_normal(_vb, _nx, _ny, _nz);
	vertex_colour(_vb, _col, _alpha);
		
	// 2st tri
	//map_vb_add(_vb, _x, _y, _z, _u, _v, _nx, _ny, _nz, _col, _alpha);
	vertex_position_3d(_vb, _x, _y, _z);
	vertex_texcoord(_vb, _u, _v);
	vertex_normal(_vb, _nx, _ny, _nz);
	vertex_colour(_vb, _col, _alpha);
		
	//map_vb_add(_vb, _x, _y2, _z2, _u, _v2, _nx, _ny, _nz, _col, _alpha);
	vertex_position_3d(_vb, _x, _y2, _z2);
	vertex_texcoord(_vb, _u, _v2);
	vertex_normal(_vb, _nx, _ny, _nz);
	vertex_colour(_vb, _col, _alpha);
	
	//map_vb_add(_vb, _x2, _y2, _z2, _u2, _v2, _nx, _ny, _nz, _col, _alpha);
	vertex_position_3d(_vb, _x2, _y2, _z2);
	vertex_texcoord(_vb, _u2, _v2);
	vertex_normal(_vb, _nx, _ny, _nz);
	vertex_colour(_vb, _col, _alpha);
}
function map_vb_add_wall_p (_vb, _x, _y, _z, _xs, _ys, _zs, _u, _v, _us, _vs, _nx, _ny, _nz, _col, _alpha)
{
	var _x2 = _x + _xs,
		_y2 = _y + _ys,
		_z2 = _z + _zs,
		_u2 = _u,
		_v2 = _v;
	_u += _us;
	_v += _vs;
	
	// 1st tri
	//map_vb_add(_vb, _x, _y, _z, _u, _v, _nx, _ny, _nz, _col, _alpha);
	vertex_position_3d(_vb, _x, _y, _z);
	vertex_texcoord(_vb, _u, _v);
	vertex_normal(_vb, _nx, _ny, _nz);
	vertex_colour(_vb, _col, _alpha);
		
	//map_vb_add(_vb, _x2, _y2, _z2, _u2, _v2, _nx, _ny, _nz, _col, _alpha);
	vertex_position_3d(_vb, _x2, _y2, _z2);
	vertex_texcoord(_vb, _u2, _v2);
	vertex_normal(_vb, _nx, _ny, _nz);
	vertex_colour(_vb, _col, _alpha);
		
	//map_vb_add(_vb, _x2, _y2, _z, _u2, _v, _nx, _ny, _nz, _col, _alpha);
	vertex_position_3d(_vb, _x2, _y2, _z);
	vertex_texcoord(_vb, _u2, _v);
	vertex_normal(_vb, _nx, _ny, _nz);
	vertex_colour(_vb, _col, _alpha);
	
	// 2st tri
	//map_vb_add(_vb, _x, _y, _z, _u, _v, _nx, _ny, _nz, _col, _alpha);
	vertex_position_3d(_vb, _x, _y, _z);
	vertex_texcoord(_vb, _u, _v);
	vertex_normal(_vb, _nx, _ny, _nz);
	vertex_colour(_vb, _col, _alpha);
		
	//map_vb_add(_vb, _x, _y, _z2, _u, _v2, _nx, _ny, _nz, _col, _alpha);
	vertex_position_3d(_vb, _x, _y, _z2);
	vertex_texcoord(_vb, _u, _v2);
	vertex_normal(_vb, _nx, _ny, _nz);
	vertex_colour(_vb, _col, _alpha);
		
	//map_vb_add(_vb, _x2, _y2, _z2, _u2, _v2, _nx, _ny, _nz, _col, _alpha);
	vertex_position_3d(_vb, _x2, _y2, _z2);
	vertex_texcoord(_vb, _u2, _v2);
	vertex_normal(_vb, _nx, _ny, _nz);
	vertex_colour(_vb, _col, _alpha);
}
function map_vb_add_wall_n (_vb, _x, _y, _z, _xs, _ys, _zs, _u, _v, _us, _vs, _nx, _ny, _nz, _col, _alpha)
{
	var _x2 = _x + _xs,
		_y2 = _y + _ys,
		_z2 = _z + _zs,
		_u2 = _u,
		_v2 = _v;
	_u += _us;
	_v += _vs;

	// 1st tri
	//map_vb_add(_vb, _x, _y, _z, _u, _v, _nx, _ny, _nz, _col, _alpha);
	vertex_position_3d(_vb, _x, _y, _z);
	vertex_texcoord(_vb, _u, _v);
	vertex_normal(_vb, _nx, _ny, _nz);
	vertex_colour(_vb, _col, _alpha);
	
	//map_vb_add(_vb, _x2, _y2, _z, _u2, _v, _nx, _ny, _nz, _col, _alpha);
	vertex_position_3d(_vb, _x2, _y2, _z);
	vertex_texcoord(_vb, _u2, _v);
	vertex_normal(_vb, _nx, _ny, _nz);
	vertex_colour(_vb, _col, _alpha);
	
	//map_vb_add(_vb, _x2, _y2, _z2, _u2, _v2, _nx, _ny, _nz, _col, _alpha);
	vertex_position_3d(_vb, _x2, _y2, _z2);
	vertex_texcoord(_vb, _u2, _v2);
	vertex_normal(_vb, _nx, _ny, _nz);
	vertex_colour(_vb, _col, _alpha);
	
	// 2st tri
	//map_vb_add(_vb, _x, _y, _z, _u, _v, _nx, _ny, _nz, _col, _alpha);
	vertex_position_3d(_vb, _x, _y, _z);
	vertex_texcoord(_vb, _u, _v);
	vertex_normal(_vb, _nx, _ny, _nz);
	vertex_colour(_vb, _col, _alpha);
	
	//map_vb_add(_vb, _x2, _y2, _z2, _u2, _v2, _nx, _ny, _nz, _col, _alpha);
	vertex_position_3d(_vb, _x2, _y2, _z2);
	vertex_texcoord(_vb, _u2, _v2);
	vertex_normal(_vb, _nx, _ny, _nz);
	vertex_colour(_vb, _col, _alpha);
	
	//map_vb_add(_vb, _x, _y, _z2, _u, _v2, _nx, _ny, _nz, _col, _alpha);
	vertex_position_3d(_vb, _x, _y, _z2);
	vertex_texcoord(_vb, _u, _v2);
	vertex_normal(_vb, _nx, _ny, _nz);
	vertex_colour(_vb, _col, _alpha);
}
#endregion

function z3d_calc_normal (_x1, _y1, _z1, _x2, _y2, _z2, _x3, _y3, _z3)
{
	// U = p2 - p1, V = p3 - p1
	var _ux = _x2 - _x1, _vx = _x3 - _x1,
		_uy = _y2 - _y1, _vy = _y3 - _y1,
		_uz = _z2 - _z1, _vz = _z3 - _z1,
		_nx = _uy * _vz - _uz * _vy,
		_ny = _uz * _vx - _ux * _vz,
		_nz = _ux * _vy - _uy * _vx,
		_mag = sqrt(_nx * _nx + _ny * _ny + _nz * _nz);
	return [_nx/_mag, _ny/_mag, _nz/_mag];
}