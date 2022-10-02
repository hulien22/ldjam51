extends "res://src/test/draggable_rigid.gd"
class_name Recipe

var recipe = []
var potion = ""

# Called when the node enters the scene tree for the first time.
func _ready():
#	Want to be above papers
# 	TODO export these values to constants somewhere
	z_index = 1
	regular_collision_layer = 3
	movement_collision_layer = 4096

func set_recipe(recipe_seq: Array):
	recipe = recipe_seq

func set_potion(potion_name: String):
	potion = potion_name
