extends Node
class_name BarkEffect

# Audio settings
const LETTER_TO_SING = "a"
const MIDI_ORIGINAL_NOTE = 53  # C3

# Exported properties
export(float) var bark_pitch_multiplier = 1.0

var _last_bark_time = 0

func trigger_bark(player, midi_pitch: int):
	var pitch = _calculate_bark_pitch(midi_pitch)
	_play_bark_effect(player, pitch)
	_last_bark_time = OS.get_ticks_msec()

func _calculate_bark_pitch(midi_pitch):
	var semitone_difference = midi_pitch - MIDI_ORIGINAL_NOTE
	return pow(2, semitone_difference / 12.0) * bark_pitch_multiplier

func _play_bark_effect(player, pitch):
	
	# Send network event
	Network._send_actor_action(player.actor_id, "_talk", [LETTER_TO_SING, pitch], false)
	
	# Play local effect
	player._talk(LETTER_TO_SING, pitch)
	print("Bark effect triggered with pitch: ", pitch)
