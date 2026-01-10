extends Node

@onready var song1: AudioStreamPlayer2D = $Song1
@onready var song2: AudioStreamPlayer2D = $Song2

var music = randi_range(1,2)

func _ready() -> void:
	if music == 1:
		song1.play()
	elif music == 2:
		song2.play()

func _on_song_1_finished() -> void:
	song2.play()

func _on_song_2_finished() -> void:
	song1.play()
