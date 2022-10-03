extends TextureButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_enter_hover():
	set_scale(Vector2(1.1, 1.1))

func _on_exit_hover():
	set_scale(Vector2(1.0, 1.0))
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
