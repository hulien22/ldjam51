extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var animation = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _on_options():
	animation.play("GotoOptions")
	
func _on_back():
	animation.play_backwards("GotoOptions")

func _on_start():
	get_tree().change_scene("res://src/scenes/IntroCutscene.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
