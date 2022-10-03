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

func set_potion(potion_name: String, pt:int):
	potion = potion_name
	potion_type = pt
	$Node2D/Label.text = potion
	$Node2D/Steps2.text = RECIPEGENERATOR.get_recipe_steps_str(potion_type)
