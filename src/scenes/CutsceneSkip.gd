extends Area2D

func _ready():
	Music.unpause_on_scene_transition()

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if $AnimatedSprite.frame >= 4:
			$AnimatedSprite.stop()
			$AnimatedSprite._on_animation_finished()
		else:
			$AnimatedSprite.frame += 1

