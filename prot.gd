extends Node2D

const HIT_Y = 850.0
const MISS_Y = 1050

func external_hit_check():
	var difference = abs(position.y - HIT_Y)
	
	const PERFECT_THRESHOLD = 20
	
	if difference <= PERFECT_THRESHOLD:
		variables.points += 10
		variables.rating = 1 
	else:
		variables.points += 5
		variables.rating = 2 
		
	queue_free()
	return true 

func _process(delta):
	position.y += variables.tile_speed * delta
	
	if position.y >= MISS_Y: 
		queue_free()
		variables.rating = 3
