extends CanvasLayer
@onready var rect = CircleTransition.get_node("ColorRect")

# Play background music when the scene is being started
func _enter_tree() -> void:
	BgmManager.play_bgm(BgmManager.BGM.MAIN_ALT)

# When scene is ready grab focus to the Buttons
func _ready() -> void:
	$Root/UI/Buttons.grab_focus()
	
	if Globals.game_path.contains("Demo"):
		$"Root/UI/TOP/Demo Logo".visible = true
	else:
		$"Root/UI/TOP/Beta Logo".visible = true

	$Root/UI/BR/version_text.text = "Launcher version: " + Globals.version
	
# Quit game when quit button is pressed
func _on_quit_pressed() -> void:
	BgmManager.stop_bgm()
	CircleTransition.transition("home/home", false, 0, Vector2(0.975, 0.06))
	await get_tree().create_timer(0.5).timeout
	get_tree().quit()

# Play the game when play button is pressed
func _on_play_pressed() -> void:
	_launch_game("/Mario.exe")

func _on_create_pressed() -> void:
	_launch_game("/MarioMapEditor.exe")

# Error function
func _error(string):
	var window = object.create_object("res://scenes/objects/window/window.tscn", "/root/Home/Root/UI", Vector2(0, 0))
	SoundManager.play_sound(SoundManager.SOUNDS.wrong)
	window.window_text = string
	window.double = false
	window.window_ok_clicked.connect(_on_window_ok_pressed)
	window._update_text()

func _check_game():
	match Globals.os:
		
		"Windows":
			if Globals.game_path.is_empty():
				_error("ERROR 001: Game path is not set!")
				return 1
			return 0
		
		"Linux":
			if Globals.game_path.is_empty():
				_error("ERROR 001: Game path is not set. Change this in Launcher settings.")
				return 1

			if Globals.rpc_bridge_path.is_empty():
				_error("ERROR 002: Discord RPC bridge path is not set. Change this in Launcher settings.")
				return 1

			if Globals.wine_prefix_name.is_empty():
				_error("ERROR 003: Wine prefix name is not set. Change this in Launcher settings.")
				return 1
			
			return 0

func _launch_game(executable: String) -> void:
	if _check_game() != 0:
		return
	
	await _start_transition()
	_run_game(executable)

func _run_game(game = "/Mario.exe"):
		# Set arguments, game_args sets path to the game path, while rpc does same thing
		var game_args = [Globals.game_path + game]
		var rpc_args = [Globals.rpc_bridge_path + "/bridge.exe"]
		
		#execute wine first bridge then the game
		if not Globals.game_path.contains("Demo"):
			if game == "/Mario.exe" or game == "/MarioMapEditor.exe":
				OS.execute("wine", rpc_args, ["WINEPREFIX=~/" + Globals.wine_prefix_name])

		OS.execute("wine", game_args, ["WINEPREFIX=~/" + Globals.wine_prefix_name])

func _start_transition():
		BgmManager.stop_bgm()
		CircleTransition.transition("home/home", true, 2, Vector2(0.49, 0.9))
		await get_tree().create_timer(1).timeout	

func _on_window_ok_pressed(): $Root/UI/Buttons/Play.grab_focus()	

# Go to launcher settings scene if launcher settings button is pressed
func _on_launcher_settings_pressed() -> void:
	BgmManager.stop_bgm()
	CircleTransition.transition("launchersettings/launchersettings", false, 0, Vector2(0.925, 0.06))

func _on_options_pressed() -> void:
	_launch_game("/MarioConfig.exe")
