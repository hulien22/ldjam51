extends Area2D

var item_to_spawn = null

func _init():
#	preload item_to_spawn here
	pass

#hacky, so that click picks up on us
func pickup():
	pass

func can_spawn():
	return true

func get_spawn_obj():
	var instance = item_to_spawn.instance()
	instance = modify_instance(instance)
	return {"spawn_obj": instance, "parent": get_parent()}

func modify_instance(instance):
	return instance
