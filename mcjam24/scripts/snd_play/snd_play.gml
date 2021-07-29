// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function snd_play(_fx, _pitch, _volume)
{
	var _snd = audio_play_sound(_fx, 0, 0);
	audio_sound_pitch(_snd, _pitch);
	audio_sound_gain(_snd, _volume, 0);
	return _snd;
}

function snd_play_at(_fx, _pitch, _volume, _x, _y, _z, _falloff1, _falloff2)
{
	if (_falloff1 == undefined)
		_falloff1 = 128;
	if (_falloff2 == undefined)
		_falloff2 = 256;
		
	var _snd = audio_play_sound_at(_fx, _x, _y, _z, _falloff1, _falloff2, 1.5, 0, 0);
	audio_sound_pitch(_snd, _pitch);
	audio_sound_gain(_snd, _volume, 0);
	return _snd;
}