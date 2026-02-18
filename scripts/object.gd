extends Node

func create_object(object_dir, node_dir, position):
	var object = load(object_dir)
	var object_instance = object.instantiate()
	
	var parent_node = get_node_or_null(node_dir)
	
	parent_node.add_child(object_instance)   # <-- add the instance, not the PackedScene
	if not CanvasLayer:
		object_instance.position = position
	
	print_debug("Object created: " + str(object_instance))
	return object_instance
