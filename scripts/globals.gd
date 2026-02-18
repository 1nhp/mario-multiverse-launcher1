extends Node
var game_path = "C:/Games/Mario Multiverse/"
var rpc_bridge_path = "C:/"
var wine_prefix_name = ""

var os = OS.get_name()

func _ready() -> void:
	print("OS: " + str(os))
	Saving.load_data()
