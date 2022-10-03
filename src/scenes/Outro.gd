extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func _ready():
	frame = 0
	Music.unpause_on_scene_transition()


# Called when the node enters the scene tree for the first time.

func _on_animation_finished():
	Music.pause_on_scene_transition()
	get_tree().change_scene("res://src/scenes/MainMenu.tscn")
	

func _on_start_outro():
	playing = true
