extends Node2D


var click_all = false
var ignore_unclickable = true
var cur_click_order = 0
var selected_obj

class MyCustomSorter:
	static func sort_ascending(a, b):
		if not a["collider"].has_method("get_click_order"):
			return false
		if not b["collider"].has_method("get_click_order"):
			return true
		if a["collider"].z_index > b["collider"].z_index:
			return true
		if a["collider"].z_index < b["collider"].z_index:
			return false
		if a["collider"].get_click_order() > b["collider"].get_click_order():
			return true
		return false

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == 1: # Left mouse click
		# The last 'true' enables Area2D intersections, previous four values are all defaults
		var shapes = get_world_2d().direct_space_state.intersect_point(get_global_mouse_position(), 32, [], 0x7FFFFFFF, true, true)
		shapes.sort_custom(MyCustomSorter, "sort_ascending")

		for shape in shapes:
			if shape["collider"].has_method("pickup"):
				if shape["collider"].has_method("can_pickup") and shape["collider"].can_pickup():
					cur_click_order += 1
	#				print_debug(cur_click_order)
					shape["collider"].set_click_order(cur_click_order)
					shape["collider"].pickup()
					selected_obj = shape["collider"]

					if !click_all and ignore_unclickable:
						break # Thus clicks only the topmost clickable
				elif shape["collider"].has_method("can_spawn") and shape["collider"].can_spawn():
					# TODO - clean up this logic, shouldn't need parent.. Refactoring click to game.gd should help here
					var new_obj = shape["collider"].get_spawn_obj()
					var instance = new_obj["spawn_obj"]
					instance.global_position = get_global_mouse_position()
					new_obj["parent"].add_child(instance)
					cur_click_order += 1
					instance.set_click_order(cur_click_order)
					instance.pickup()
					selected_obj = instance
					break

			if !click_all and !ignore_unclickable:
				break # Thus stops on the first shape
	elif event is InputEventMouseButton and event.button_index == BUTTON_LEFT and not event.pressed:
		if selected_obj and selected_obj.has_method("drop"):
#			Check for stations
			var shapes = get_world_2d().direct_space_state.intersect_point(get_global_mouse_position(), 32, [], 0x7FFFFFFF, true, true)
			shapes.sort_custom(MyCustomSorter, "sort_ascending")
			print(shapes)
			selected_obj.drop()
			for shape in shapes:
				if shape["collider"].has_method("can_add_item"):
					if shape["collider"].can_add_item(selected_obj):
						shape["collider"].add_item(selected_obj)
						selected_obj.queue_free()
						break
			selected_obj = null

func set_cur_click_order(co):
	cur_click_order = co

func _notification(event):
	match event:
		NOTIFICATION_WM_MOUSE_EXIT:
			if selected_obj and selected_obj.has_method("drop"):
				selected_obj.drop()
				selected_obj = null
