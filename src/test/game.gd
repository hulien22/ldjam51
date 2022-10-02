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
	print(RECIPEGENERATOR.op)
	print(RECIPEGENERATOR.random_ops_ingreds(RECIPEGENERATOR.ingredients,RECIPEGENERATOR.operations,3,2))
	print(RECIPEGENERATOR.random_ops_ingreds(RECIPEGENERATOR.ingredients,RECIPEGENERATOR.operations,1,1))
	print(RECIPEGENERATOR.random_ops_ingreds(RECIPEGENERATOR.ingredients,RECIPEGENERATOR.operations,0,0))
	print(RECIPEGENERATOR.random_ops_ingreds(RECIPEGENERATOR.ingredients,RECIPEGENERATOR.operations,6,9))
	print(RECIPEGENERATOR.random_ops_ingreds(RECIPEGENERATOR.ingredients,RECIPEGENERATOR.operations,4,2))
	print(RECIPEGENERATOR.random_ops_ingreds(RECIPEGENERATOR.ingredients,RECIPEGENERATOR.operations,10,10))
	#get_node("Recipe").set_recipe(RECIPEGENERATOR.potions_recipes["HEALTH"])
	#get_node("Recipe").set_potion(GLOBAL.potions_recipes[GLOBAL.potions.HEALTH])
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
