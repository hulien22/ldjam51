extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print(RECIPEGENERATOR.potions_recipes) 
	
	get_node("Recipe").set_recipe(RECIPEGENERATOR.potions_recipes["HEALTH"])
	#get_node("Recipe").set_potion(GLOBAL.potions_recipes[GLOBAL.potions.HEALTH])
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
