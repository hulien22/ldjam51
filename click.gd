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
				cur_click_order += 1
#				print_debug(cur_click_order)
				shape["collider"].set_click_order(cur_click_order)
				shape["collider"].pickup()
				selected_obj = shape["collider"]

				if !click_all and ignore_unclickable:
					break # Thus clicks only the topmost clickable

			if !click_all and !ignore_unclickable:
				break # Thus stops on the first shape
	elif event is InputEventMouseButton and event.button_index == BUTTON_LEFT and not event.pressed:
		if selected_obj and selected_obj.has_method("drop"):
			selected_obj.drop()
			selected_obj = null

func set_cur_click_order(co):
	cur_click_order = co

func _notification(event):
	match event:
		NOTIFICATION_WM_MOUSE_EXIT:
			if selected_obj and selected_obj.has_method("drop"):
				selected_obj.drop()
				selected_obj = null
