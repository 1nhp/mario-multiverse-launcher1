extends Node

signal mario_update_complete_anim
signal mario_update_failed_anim

const LOCAL_VERSION_PATH: = "res://version.json"
const GITHUB_VERSION_URL: = "https://raw.githubusercontent.com/1nhp/mario-multiverse-launcher1/refs/heads/main/version.json"

var remote_version: String = ""
var remote_download_url: String = ""

var http_request_version: HTTPRequest
var http: HTTPRequest
var download_path: String

func _ready() -> void :
    process_mode = Node.PROCESS_MODE_ALWAYS


func check_launcher_version():

    http_request_version = HTTPRequest.new()
    add_child(http_request_version)


    http_request_version.request_completed.connect(_on_version_request_completed)
    http_request_version.request(GITHUB_VERSION_URL)
    await http_request_version.request_completed




func _on_version_request_completed(result, response_code, headers, body):
    var json = JSON.parse_string(body.get_string_from_utf8())

    remote_version = str(json["version"])
    if Globals.os == "Linux":
        remote_download_url = str(json["download_url"])
    elif Globals.os == "Windows":
        remote_download_url = str(json["download_url_windows"])

    if json == null:
        print("Invalid JSON from version server")
        return

    compare_versions(Globals.version, remote_version)

    http_request_version.queue_free()

func is_remote_newer(local: String, remote: String) -> bool:
    var l = local.split(".")
    var r = remote.split(".")

    var max_len = max(l.size(), r.size())

    for i in range(max_len):
        var lv = int(l[i]) if i < l.size() else 0
        var rv = int(r[i]) if i < r.size() else 0

        if rv > lv: return true
        elif rv < lv: return false

    return false


func compare_versions(local_version: String, remote_version: String):
    if is_remote_newer(local_version, remote_version):
        print("Update available 🚀")
        var window = object.create_object("res://scenes/objects/window/window_update.tscn", "/root/Home/Root/UI", Vector2.ZERO)

        SoundManager.play_sound(SoundManager.SOUNDS.correct)
        window.window_update_clicked.connect(_on_window_update_clicked)
    else:
        print("You are up to date ✅")
        var window = object.create_object("res://scenes/objects/window/window.tscn", "/root/Home/Root/UI", Vector2.ZERO)
        window.window_text = "Launcher is on latest version"
        window.double = false
        window._update_text()
        get_tree().paused = false


func _on_more_info_pressed() -> void :
    OS.shell_open("https://github.com/1nhp/mario-multiverse-launcher1/releases/")


func _on_window_update_clicked():
    if Globals.os == "Linux":
        download_path = Globals.launcher_path + "/Mario Multiverse Launcher.new"
    elif Globals.os == "Windows":
        download_path = Globals.launcher_path + "/Mario Multiverse Launcher.new.exe"
    var window = object.create_object("res://scenes/objects/window/window_updating.tscn", "/root/Home/Root/UI", Vector2.ZERO)
    BgmManager.stop_bgm()
    BgmManager.play_bgm(BgmManager.BGM.UPDATE)
    download(remote_download_url, download_path)


func download(link: String, path: String):
    http = HTTPRequest.new()
    http.timeout = 20
    add_child(http)

    http.request_completed.connect(_on_download_completed)
    http.set_download_file(path)
    http.request(link)


func _on_download_completed(result, response_code, headers, body):
    http.queue_free()

    if result != HTTPRequest.RESULT_SUCCESS:
        print("Download error: ", result)
        _update_failed()
        emit_signal("mario_update_failed_anim")
        return

    if response_code != 200:
        print("HTTP error: ", response_code)
        _update_failed()
        return

    print("Download finished successfully")
    emit_signal("mario_update_complete_anim")
    _on_update_completed()


func _on_update_completed():
    await get_tree().create_timer(4).timeout
    SoundManager.play_sound(SoundManager.SOUNDS.update_complete)

    var window = object.create_object("res://scenes/objects/window/window.tscn", "/root/Home/Root/UI", Vector2.ZERO)
    get_tree().get_first_node_in_group("WindowUpdating")._hide()

    window.window_text = "Update complete! restarting..."
    window.double = false
    window._update_text()

    BgmManager.stop_bgm()
    await get_tree().create_timer(2).timeout
    CircleTransition.transition("home/home", true, 1)

    var final_path = Globals.launcher_path + "/Mario Multiverse Launcher.x86_64"

    if Globals.os == "Linux":
        final_path = Globals.launcher_path + "/Mario Multiverse Launcher.x86_64"
        DirAccess.remove_absolute(final_path)
        DirAccess.rename_absolute(download_path, final_path)
        OS.execute("chmod", ["+x", final_path])
        OS.create_process(final_path, [], true)

    elif Globals.os == "Windows":
        final_path = Globals.launcher_path + "/Mario Multiverse Launcher.exe"
        DirAccess.remove_absolute(final_path)
        DirAccess.rename_absolute(download_path, final_path)
        OS.create_process(final_path, [], true)


    await get_tree().create_timer(1).timeout
    get_tree().quit()

func _update_failed():
    await get_tree().create_timer(5).timeout
    SoundManager.play_sound(SoundManager.SOUNDS.wrong)
    print("Launcher Updating failed..")

    var window = object.create_object("res://scenes/objects/window/window.tscn", "/root/Home/Root/UI", Vector2.ZERO)
    get_tree().get_first_node_in_group("WindowUpdating")._hide()

    window.window_text = "Something went wrong during updating process try checking your internet connection."
    window.double = false
    window._update_text()

    BgmManager.stop_bgm()
    BgmManager.play_bgm(BgmManager.BGM.SETTINGS)
