extends Node

var points: int = 0
var spawn = RandomNumberGenerator.new()
var active: int = 0
var pos1: int = 885
var pos2: int = 785
var tile_speed: int = 1200
var spawn_random = false
var rating: int = 0

func _ready():
	if spawn_random == true:
		spawn.randomize()
