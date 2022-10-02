extends Area2D

var item_to_spawn = null
export(String) var scene_path_to_spawn:String = ""

func _ready():
	item_to_spawn = load(scene_path_to_spawn)

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
