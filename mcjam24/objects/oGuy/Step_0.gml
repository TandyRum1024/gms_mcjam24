/// @description Insert description here
if (global.gamePaused)
	exit;
	
if (vz > velMaxGrav)
	vz += velAccGrav;
else
	vz = velMaxGrav;

// collision
// vertical
if (entity_trymove_z(vz))
{
	// Set velocity
	vz = 0;
}

// vs. block
with (oBlock)
{
	// minkowski sum or something
	var _x1 = x - sx - other.sx,
		_y1 = y - sy - other.sy,
		_z1 = z - sz - other.sz,
		_x2 = x + sx + other.sx,
		_y2 = y + sy + other.sy,
		_z2 = z + sz + other.sz;
	if (other.x >= _x1 && other.x <= _x2 &&
		other.y >= _y1 && other.y <= _y2 &&
		other.z >= _z1 && other.z <= _z2
		)
	{
		with (other)
		{
			var _ox = other.x, _oy = other.y, _oz = other.z,
			_vx = other.vx * 1.5, _vy = other.vy * 1.5, _vz = max(other.vz, 0) + 2;
			instance_destroy(other);
			die(_vx, _vy, _vz, _ox, _oy, _oz);
		}
	}
}
