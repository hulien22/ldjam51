extends DraggableBody2D

class_name Station
# Stations are where we can drop off items and they will process them in a given amount of time

export var process_time:float = 2.0 # TODO should this be dependent on item?

var item = null
var has_item = false
var complete = false

func add_item(new_item):
	return false
	
func can_add_item(new_item):
	pass

func process_item():
	pass

func is_complete():
	if not has_item:
		return false
	return complete

func start_wait(timer):
	timer.set_wait_time(process_time)
	timer.one_shot = true
	timer.start()
	animate_obj_start()

func can_pickup():
	return not has_item

func can_spawn():
	return is_complete()

# return object to spawn and reset
func get_spawn_obj():
	return {}

func animate_obj_start():
	pass

func animate_obj_stop():
	pass

func _on_Timer_timeout():
	animate_obj_stop()
	process_item()
