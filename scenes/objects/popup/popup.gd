extends Control

@export var popuptext: String = "Hello World"
var fading_out = false

func _ready() -> void:
	_update_text()
	fade()
	
func fade():
	$AnimationPlayer.play("fade")
	fading_out = false

func fade_out():
	$AnimationPlayer.play_backwards("fade")
	fading_out = true

func _update_text():
	$Container/text.text = popuptext	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade" and fading_out:
		queue_free()
