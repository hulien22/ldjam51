extends "res://src/test/draggable_rigid.gd"

# Called when the node enters the scene tree for the first time.
func _ready():
#	Want to be above papers
# 	TODO export these values to constants somewhere
	z_index = 1
	regular_collision_layer = 3
	movement_collision_layer = 4096

func _init():
	rescale_factor = 0.3

func get_type():
	return RECIPEGENERATOR.op.GROUND_MUSHROOM
