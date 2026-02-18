class_name LineEditUtil
extends LineEdit

signal changed

func _ready():
	text_changed.connect(_on_text_changed)

func _on_text_changed(new_text: String):
	emit_signal("changed")
	print_debug("TextEntry: changed " + new_text)
	SoundManager.play_sound(SoundManager.SOUNDS.hover)
