extends CanvasLayer
@onready var rect = CircleTransition.get_node("ColorRect")

# Play background music when the scene is being started
func _enter_tree() -> void:
	BgmManager.play_bgm(BgmManager.BGM.MAIN_ALT)

# When scene is ready grab focus to the Buttons
func _ready() -> void:
	$Root/UI/Buttons.grab_focus()

# Quit game when quit button is pressed
func _on_quit_pressed() -> void:
	BgmManager.stop_bgm()
	CircleTransition.transition("home/home", false)
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()

# Play the game when play button is pressed
func _on_play_pressed() -> void:
	# Validate what OS user is on
	if Globals.os == "Windows":
		# Check if path is null if it is throw window with error
		if Globals.game_path == "":
			_error("ERROR 001: Game path is not set!")
			return
		# Else continue and do an transition
		BgmManager.stop_bgm()
		CircleTransition.transition("home/home", true, 2)
		await get_tree().create_timer(1).timeout
	
	# Linux checks
	elif Globals.os == "Linux":
		# Check if nothing is empty if it is throw error with corresponding codes
		if Globals.game_path == "":
			_error("ERROR 001: Game path is not set change this in Launcher settings.")
			return

		if Globals.rpc_bridge_path == "":
			_error("ERROR 002: Discord RPC bridge for Linux path is not set change this in Launcher settings.")
			return

		if Globals.wine_prefix_name == "":
			_error("ERROR 003: Wine prefix name is not set change this in Launcher settings.")
			return
		
		# Continue transition as usual
		BgmManager.stop_bgm()
		CircleTransition.transition("home/home", true, 2)
		await get_tree().create_timer(1).timeout
		
		# Set arguments, game_args sets path to the game path, while rpc does same thing
		var game_args = [Globals.game_path + "/Mario.exe"]
		var rpc_args = [Globals.rpc_bridge_path + "/bridge.exe"]
		
		# execute wine first bridge then the game
		OS.execute("wine", rpc_args, ["WINEPREFIX=~/" + Globals.wine_prefix_name])
		OS.execute("wine", game_args, ["WINEPREFIX=~/" + Globals.wine_prefix_name])
		
# Error function
func _error(string):
	var window = object.create_object("res://scenes/objects/window/window.tscn", "/root/Home/Root/UI", Vector2(0, 0))
	SoundManager.play_sound(SoundManager.SOUNDS.wrong)
	window.window_text = string
	window.double = false
	window.window_ok_clicked.connect(_on_window_ok_pressed)
	window._update_text()

func _on_window_ok_pressed():
	$Root/UI/Buttons/Play.grab_focus()	

# Go to launcher settings scene if launcher settings button is pressed
func _on_launcher_settings_pressed() -> void:
	BgmManager.stop_bgm()
	CircleTransition.transition("launchersettings/launchersettings", false)
