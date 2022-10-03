extends "res://src/objects/draggable_rigid.gd"

var current_recipe: Array = []

func _init(cur_recipe:Array = []):
	current_recipe = cur_recipe
#	current_recipe.push_back(RECIPEGENERATOR.op.WATER)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func get_type():
	return RECIPEGENERATOR.op.REQUEST

func get_current_recipe():
	return current_recipe
