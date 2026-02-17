extends CanvasLayer

var reverse = false
var scene = ""
var reload = false
var delay: int

func _ready() -> void:
	visible = false

func transition(scene_path: String = "", reload_scene: bool = false, delay1: int = 0):
	$AnimationPlayer.play("transition")
	scene = "res://scenes/" + str(scene_path) + ".tscn"
	reload = reload_scene
	visible = true
	delay = delay1
	get_tree().paused = true

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "transition" and not reverse:
		await get_tree().create_timer(delay).timeout
		reverse = true
		
		if reload == false:
			get_tree().change_scene_to_file(scene)
		else:
			get_tree().reload_current_scene()			
		await get_tree().create_timer(0.3).timeout	
		$AnimationPlayer.play_backwards("transition")
		await get_tree().create_timer(0.6).timeout
		get_tree().paused = false
		visible = false
		reverse = false
		$AnimationPlayer.stop()
