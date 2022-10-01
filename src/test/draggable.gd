extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var selected = false
var mouse_offset
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#func _on_Area2D_input_event(viewport, event, shape_idx):
#	if Input.is_action_just_pressed("LEFT_CLICK"):
#		raise()
#		selected = true

func on_click():
	print("hey")
	raise()
	selected = true
	mouse_offset = self.get_local_mouse_position()

		
func _physics_process(delta):
	if selected:
		global_position = lerp(global_position, get_global_mouse_position() - mouse_offset, 25 * delta)
#		TODO figure out some kind of rotation here?
#		look_at(get_global_mouse_position())

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			selected = false
#			var shortest_dist = 75
#			for child in rest_nodes:
#				var distance = global_position.distance_to(child.global_position)
#				if distance < shortest_dist:
#					child.select()
#					rest_point = child.global_position
#					shortest_dist = distance

