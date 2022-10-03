extends "res://src/objects/draggable_rigid.gd"

var current_recipe: Array = []
var time_on_heat: int = 0

const NUM_SHAKES_REQ = 8
const MAX_TIME_BETWEEN_SHAKES = 0.2
const MIN_MOUSE_MOVEMENT = 5

var last_direction:int = 1
var last_position_x:float = 0.0
var time_since_last_direction_change:float = 0.0
var num_shakes:int = 0

func _init(cur_recipe:Array = []):
	current_recipe = cur_recipe
#	current_recipe.push_back(RECIPEGENERATOR.op.WATER)

func init(cur_recipe:Array = []):
	current_recipe = cur_recipe

# Called when the node enters the scene tree for the first time.
func _ready():
	update_sprite()

func _physics_process(delta):
	._physics_process(delta)
	if held:
		time_since_last_direction_change += delta
		var mouse_global_x = get_global_mouse_position().x
		if abs(mouse_global_x - last_position_x) > MIN_MOUSE_MOVEMENT:
			var new_direction = sign(mouse_global_x - last_position_x)
			if new_direction != last_direction:
		#		Shake!
				if time_since_last_direction_change < MAX_TIME_BETWEEN_SHAKES:
					num_shakes += 1
					if num_shakes >= NUM_SHAKES_REQ:
						if can_add_item(RECIPEGENERATOR.get_shake_obj()):
							add_item(RECIPEGENERATOR.get_shake_obj())
						num_shakes = 0
				else:
					num_shakes = 1
				time_since_last_direction_change = 0
				last_direction = new_direction

#		print(num_shakes, " ", abs(mouse_global_x - last_position_x))
		last_position_x = mouse_global_x
	

func on_first_held():
	.on_first_held()
	num_shakes = 0
	time_since_last_direction_change = 0.0

func get_type():
	match current_recipe:
		[]: return RECIPEGENERATOR.op.EMPTY_BOTTLE
		[RECIPEGENERATOR.op.WATER]: return RECIPEGENERATOR.op.WATER_BOTTLE
		_: return RECIPEGENERATOR.op.POTION

func is_empty_bottle():
	return current_recipe.empty()

func get_current_recipe():
	return current_recipe

func can_add_item(new_item):
	print(new_item, new_item.get_type())
	if not new_item.has_method("get_type"):
		return false
	if current_recipe.empty():
		return new_item.get_type() == RECIPEGENERATOR.op.WATER
	match new_item.get_type():
		RECIPEGENERATOR.op.MUSHROOM: return true
		RECIPEGENERATOR.op.GROUND_MUSHROOM: return true
		RECIPEGENERATOR.op.PLANT: return true
		RECIPEGENERATOR.op.GROUND_PLANT: return true
		RECIPEGENERATOR.op.EYEBALL: return true
		RECIPEGENERATOR.op.GROUND_EYEBALL: return true
		RECIPEGENERATOR.op.LIZARD: return true
		RECIPEGENERATOR.op.GROUND_LIZARD: return true
		RECIPEGENERATOR.op.CRYSTAL: return true
		RECIPEGENERATOR.op.GROUND_CRYSTAL: return true
		RECIPEGENERATOR.op.SHAKE: return current_recipe.back() != RECIPEGENERATOR.op.SHAKE
		_: return false

func add_item(new_item):
	current_recipe.push_back(new_item.get_type())
	if (not RECIPEGENERATOR.is_heat_op(new_item.get_type())):
		set_time_on_heat(0)
	update_sprite()
	return true

func get_first_ingredient():
	match current_recipe:
		[]: return RECIPEGENERATOR.op.EMPTY_BOTTLE
		[RECIPEGENERATOR.op.WATER]: return RECIPEGENERATOR.op.WATER
		_: return current_recipe[1]

func update_sprite():
	#color based on first ingredient mostly, then other things will just affect slightly
	$PotionFilling.modulate = Color(RECIPEGENERATOR.get_color_from_recipe(current_recipe))
#	var f_ing = get_first_ingredient()
#	match f_ing:
#		RECIPEGENERATOR.op.EMPTY_BOTTLE:
#			$PotionFilling.modulate = Color8(0,0,0,0)
#		RECIPEGENERATOR.op.WATER:
#			$PotionFilling.modulate = Color('01c6cb')
#		_:
#			# Create a random has out of the contents of the string
#			# Ensure alpha channel is opaque
#			$PotionFilling.modulate = Color(RECIPEGENERATOR.get_color_from_recipe(current_recipe))

	# TODO play poof effect
	# TODO change alpha
#	TODO other stuffs
	#TODO add raw things in potion floating around

func filling_with_water_start():
	$WaterFillingParticles2D.emitting = true
	
func filling_with_water_stop():
	$WaterFillingParticles2D.emitting = false

func get_time_on_heat() -> int:
	return time_on_heat

func set_time_on_heat(t:int):
	time_on_heat = t
