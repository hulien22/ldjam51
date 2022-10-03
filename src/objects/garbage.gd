extends "res://src/objects/station.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	mode = RigidBody2D.MODE_STATIC
	regular_mode = RigidBody2D.MODE_STATIC
	movement_mode = RigidBody2D.MODE_RIGID
	movement_multiplier = 0.0
	allow_rotation = false

func can_add_item(new_item):
	if new_item.get_class() == "Mortar" or new_item.get_class() == "Heater":
		return false
	return true

func add_item(new_item):
	start_wait($Timer)
	return true

func process_item():
	complete = true

func get_spawn_obj():
	return null

func animate_obj_start():
	$Garbage/Particles2D.emitting = true

func animate_obj_stop():
	$Garbage/Particles2D.emitting = false

