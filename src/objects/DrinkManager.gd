extends Node

signal on_heal
signal on_damage


var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_drink():
#	print("here")
	var r = rng.randi_range(0, 1)
	if r == 0:
		emit_signal("on_heal")
	elif r == 1:
		emit_signal("on_damage")
		
#testing
#var del = 0
#var dir = false
#func _process(delta):
#	del += delta
#	if del > 6:
#		del = 0
#		_on_drink()
