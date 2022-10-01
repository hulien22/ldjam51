extends "res://src/test/draggable_rigid.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var liquid_color:Color = Color8(0,0,0,0)


# Called when the node enters the scene tree for the first time.
func _ready():
	$PotionFilling.modulate = liquid_color


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
