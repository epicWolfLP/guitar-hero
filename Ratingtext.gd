extends Node

@export var perfect: Label
@export var good: Label
@export var missed: Label

var current_rating = -1
var labels := []
var default_pos := {}

func _ready():
	labels = [perfect, good, missed]
	for label in labels:
		label.visible = false
		label.modulate.a = 0.0
		default_pos[label] = label.position

func _process(_delta):
	if variables.rating != current_rating:
		current_rating = variables.rating
		update_labels()

func update_labels():
	match current_rating:
		1: animate_label(perfect, Color(0.0,0.3,1.0), Color(0.5,0.8,1.0))
		2: animate_label(good, Color(0.0,1.0,0.0), Color(0.5,1.0,0.5))
		3: animate_label(missed, Color(1.0,0.0,0.0), Color(1.0,0.5,0.5))
		_: hide_all()

func animate_label(target, start_color: Color, end_color: Color):
	for label in labels:
		if label == target:
			label.visible = true
			label.position = default_pos[label] + Vector2(0, 20)
			label.modulate = start_color
			label.scale = Vector2(0.8, 0.8)

			var t = create_tween()
			t.tween_property(label, "modulate", end_color, 0.2)
			t.parallel().tween_property(label, "modulate:a", 1.0, 0.2)
			t.parallel().tween_property(label, "position", default_pos[label], 0.2)
			t.parallel().tween_property(label, "scale", Vector2(1,1), 0.2)
		else:
			hide_label(label)
			
func hide_label(label):
	if label.visible == false: return
	var t = create_tween()
	t.tween_property(label, "modulate:a", 0.0, 0.15)
	t.parallel().tween_property(label, "position", default_pos[label] + Vector2(10,20), 0.15)
	t.finished.connect(func(): label.visible = false)

func hide_all():
	for label in labels:
		hide_label(label)
