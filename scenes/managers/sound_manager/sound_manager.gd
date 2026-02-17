extends Node

enum SOUNDS { decide, hover }

var current_sound: AudioStreamPlayer2D = null

func play_sound(sound: SOUNDS):
	var node_name = SOUNDS.keys()[sound]
	var player: AudioStreamPlayer2D = get_node(node_name)

	current_sound = player
	current_sound.play()
	print_debug("Sound Manager:" + " playing  " + str(player))
	print_debug("Args: ")
	print_debug("Stream: " + str(player.stream))
