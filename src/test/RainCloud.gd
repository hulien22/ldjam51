extends Sprite

export (float) var horizontal_margin = 300.0
export (float) var horizontal_speed = 50.0
export (float) var vertical_speed = 1
export (float) var vertical_oscillation_strength = 0.6

var horizontal_movement_dir = -1
var vertical_oscillation_phase = 0.0

onready var shadow = $Polygon2D

func _process(delta):
	vertical_oscillation_phase += vertical_speed * delta
	vertical_oscillation_phase = fmod(vertical_oscillation_phase, 2*PI)
	position += Vector2(horizontal_speed * horizontal_movement_dir * delta, vertical_oscillation_strength*sin(vertical_oscillation_phase))
	var right_margin = get_viewport().size.x - horizontal_margin
	if position.x <= horizontal_margin or position.x >= right_margin:
		horizontal_movement_dir = -horizontal_movement_dir
		flip_h = !flip_h
		shadow.scale.x = -shadow.scale.x
		shadow.position.x = -shadow.position.x
	position.x = clamp(position.x, horizontal_margin, right_margin)
