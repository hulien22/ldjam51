extends Node2D


var item_to_spawn = null
export(String) var scene_path_to_spawn:String = ""

func _ready():
	item_to_spawn = load(scene_path_to_spawn)

func spawn_obj():
	var instance = item_to_spawn.instance()
	instance.global_position = global_position
	#z_index
	return instance

