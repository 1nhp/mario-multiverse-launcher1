extends window

signal window_more_info_clicked
signal window_update_clicked

func _on_more_info_pressed() -> void :
    OS.shell_open("https://github.com/1nhp/mario-multiverse-launcher1/releases/")
    emit_signal("window_more_info_clicked")

func _on_update_pressed() -> void :
    _hide()
    emit_signal("window_update_clicked")


func _on_animation_player_animation_finished(anim_name: StringName) -> void :
    if $Control / BG / Progress / Mario_walking:
        $Control / BG / Progress / Mario_walking.speed_scale = 1
        $Control / BG / Progress / Mario_walking.play("running")
        $AnimationPlayer.play("mario_walking")
        $Control / BG / Progress / qblock.play("default")
        $Control / BG / Progress / coin.play("default")
        Updatechecker.mario_update_complete_anim.connect(_update_finished)
        Updatechecker.mario_update_failed_anim.connect(_update_failed)

    if hide:
        queue_free()

func _update_finished():
    $AnimationPlayer.stop(true)

    var tween = create_tween()
    tween.tween_property($Control / BG / Progress / Mario_walking, "position", Vector2(460, 480), 0.9)
    await tween.finished

    $AnimationPlayer.play("mario_update_finish")

func _update_failed():
    $AnimationPlayer.play("mario_update_failed")
    $Control / BG / Progress / goomba.play("idle")
    var tween = create_tween()
    tween.tween_property($Control / BG / Progress / Mario_walking, "position", Vector2(700, 480), 1.2)
    await tween.finished
    $Control / BG / Progress / goomba.stop()
    BgmManager.stop_bgm()
