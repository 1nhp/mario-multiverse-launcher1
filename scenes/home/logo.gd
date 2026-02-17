extends Node2D

var angle: float = 0.0
var radius: float = 20
var center_position: Vector2 = Vector2(position.x, position.y + 20) # The center of the circle
var amplitude: float = 0.7

func _process(delta: float) -> void:
	angle += delta * amplitude
	var y = center_position.y + sin(angle) * radius
	
	position.y = y
