extends Sprite
class_name Recipe

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var recipe = []
var potion = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_recipe(recipe_seq: Array):
	recipe = recipe_seq

func set_potion(potion_name: String):
	potion = potion_name
