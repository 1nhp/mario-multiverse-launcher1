extends Node
class_name FolderPicker

func pick_folder(parent: Node) -> String:
	var dialog := FileDialog.new()
	dialog.file_mode = FileDialog.FILE_MODE_OPEN_DIR
	dialog.access = FileDialog.ACCESS_FILESYSTEM
	dialog.title = "Select Folder"
	dialog.use_native_dialog = true
	parent.add_child(dialog)
	dialog.popup_centered()
	
	dialog.canceled.connect(_cancelled)
	
	var path: String = await dialog.dir_selected
	SoundManager.play_sound(SoundManager.SOUNDS.correct)
	dialog.queue_free()

	return path

func _cancelled():
	SoundManager.play_sound(SoundManager.SOUNDS.wrong)
