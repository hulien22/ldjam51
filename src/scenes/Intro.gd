extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func _ready():
	frame = 0


# Called when the node enters the scene tree for the first time.

func _on_animation_finished():
	Music.pause_on_scene_transition()
	get_tree().change_scene("res://src/scenes/game.tscn")

func _on_start_intro():
	playing = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
