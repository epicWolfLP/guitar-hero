extends Node

@onready var music_player = $AudioStreamPlayer2D
@onready var music_player2 = $AudioStreamPlayer2D2

func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://guitar-hero.tscn")

func _on_texture_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://guitar-hero-2.tscn")

func _on_texture_button_mouse_entered() -> void:
	music_player.play()

func _on_texture_button_mouse_exited() -> void:
	music_player.stop()


func _on_texture_button_2_mouse_entered() -> void:
	music_player2.play()


func _on_texture_button_2_mouse_exited() -> void:
	music_player2.stop()
