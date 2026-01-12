extends Node

@export var point: Label

func _process(delta: float) -> void:
	point.text = "Score: " + str(variables.points)
