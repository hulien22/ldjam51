extends "res://src/objects/draggable_rigid.gd"

var current_recipe: Array = []

func _init(cur_recipe:Array = []):
	current_recipe = cur_recipe
#	current_recipe.push_back(RECIPEGENERATOR.op.WATER)

func init(cur_recipe:Array = []):
	current_recipe = cur_recipe

# Called when the node enters the scene tree for the first time.
func _ready():
	update_sprite()

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
		_: return false

func add_item(new_item):
	current_recipe.push_back(new_item.get_type())
	update_sprite()

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
