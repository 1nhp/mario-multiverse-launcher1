extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _enter_tree() -> void:
	BgmManager.play_bgm(BgmManager.BGM.SETTINGS)
	
func _ready() -> void:
	$Root/UI/MenuButtons/Quit.grab_focus()	


func _on_quit_pressed() -> void:
	BgmManager.stop_bgm()
	CircleTransition.transition("home/home", false)
