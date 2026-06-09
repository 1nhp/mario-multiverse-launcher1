
extends Node

var tray_icon = preload("res://sprites/logo.png")

func _ready():

    DisplayServer.create_status_indicator(tray_icon, "ass", _on_tray_clicked)
    print("ass")

func _on_tray_clicked():

    DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
    DisplayServer.window_move_to_foreground()

func _notification(what):
    if what == NOTIFICATION_WM_CLOSE_REQUEST:

        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)
