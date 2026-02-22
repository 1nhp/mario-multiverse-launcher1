extends Node2D

enum BGM { MAIN, MAIN_ALT, SETTINGS, UPDATE }

var current_bgm: AudioStreamPlayer = null

func play_bgm(bgm: BGM):
	var node_name = BGM.keys()[bgm]
	var player: AudioStreamPlayer = get_node(node_name)

	if current_bgm and current_bgm != player:
		current_bgm.stop()

	current_bgm = player
	current_bgm.play()
	print_debug("BGM Manager:" + " playing " + str(player))
	print_debug("Args: ")
	print_debug("Stream: " + str(player.stream))

	
func stop_bgm():
	if current_bgm:
		current_bgm.stop()
		print_debug("BGM Manager:" + " stopped " + str(current_bgm))
		current_bgm = null
