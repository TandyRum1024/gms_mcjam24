/// @func z3d_col_ray_aabb(_rx, _ry, _rz, _rnx, _rny, _rnz, _x1, _y1, _z1, _x2, _y2, _z2)
/// @desc returns when will the ray hit the AABB (infinity on miss)
function z3d_col_ray_aabb(_rx, _ry, _rz, _rnx, _rny, _rnz, _x1, _y1, _z1, _x2, _y2, _z2)
{
	// Based on this y'see
	// http://psgraphics.blogspot.com/2016/02/new-simple-ray-box-test-from-andrew.html
	// Prepare vars for unrolled loop
	var _invn, _t0, _t1,
		_tmin = 0, _tmax = infinity; // min/max for t. if the 'near' is greater than 'far' then it's a miss
	
	// We assume that the x1,y1,z1 of AABB is the 'minimum' position -- always smaller than x2,y2,z2
	// X axis
	_invn = 1 / _rnx;
	if (_invn >= 0)
	{
		_tmin	= max(_tmin, (_x1 - _rx) * _invn);
		_tmax	= min(_tmax, (_x2 - _rx) * _invn);
	}
	else // negative direction: t0 & t1 swapped
	{
		_tmin	= max(_tmin, (_x2 - _rx) * _invn);
		_tmax	= min(_tmax, (_x1 - _rx) * _invn);
	}
	if (_tmax <= _tmin)
		return [infinity, infinity];
	
	// Y axis
	_invn = 1 / _rny;
	if (_invn >= 0)
	{
		_tmin	= max(_tmin, (_y1 - _ry) * _invn);
		_tmax	= min(_tmax, (_y2 - _ry) * _invn);
	}
	else // negative direction: t0 & t1 swapped
	{
		_tmin	= max(_tmin, (_y2 - _ry) * _invn);
		_tmax	= min(_tmax, (_y1 - _ry) * _invn);
	}
	if (_tmax <= _tmin)
		return [infinity, infinity];
	
	// Z axis
	_invn = 1 / _rnz;
	if (_invn >= 0)
	{
		_tmin	= max(_tmin, (_z1 - _rz) * _invn);
		_tmax	= min(_tmax, (_z2 - _rz) * _invn);
	}
	else // negative direction: t0 & t1 swapped
	{
		_tmin	= max(_tmin, (_z2 - _rz) * _invn);
		_tmax	= min(_tmax, (_z1 - _rz) * _invn);
	}
	if (_tmax <= _tmin)
		return [infinity, infinity];
	
	// All passed: it's hit
	return [_tmin, _tmax];
}
