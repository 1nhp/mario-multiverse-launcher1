class_name menuButton
extends Control

signal pressed

@export var popup_right_offset: int
@export var popup_top_offset: int
@export var icon_right_offset: int
@export var icon_top_offset: float
@export var popup_size: Vector2
@export var show_popup: bool = true

@export_multiline var popup_text: String

var current_popup: Control

func _ready() -> void:
	focus_mode = Control.FOCUS_ALL
	focus_entered.connect(_show)
	focus_exited.connect(_hide)
	focus_exited.connect(_hide_popup)


func _show() -> void:
	SoundManager.play_sound(SoundManager.SOUNDS.hover)

	if not has_node("select_icon"):
		var icon := TextureRect.new()
		icon.name = "select_icon"
		icon.texture = load("res://sprites/goomb_sel_icon.png")
		icon.custom_minimum_size = Vector2(24, 24)
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		
		icon.anchor_top = 0.5
		icon.anchor_bottom = 0.5 + icon_top_offset
		icon.offset_top = -icon.custom_minimum_size.y / 2
		icon.offset_left = -40 + icon_right_offset
		icon.self_modulate.a = 0.5
		
		add_child(icon)
	
	# Popup
	if current_popup:
		current_popup.queue_free()

	var popup = load("res://scenes/objects/popup/popup.tscn").instantiate()
	popup.popuptext = popup_text
	popup.position = Vector2(popup_right_offset, popup_top_offset)
	popup.popup_size = popup_size
	add_child(popup)
	current_popup = popup
	
	if show_popup == false:
		popup.visible = false

func _hide() -> void:
	var icon = get_node("select_icon")
	if icon:
		icon.queue_free()
		
func _hide_popup():
	if current_popup != null:
		current_popup.fade_out()
		current_popup = null


func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") or (
		event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.pressed
	):
		SoundManager.play_sound(SoundManager.SOUNDS.decide)
		_hide_popup()
		var icon = get_node("select_icon")
		if icon: icon.self_modulate.a = 1
		emit_signal("pressed")


func _on_mouse_entered() -> void:
	_show()
	
func _on_mouse_exited() -> void:
	_hide()
	_hide_popup()


func _on_gui_input(event: InputEvent) -> void:
	pass # Replace with function body.
