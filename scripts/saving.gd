extends Node

func save_data():
	var file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	var saved_data = {}
	
	saved_data["game_path"] = Globals.game_path
	saved_data["rpc_bridge_path"] = Globals.rpc_bridge_path
	saved_data["wine_prefix_name"] = Globals.wine_prefix_name


	file.store_string(JSON.stringify(saved_data))
	print("Save data: saved" + str(saved_data))	
	
func load_data():
	if not FileAccess.file_exists("user://savegame.json"):
		print("No save file found.")
		return
		
	var file = FileAccess.open("user://savegame.json", FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	
	var saved_data = JSON.parse_string(content)
	
	if saved_data == null:
		print("Failed to parse save file.")
		return
		
	Globals.game_path = saved_data["game_path"]
	Globals.rpc_bridge_path = saved_data["rpc_bridge_path"]
	Globals.wine_prefix_name = saved_data["wine_prefix_name"]


func reset_data():
	var save_path = "user://savegame.json"
	
	# Remove the save file if it exists
	if FileAccess.file_exists(save_path):
		var dir = DirAccess.open("user://")
		if dir:
			dir.remove("savegame.json")
			print("Save file removed.")

	# Reset globals
	Globals.game_path = ""
	Globals.rpc_bridge_path = ""
	Globals.wine_prefix_name = ""
	
	save_data()
