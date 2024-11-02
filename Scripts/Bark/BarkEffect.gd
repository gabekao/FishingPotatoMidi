extends Node
class_name BarkEffect

# Audio settings
const ALPHABET = "A"
const MIDI_ORIGINAL_NOTE = 53  # C3

# Exported properties
export(float) var bark_pitch_multiplier = 1.0

var _last_bark_time = 0

func trigger_bark(player, midi_pitch: int):
	if midi_pitch < 60 or midi_pitch > 100:
		var pitch = _calculate_bark_pitch(midi_pitch)
		_play_bark_effect(player, pitch)
		_last_bark_time = OS.get_ticks_msec()

func _calculate_bark_pitch(midi_pitch):
	var semitone_difference = midi_pitch - MIDI_ORIGINAL_NOTE
	return pow(2, semitone_difference / 12.0) * bark_pitch_multiplier
	
func set_letter_to_sing(pitch: int) -> String:
	var _letter_to_sing = ALPHABET[pitch % ALPHABET.length()]
	return _letter_to_sing

func _play_bark_effect(player, pitch):
	var letter = set_letter_to_sing(pitch)
	
	# Send network event
	Network._send_actor_action(player.actor_id, "_talk", [letter, pitch], false)
	
	# Play local effect
	player._talk(letter, pitch)
	print("Bark effect triggered with pitch: ", pitch)
