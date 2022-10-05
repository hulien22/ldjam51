extends Area2D

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		$AnimatedSprite.frame += 1
		if $AnimatedSprite.frame >= 5:
			$AnimatedSprite.speed_scale = 100
