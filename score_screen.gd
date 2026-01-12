extends Control
func _ready():
	$AnimationPlayer.play("RESET")
	hide()

func pause():
	get_tree().paused = true
	$AnimationPlayer.play("blur")
	show()

func _on_retry_pressed() -> void:
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	hide()
	get_tree().reload_current_scene()

func _on_levels_pressed() -> void:
	get_tree().paused = false
	hide()
	get_tree().change_scene_to_file("res://level_menu.tscn")

func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().quit()

func _on_audio_stream_player_2d_finished() -> void:
	pause()
