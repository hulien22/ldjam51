extends Area2D

var item_to_spawn = preload("res://src/scene/recipe.tscn")

func _init():
#	preload item_to_spawn here
	pass

func can_spawn():
	return true

func get_spawn_obj():
	var instance = item_to_spawn.instance()
	instance = modify_instance(instance)
	return {"spawn_obj": instance, "parent": get_parent()}

func modify_instance(instance):
	return instance
