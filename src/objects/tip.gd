extends DraggableBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
#	Want to be above papers
# 	TODO export these values to constants somewhere
	z_index = 0
	collision_mask = 1<<12

func set_text(t:String):
	$Sprite2/Node2D/Label.text = "TIP:"
	$Sprite2/Node2D/Steps2.text = t

func get_type():
	return -1

func can_delete():
	return true
