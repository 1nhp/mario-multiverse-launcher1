extends Node
var game_path = "C:/Games/Mario Multiverse/"
var rpc_bridge_path = "C:/"
var wine_prefix_name = ""

var os = OS.get_name()
var version = ""
var launcher_path = OS.get_executable_path().get_base_dir()

func _ready() -> void:
	var file = FileAccess.open("res://version.json", FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	
	var data = JSON.parse_string(content)	
	version = data["version"]
	
	print("OS: " + str(os))
	Saving.load_data()
