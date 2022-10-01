extends Node2D

class_name RecipeGenerator

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum op {WATER, HEAT, COOL, SHAKE,
 LEAF, HERB, THISTLE, FLOWER, MUSHROOM,
 GROUND_LEAF, GROUND_HERB, GROUND_THISTLE, GROUND_FLOWER, GROUND_MUSHROOM}

enum potions {HEALTH, SPEED, INVISIBLE, POWER, WATER,
SUPER_SONIC, JOE_TOES}

# ordered in easy to hard potions?
var potions_recipes = {"HEALTH": [op.WATER,op.LEAF,op.HEAT]}

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_recipe()
	pass # Replace with function body.


func generate_recipe():
	#should return an 
	pass
