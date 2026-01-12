extends Node2D

var pfeil_gruen = preload("res://pfeil_grün.tscn")
var pfeil_rot = preload("res://pfeil_rot.tscn")
var pfeil_gelb = preload("res://pfeil_gelb.tscn")
var pfeil_blau = preload("res://pfeil_blau.tscn")

@onready var spawner_gruen = get_node("SpawnerGrün")
@onready var spawner_rot = get_node("SpawnerRot")
@onready var spawner_gelb = get_node("SpawnerGelb")
@onready var spawner_blau = get_node("SpawnerBlau")
@onready var endtimer = $Timer2

@export var music_player: AudioStreamPlayer2D
@export var music_offset_seconds: float = -0.985

var map_data = [] 

@export var is_recording = false
var song_position = 0.0
var current_note_index = 0

const SPAWN_Y = -103.0 
const HIT_Y = 761.0
var note_travel_time = 0.0

func _ready():
	var travel_distance = HIT_Y - SPAWN_Y 
	
	if "variables" in get_tree().get_nodes_in_group("autoload"):
		note_travel_time = travel_distance / float(variables.tile_speed)
	else:
		print("KRITISCHER FEHLER: 'variables.gd' Autoload fehlt.")
		
	if not is_recording:
		load_map("mein_song.json") 

func _on_timer_timeout() -> void:
	music_player.play()

func _process(delta):
	song_position = music_player.get_playback_position()
	
	if is_recording:
		handle_recording()
	else:
		handle_playback()

func handle_recording():
	if Input.is_action_just_pressed("left"): save_note(1)
	elif Input.is_action_just_pressed("down"): save_note(2)
	elif Input.is_action_just_pressed("up"): save_note(3)
	elif Input.is_action_just_pressed("right"): save_note(4)
		
	if Input.is_action_just_pressed("ui_accept"):
		save_map_to_file("mein_song.json")
		print("Map gespeichert!")

func save_note(type_id):
	var note = {
		"time": song_position,
		"type": type_id 
	}
	map_data.append(note)
	print("Note aufgenommen: ", note)


func handle_playback():
	if current_note_index < map_data.size():
		var next_note = map_data[current_note_index]
		
		var spawn_time = next_note["time"] - note_travel_time + music_offset_seconds
		
		if song_position >= spawn_time:
			var note_type = int(next_note["type"]) 
			spawn_object(note_type) 
			current_note_index += 1
			
	handle_input()

func spawn_object(type):
	var object_scene_to_load = null
	var target_spawner = null
	
	match type:
		1: object_scene_to_load = pfeil_gruen; target_spawner = spawner_gruen
		2: object_scene_to_load = pfeil_rot;   target_spawner = spawner_rot
		3: object_scene_to_load = pfeil_gelb;  target_spawner = spawner_gelb
		4: object_scene_to_load = pfeil_blau;  target_spawner = spawner_blau
	
	if object_scene_to_load == null: return
	if target_spawner == null: 
		print("FEHLER: Konnte Spawner Node für Typ ", type, " nicht finden (Pfad im @onready prüfen)!")
		return
		
	var new_object = object_scene_to_load.instantiate()
	if new_object == null: return
	
	target_spawner.add_child(new_object)
	new_object.position = Vector2(0, SPAWN_Y) 


func handle_input():
	if Input.is_action_just_pressed("left"): check_hit_lane(spawner_gruen)
	elif Input.is_action_just_pressed("down"): check_hit_lane(spawner_rot)
	elif Input.is_action_just_pressed("up"): check_hit_lane(spawner_gelb)
	elif Input.is_action_just_pressed("right"): check_hit_lane(spawner_blau)


func check_hit_lane(spawner_node):
	if spawner_node == null: return
		
	var closest_note = null
	var min_distance = 10000.0 
	const MAX_HIT_DISTANCE = 250
	
	for note in spawner_node.get_children():
		if note is Node2D and note.has_method("external_hit_check"): 
			var distance = abs(note.position.y - HIT_Y)
			
			if distance < min_distance:
				min_distance = distance
				closest_note = note
	
	if closest_note != null and min_distance <= MAX_HIT_DISTANCE:
		closest_note.external_hit_check()
			
	elif closest_note == null or min_distance > MAX_HIT_DISTANCE:
		variables.rating = 4

func save_map_to_file(filename):
	var file = FileAccess.open("user://" + filename, FileAccess.WRITE)
	
	if file != null:
		var json_string = JSON.stringify(map_data)
		file.store_string(json_string)
		file.close()
	else:
		print("FEHLER: Datei konnte nicht erstellt werden! Ist der Pfad 'user://' beschreibbar?")

func load_map(filename):
	if FileAccess.file_exists("user://" + filename):
		var file = FileAccess.open("user://" + filename, FileAccess.READ)
		
		if file != null:
			var json_string = file.get_as_text()
			var json = JSON.new()
			var parse_result = json.parse(json_string)
			if parse_result == OK:
				map_data = json.data
				map_data.sort_custom(func(a, b): return a["time"] < b["time"])
				print("Map geladen mit ", map_data.size(), " Noten.")
			else:
				print("Fehler beim Lesen der JSON-Daten")
		else:
			print("Konnte Datei nicht lesen.")
	else:
		print("Keine Speicherdatei gefunden (noch keine Aufnahme gemacht?).")

func _on_finished() -> void:
	endtimer.start()

func _on_timer_2_timeout() -> void:
	pass # Replace with function body.
