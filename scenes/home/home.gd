extends CanvasLayer
@onready var rect = CircleTransition.get_node("ColorRect")

# Called when the node enters the scene tree for the first time.
func _enter_tree() -> void:
	BgmManager.play_bgm(BgmManager.BGM.MAIN_ALT)

func _ready() -> void:
	$Root/UI/Buttons.grab_focus()
	
func _on_quit_pressed() -> void:
	BgmManager.stop_bgm()
	CircleTransition.transition("home/home", false)
	await get_tree().create_timer(1).timeout
	get_tree().quit()

func _on_play_pressed() -> void:
	BgmManager.stop_bgm()
	CircleTransition.transition("home/home", true, 2)
	await get_tree().create_timer(1).timeout
	if Globals.os == "Linux":
		var args = [Globals.game_path + "Mario.exe"]
		OS.execute("wine", ["/home/user/.winegames/drive_c/windows/bridge.exe"], ["WINEPREFIX=~/.winegames"])
		OS.execute("wine", args, ["WINEPREFIX=~/.winegames"])	


func _on_launcher_settings_pressed() -> void:
	BgmManager.stop_bgm()
	CircleTransition.transition("launchersettings/launchersettings", false)
