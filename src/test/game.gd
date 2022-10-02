extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#var arr = RECIPEGENERATOR.get_random_array(2,RECIPEGENERATOR.ingredients)
	#for i in arr:
	#	print(RECIPEGENERATOR.op.keys()[i])
	#print(RECIPEGENERATOR.generate_recipes(4,3,3))
	#print(RECIPEGENERATOR.op)
	print(RECIPEGENERATOR.generate_recipe_template())
	var potion_recipes= RECIPEGENERATOR.generate_recipe_template()
	#print(RECIPEGENERATOR.random_ops_ingreds(RECIPEGENERATOR.ingredients,RECIPEGENERATOR.operations,3,2))
	#var potions = potion_recipes.keys()
		#sleep(10s)
		#potion_recipes[portion]
	#get_node("Recipe").set_recipe(RECIPEGENERATOR.potions_recipes["HEALTH"])
	#get_node("Recipe").set_potion(GLOBAL.potions_recipes[GLOBAL.potions.HEALTH])
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
