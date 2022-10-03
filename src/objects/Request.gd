extends "res://src/objects/draggable_rigid.gd"

var potion_request: String =""

func _init(request: String =""):
	potion_request = request
#	current_recipe.push_back(RECIPEGENERATOR.op.WATER)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func get_type():
	return RECIPEGENERATOR.op.REQUEST
	
func get_potion_request():
	return potion_request

func set_potion_request(potion):
	potion_request=potion
