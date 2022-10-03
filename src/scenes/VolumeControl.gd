extends HSlider

export var bus_name = "Master"

onready var bus = AudioServer.get_bus_index(bus_name)

func _ready():
	value = db2linear(AudioServer.get_bus_volume_db(bus))

func _on_value_changed(value):
	AudioServer.set_bus_volume_db(bus, linear2db(value))
