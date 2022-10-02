extends "res://src/test/draggable_rigid.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
#	Want to be above papers
# 	TODO export these values to constants somewhere
	z_index = 1

func get_type():
	return RECIPEGENERATOR.op.MUSHROOM
