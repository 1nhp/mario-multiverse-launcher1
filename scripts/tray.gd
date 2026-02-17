# Example (Godot 4)
extends Node

var tray_icon = preload("res://sprites/logo.png")

func _ready():
	# Create a status indicator
	DisplayServer.create_status_indicator(tray_icon, "ass", _on_tray_clicked)
	print("ass")
	
func _on_tray_clicked():
	# Bring window back
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	DisplayServer.window_move_to_foreground()

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		# Hide window instead of closing
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)
		# Optional: Use a hidden window state if needed
