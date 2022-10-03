extends DraggableBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
#	Want to be above papers
# 	TODO export these values to constants somewhere
	z_index = 0
	collision_mask = 1<<12

func set_text(t:String):
	$Node2D/Steps2.text = t

func can_delete():
	return true
