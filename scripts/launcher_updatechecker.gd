extends Node

const LOCAL_VERSION_PATH := "res://version.json"
const GITHUB_VERSION_URL := "https://raw.githubusercontent.com/1nhp/mario-multiverse-launcher1/refs/heads/main/version.json"

var remote_version: String = ""
var remote_download_url: String = ""

var http_request_version: HTTPRequest
var http: HTTPRequest
var download_path: String

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
# Get the version from version.json from the github repository
func check_launcher_version():
	# Create HTTPRequest object
	http_request_version = HTTPRequest.new()
	add_child(http_request_version)
	
	# Connect request completed signal
	http_request_version.request_completed.connect(_on_version_request_completed)
	http_request_version.request(GITHUB_VERSION_URL)
	await http_request_version.request_completed	
	
# After request is complete, fetch the version and download_url keys from version.json
# TODO: This is not crossplatform currently yet

func _on_version_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	
	remote_version = str(json["version"])
	remote_download_url = str(json["download_url"])
	compare_versions(Globals.version, remote_version)

	http_request_version.queue_free()

func is_remote_newer(local: String, remote: String) -> bool:
	var local_parts = local.split(".")
	var remote_parts = remote.split(".")

	for i in range(min(local_parts.size(), remote_parts.size())):
		var l = int(local_parts[i])
		var r = int(remote_parts[i])

		if r > l: return true
		elif r < l: return false

	return remote_parts.size() > local_parts.size()

# Compare versions if it doesn't match create update window
func compare_versions(local_version: String, remote_version: String):
	if is_remote_newer(local_version, remote_version):
		print("Update available 🚀")
		var window = object.create_object("res://scenes/objects/window/window_update.tscn","/root/Home/Root/UI",Vector2.ZERO)
		# Play correct sound and connect window update button clicked signal
		SoundManager.play_sound(SoundManager.SOUNDS.correct)
		window.window_update_clicked.connect(_on_window_update_clicked)
	else:
		print("You are up to date ✅")
		var window = object.create_object("res://scenes/objects/window/window.tscn","/root/Home/Root/UI",Vector2.ZERO)
		window.window_text = "Launcher is on latest version"
		window.double = false
		window._update_text()
		get_tree().paused = false
		
# If more info is clicked redirect to releases page
func _on_more_info_pressed() -> void:
	OS.shell_open("https://github.com/1nhp/mario-multiverse-launcher1/releases/")

# Download the launcher from the download_path
func _on_window_update_clicked():
	download_path = Globals.launcher_path + "/Mario Multiverse Launcher.new"
	var window = object.create_object("res://scenes/objects/window/window_updating.tscn", "/root/Home/Root/UI", Vector2.ZERO)
	BgmManager.stop_bgm()
	BgmManager.play_bgm(BgmManager.BGM.UPDATE)
	download(remote_download_url, download_path)
	
# Download function
func download(link: String, path: String):
	http = HTTPRequest.new()
	http.timeout = 5
	add_child(http)

	http.request_completed.connect(_on_download_completed)
	http.set_download_file(path)
	http.request(link)

# If download is completed create update window again with completed message
func _on_download_completed(result, response_code, headers, body):
	http.queue_free()

	if result != HTTPRequest.RESULT_SUCCESS:
		print("Download error: ", result)
		SoundManager.play_sound(SoundManager.SOUNDS.wrong)
		_update_failed()
		return

	if response_code != 200:
		print("HTTP error: ", response_code)
		SoundManager.play_sound(SoundManager.SOUNDS.wrong)
		_update_failed()
		return

	print("Download finished successfully")
	_on_update_completed()

# Update complete function
func _on_update_completed():
	SoundManager.play_sound(SoundManager.SOUNDS.update_complete)

	var window = object.create_object("res://scenes/objects/window/window.tscn","/root/Home/Root/UI",Vector2.ZERO)
	get_tree().get_first_node_in_group("WindowUpdating")._hide()
	
	window.window_text = "Update complete! restarting..."
	window._update_text()
	
	BgmManager.stop_bgm()
	CircleTransition.transition("home/home", true, 1)
	
	await get_tree().create_timer(1).timeout
	var final_path = Globals.launcher_path + "/Mario Multiverse Launcher.x86_64"
	DirAccess.remove_absolute(final_path)
	DirAccess.rename_absolute(download_path, final_path)
	
	# Chmod stuff
	var launcher_path = Globals.launcher_path + "/Mario Multiverse Launcher.x86_64"
	OS.execute("chmod", ["+x", launcher_path])
	
	# Create launcher process
	OS.create_process(launcher_path, [], true)
	
	# Let the window play close animation before launcher closes
	await get_tree().create_timer(1).timeout
	get_tree().quit()

func _update_failed():
	print("Launcher Updating failed..")
	
	var window = object.create_object("res://scenes/objects/window/window.tscn","/root/Home/Root/UI",Vector2.ZERO)
	get_tree().get_first_node_in_group("WindowUpdating")._hide()
	
	window.window_text = "Something went wrong during updating process try checking your internet connection."
	window._update_text()
	
	BgmManager.stop_bgm()
	BgmManager.play_bgm(BgmManager.BGM.MAIN_ALT)
