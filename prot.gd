extends Node2D

const HIT_Y = 850.0
const MISS_Y = 1050

func external_hit_check():
	var difference = abs(position.y - HIT_Y)
	
	const PERFECT_THRESHOLD = 30
	
	if difference <= PERFECT_THRESHOLD:
		variables.points += 10
		variables.rating = 1 
	else:
		variables.points += 5
		variables.rating = 2 
		
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.1)
	tween.tween_callback(queue_free)
	return true 

func _process(delta):
	position.y += variables.tile_speed * delta
	
	if position.y >= MISS_Y: 
		var tween = create_tween()
		tween.tween_property(self, "modulate:a", 0.0, 0.1)
		tween.tween_callback(queue_free)
		variables.rating = 3
