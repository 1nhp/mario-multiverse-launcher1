extends Control

@export var popuptext: String = "Hello World"
@export var popup_size: Vector2

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
	$Container.custom_minimum_size = popup_size

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade" and fading_out:
		queue_free()
