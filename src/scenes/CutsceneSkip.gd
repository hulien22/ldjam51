extends Area2D

func _input_event(viewport, event, shape_idx):
	print("here")
	if event is InputEventMouseButton and event.pressed:
		$AnimatedSprite.frame += 1
