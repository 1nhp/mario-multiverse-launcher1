extends Node2D

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS

func _unhandled_input(event: InputEvent) -> void:
	if OS.is_debug_build():
		if Input.is_action_just_pressed("reload_scene"):
			var tree = get_tree()
			if tree:
				var scene_name = tree.current_scene.name
				await get_tree().create_timer(0.1).timeout
				get_tree().reload_current_scene()
				print_debug("Scene: reloaded " + str(scene_name))
