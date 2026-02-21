extends CanvasLayer
var hide = false
signal window_cancel
signal window_ok_clicked

@export_multiline() var window_text = "Are you sure?"
@export var double: bool = true

func _ready() -> void:
	$AnimationPlayer.play("slide")
	if $Control/BG/Control/Buttons/Cancel:
		$Control/BG/Control/Buttons/Cancel.grab_focus()
	else:
		$Control/BG/Control/Buttons/OK.grab_focus()
	hide = false
	_update_text()

func _update_text():
	$Control/BG/Control/message.text = window_text
	
	if not double:
		$Control/BG/Control/Buttons/OK.position.x = 0
		$Control/BG/Control/Buttons/Cancel.queue_free()

func _hide():
	$AnimationPlayer.play_backwards("slide")
	hide = true

func _on_cancel_pressed() -> void:
	_hide()
	emit_signal("window_cancel")

func _on_ok_pressed() -> void:
	_hide()
	emit_signal("window_ok_clicked")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if hide:
		queue_free()
