extends RigidBody2D

signal clicked

var held = false
var mouse_offset
var click_order = 0

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			mouse_offset = self.get_local_mouse_position()
			emit_signal("clicked", self)
			
func _physics_process(delta):
	if held:
		global_position = lerp(global_position, get_global_mouse_position() - mouse_offset, 25 * delta)
#		global_transform.origin = get_global_mouse_position()
#		var direction = (get_global_mouse_position() - self.global_position).normalized()
#		self.linear_velocity = direction * 5
		var angularVelocity = Vector2.ZERO
		angular_velocity = get_local_mouse_position().x * 0.125 - get_local_mouse_position().y * 0.125
	else:
		pass
		

func pickup():
	if held:
		return
	mode = RigidBody2D.MODE_RIGID
	held = true
	raise()

func drop(impulse=Vector2.ZERO):
	if held:
		impulse = Input.get_last_mouse_speed()
		mode = RigidBody2D.MODE_RIGID
		apply_central_impulse(impulse)
		held = false

func get_click_order():
	return click_order

func set_click_order(co):
	click_order = co
