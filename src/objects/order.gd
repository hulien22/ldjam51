extends "res://src/objects/draggable_rigid.gd"


var potion_order

# Called when the node enters the scene tree for the first time.
func _ready():
#	Want to be above papers
# 	TODO export these values to constants somewhere
	z_index = 0
	collision_mask = 1<<12

func set_potion_order(name: String):
	potion_order = name
