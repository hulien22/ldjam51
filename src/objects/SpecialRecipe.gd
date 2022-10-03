extends "res://src/objects/draggable_rigid.gd"

var recipe = []
var potion = ""
var potion_type = 0

# Called when the node enters the scene tree for the first time.
func _ready():
#	Want to be above papers
# 	TODO export these values to constants somewhere
	z_index = 0
	collision_mask = 1<<12

func set_recipe(recipe_seq: Array):
	recipe = recipe_seq
#	$Node2D/Steps2.text = steps

func get_type():
	return -1

func set_potion(potion_name: String, pt:int):
	potion = potion_name
	potion_type = pt
	$Node2D/Label2.text = potion
	$Node2D/Steps2.text = RECIPEGENERATOR.get_recipe_steps_str(potion_type)
	match pt:
		RECIPEGENERATOR.potions.XASIO:
			$Node2D/RecipeAddStep.text = ""
			$Node2D/RecipeAddStep.hide()
		RECIPEGENERATOR.potions.EWIPFS:
			$Node2D/RecipeAddStep.text = "XASIO"
			$Node2D/RecipeAddStep.show()
		RECIPEGENERATOR.potions.GIANTIV:
			$Node2D/RecipeAddStep.text = "EWIPFS"
			$Node2D/RecipeAddStep.show()
			$Node2D/Steps2.text += " - DRINK ME - "

func can_delete():
	return false
