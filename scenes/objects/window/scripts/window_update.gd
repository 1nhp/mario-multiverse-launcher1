extends window

signal window_more_info_clicked
signal window_update_clicked

func _on_more_info_pressed() -> void: 
	OS.shell_open("https://github.com/1nhp/mario-multiverse-launcher1/releases/")	
	emit_signal("window_more_info_clicked")
	
func _on_update_pressed() -> void: 
	_hide()
	emit_signal("window_update_clicked")


func _on_animation_player_animation_finished2(anim_name: StringName) -> void:
	$Control/BG/Mario_walking.speed_scale = 1
	$Control/BG/Mario_walking.play("default")
	$AnimationPlayer.play("mario_walking")
