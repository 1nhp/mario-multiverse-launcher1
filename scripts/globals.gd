extends Node
var game_path = "/home/user/Stuff/Games/Mario Multiverse/"
var os = OS.get_name()

func _ready() -> void:
	print("OS: " + str(os))
