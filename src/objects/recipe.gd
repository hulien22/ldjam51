extends "res://src/objects/draggable_rigid.gd"

var recipe = []
var potion = ""

# Called when the node enters the scene tree for the first time.
func _ready():
#	Want to be above papers
# 	TODO export these values to constants somewhere
	z_index = 0
	collision_mask = 1<<12

func set_recipe(recipe_seq: Array):
	recipe = recipe_seq

func set_potion(potion_name: String):
	potion = potion_name
	$Node2D/Label.text = potion
