extends CheckButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pressed = !Music.stream_paused

func _on_toggled(button_pressed):
	Music.stream_paused = !button_pressed
