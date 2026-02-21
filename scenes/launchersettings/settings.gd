extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _enter_tree() -> void:
	BgmManager.play_bgm(BgmManager.BGM.SETTINGS)
	
func _ready() -> void:
	_update_dir_text()
	$Root/UI/MenuButtons/Quit.grab_focus()	

func _update_dir_text():
	$Root/UI/Window/Buttons/GameDirectory/dir_text.text = Globals.game_path
	$Root/UI/Window/Buttons/RPCBridgeDirectory/dir_text.text = Globals.rpc_bridge_path
	$Root/UI/Window/Buttons/WinePrefixName/dir_text.text = Globals.wine_prefix_name

func _on_quit_pressed() -> void:
	BgmManager.stop_bgm()
	CircleTransition.transition("home/home", false, 0, Vector2(0.023, 0.93))

func _on_game_directory_pressed() -> void:
	var picker = FolderPicker.new()
	add_child(picker)
	
	var selected_path = await picker.pick_folder(self)
	Globals.game_path = selected_path
	print("Selected:", selected_path)
	picker.queue_free()
	Saving.save_data()
	_update_dir_text()

func _on_dir_text_changed() -> void:
	Globals.game_path = $Root/UI/Window/Buttons/GameDirectory/dir_text.text
	Globals.rpc_bridge_path = $Root/UI/Window/Buttons/RPCBridgeDirectory/dir_text.text
	Globals.wine_prefix_name = $Root/UI/Window/Buttons/WinePrefixName/dir_text.text

	Saving.save_data()

func _on_discord_buddy_directory_pressed() -> void:
	var picker = FolderPicker.new()
	add_child(picker)
	
	var selected_path = await picker.pick_folder(self)
	Globals.rpc_bridge_path = selected_path
	print("Selected:", selected_path)
	picker.queue_free()
	Saving.save_data()
	_update_dir_text()

func _on_reset_data_pressed() -> void:
	var window = object.create_object("res://scenes/objects/window/window.tscn", "/root/LauncherSettings/Root/UI", Vector2(0, 0))
	window.window_ok_clicked.connect(_on_resetdata_window_ok)
	window.window_cancel.connect(_on_resetdata_window_cancel)
	window.window_text = "Are you sure you want to reset, the Launcher settings? this is unreversible!"
	window._update_text()

func _on_resetdata_window_ok():
	SoundManager.play_sound(SoundManager.SOUNDS.destroy)
	Saving.reset_data()
	_update_dir_text()
	$Root/UI/Window/Buttons_br/ResetData.grab_focus()
	CircleTransition.transition("home/home", false, 1)
func _on_resetdata_window_cancel():
	$Root/UI/Window/Buttons_br/ResetData.grab_focus()
