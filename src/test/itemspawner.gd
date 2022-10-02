extends Node2D

export var item_path:String = ""

var item_to_spawn = null

func _ready():
	item_to_spawn = load(item_to_spawn)

func on_click():
	# return new item to spawn?
	return item_to_spawn

