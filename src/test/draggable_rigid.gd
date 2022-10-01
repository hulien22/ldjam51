extends RigidBody2D

class_name DraggableBody2D

# To inherit from this class, create new rigidbody2d and attach a script.
# When the popup appears, choose to inherit from this gdscript.

export var regular_collision_layer = 1
export var movement_collision_layer = 1 << 12 # layer 13, mask 13 will collide with this
export var throw_force_multiplier = 1
export var movement_multiplier = 25

var held = false
var mouse_offset
var click_order = 0
var old_collision_layer
var last_global_position = Vector2(0,0)
var last_global_mouse_pos = Vector2(0,0)
var last_delta = 0

func _ready():
	# stay awake for better collision detection
	can_sleep = false

func _physics_process(delta):
	if held:
		last_delta = delta
		last_global_position = global_position
		last_global_mouse_pos = get_global_mouse_position() - mouse_offset
		global_position = lerp(global_position, last_global_mouse_pos, movement_multiplier * delta)
		
#		TODO add some rotation while grabbing too?
#		var last_force = last_global_position.distance_to(last_global_mouse_pos) / last_delta / 50 * throw_force_multiplier
#		angular_velocity += mouse_offset.angle_to(global_position - last_global_position) * mouse_offset.length_squared() * 0.0001 * last_force * 0.001
#		angular_velocity = get_local_mouse_position().x * 0.125 - get_local_mouse_position().y * 0.125
#		angular_velocity = get_local_mouse_position().x * 0.01 - get_local_mouse_position().y * 0.01
	elif collision_layer != regular_collision_layer and linear_velocity.length_squared() < 1000000:
		collision_layer = regular_collision_layer
	elif collision_layer != movement_collision_layer and linear_velocity.length_squared() >= 1000000:
		collision_layer = movement_collision_layer


func pickup():
	if held:
		return
	held = true
	old_collision_layer = collision_layer
	collision_layer = movement_collision_layer
	var global_mouse_loc = get_global_mouse_position()
	mouse_offset = global_mouse_loc - global_position
	raise()
	angular_velocity = rand_range(-.1,.1)

func drop(impulse=Vector2.ZERO):
	if held:
#		todo this isn't quite right
		var last_force = last_global_position.distance_to(last_global_mouse_pos) / last_delta / 50 * throw_force_multiplier
		impulse = last_global_position.direction_to(last_global_mouse_pos) * 10 * last_force
#		impulse = Input.get_last_mouse_speed() * .5
		apply_central_impulse(impulse)
#		calculation based on a pseudo-dot product of distance last moved, and mouse offset from center of obj
		angular_velocity += mouse_offset.angle_to(global_position - last_global_position) * mouse_offset.length_squared() * 0.0001 * last_force * 0.01
#		collision_layer = old_collision_layer
		held = false

func get_click_order():
	return click_order

func set_click_order(co):
	click_order = co
