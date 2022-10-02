extends ViewportContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (float) var green = 0
export (float) var flip = 0

var green_duration = 0
var flip_duration = 0

onready var viewport = get_node("Viewport")

func _ready():
	material.set_shader_param("ShowGreen", green)
	material.set_shader_param("ShowFlipped", flip)
	set_process_input(true)
	viewport.set_input_as_handled()
	print(viewport.is_input_handled())
	
func _unhandled_input(event):
	viewport.input(event)

func _process(delta):
	if green_duration > 0:
		green = lerp(green, 1, delta)
	else:
		green = lerp(green, 0, delta)
		if green < 0.01:
			green = 0
	if flip_duration > 0:
		
		flip = lerp(flip, 1, delta)
	else:
		flip = lerp(flip, 0, delta)
		if flip < 0.001:
			flip = 0
	flip_duration -= delta
	green_duration -= delta
	flip_duration = clamp(flip_duration, 0, 10)
	green_duration = clamp(green_duration, 0, 10)
	material.set_shader_param("ShowGreen", green)
	material.set_shader_param("ShowFlipped", flip)

func _on_turn_green():
	green_duration += 3

func _on_flip():
	flip_duration += 2
