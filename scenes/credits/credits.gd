extends Node

func _ready() -> void :
    BgmManager.play_bgm(BgmManager.BGM.CREDITS)
    $AnimationPlayer.play("animation")

func _on_quit_pressed() -> void :
    BgmManager.stop_bgm()
    CircleTransition.transition("home/home", false)
