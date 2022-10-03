extends Node2D

export (Color) var color
export (String) var text

signal on_animation_finished

func _ready():
	$Polygon2D.color = color
	$RichTextLabel.text = text

func _on_fade_out():
	print("FADING")
	$AnimationPlayer.play("Fade")
	
func _on_fade_in():
	$AnimationPlayer.play_backwards("Fade")

func _on_animation_finished(anim_name):
	emit_signal("on_animation_finished")
