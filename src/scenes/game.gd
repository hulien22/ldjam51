extends Node2D


var click_all = false
var ignore_unclickable = true
var cur_click_order = 0
var selected_obj
var potion_recipes
var potions
var rng 

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
						if shape["collider"].add_item(selected_obj):
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



# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	potion_recipes= RECIPEGENERATOR.generate_recipe_template()
	potions = RECIPEGENERATOR.potions.keys()
	garbage_items.append(preload("res://src/ingredients/GroundEyeball.tscn"))
	garbage_items.append(preload("res://src/ingredients/Mushroom.tscn"))
	garbage_items.append(preload("res://src/ingredients/Plant.tscn"))
	pass # Replace with function body.


func _on_RecipeTimer_timeout():
	#ship out new recipe
	#pick random recipe
#	var rnd_potion = rng.randi() % potions.size()
#
#	var instance = get_node("RecipeSpawner").spawn_obj()
#	instance.set_potion(potions[rnd_potion], rnd_potion)
#	instance.set_recipe(potion_recipes[rnd_potion])
#	instance.angular_velocity = rand_range(-8,8)
#	add_child(instance)

#TODO spawn in special recipes

	pass # Replace with function body.


var current_potion = 0
var time_passed = 0
var time_multiplier = 1.0
var time_to_spawn_next_order1 = 0.0
var time_to_spawn_next_order2 = 20.0
var garbage_items:Array = []

func _on_RequestTimer_timeout():
	time_passed += 10
	var things_spawned = 0
	var max_pot = RECIPEGENERATOR.get_max_potion_for_time(time_passed)
	if max_pot > current_potion:
		current_potion = max_pot
		var recipe_instance = get_node("RecipeSpawner").spawn_obj()
		recipe_instance.set_potion(potions[current_potion - 1], current_potion - 1)
		recipe_instance.set_recipe(potion_recipes[current_potion - 1])
		recipe_instance.angular_velocity = rng.randf_range(-8,8)
		recipe_instance.global_position = $RequestSpawner.global_position
		cur_click_order += 1
		recipe_instance.set_click_order(cur_click_order)
		add_child_in_x_secs(recipe_instance, things_spawned)
		things_spawned += 1

	if time_passed >= time_to_spawn_next_order1:
		time_to_spawn_next_order1 = time_passed + min(spawn_request(things_spawned) * 2.0, 60.0)
		things_spawned += 1
	elif time_passed >= time_to_spawn_next_order2:
		time_to_spawn_next_order2 = time_passed + min(spawn_request(things_spawned) * 2.0, 60.0)
		things_spawned += 1
	
	var max_garbage_to_spawn = 3 - things_spawned
	var min_garbage_to_spawn = 1 - things_spawned
	var garbage_to_spawn = max(0, rng.randi_range(min_garbage_to_spawn, max_garbage_to_spawn))
	
	for i in range(garbage_to_spawn):
		var garb_instance = garbage_items[rng.randi() % garbage_items.size()].instance()
		garb_instance.angular_velocity = rng.randf_range(-8,8)
		garb_instance.global_position = $RequestSpawner.global_position
		cur_click_order += 1
		garb_instance.set_click_order(cur_click_order)
		add_child_in_x_secs(garb_instance,things_spawned)
		things_spawned += 1
		
	
	print("time ", time_passed, " ", time_to_spawn_next_order1, " ", time_to_spawn_next_order2, " ", garbage_to_spawn)

	pass # Replace with function body.

func spawn_request(spawn_delay):
	var rnd_potion = rng.randi() % current_potion  #potions.size()
#	var max_pot = RECIPEGENERATOR.get_max_potion_for_time(time_passed)
#	if max_pot > current_potion:
#		current_potion = max_pot
#		rnd_potion = max_pot - 1
#		var recipe_instance = get_node("RecipeSpawner").spawn_obj()
#		recipe_instance.set_potion(potions[rnd_potion], rnd_potion)
#		recipe_instance.set_recipe(potion_recipes[rnd_potion])
#		recipe_instance.angular_velocity = rng.randf_range(-8,8)
#		cur_click_order += 1
#		recipe_instance.set_click_order(cur_click_order)
#		add_child(recipe_instance)
#	else:
#		rnd_potion = rng.randi() % max_pot  #potions.size()
	var instance = get_node("RequestSpawner").spawn_obj()
	instance.set_potion_request(potions[rnd_potion])
	instance.set_time(RECIPEGENERATOR.get_recipe_time(rnd_potion) * time_multiplier)
	instance.angular_velocity = rng.randf_range(-8,8)
	cur_click_order += 1
	instance.set_click_order(cur_click_order)
	add_child_in_x_secs(instance, spawn_delay)
	return RECIPEGENERATOR.get_recipe_time(rnd_potion)

func add_child_in_x_secs(instance, time):
	if time == 0:
		add_child(instance)
		return
	var timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "on_spawn_timer_complete", [timer, instance])
	timer.one_shot = true
	timer.wait_time = time * 0.2
	timer.start()

func on_spawn_timer_complete(timer, instance):
	timer.queue_free()
	add_child(instance)

func _start_player_dead():
	var timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "_end_player_dead")
	timer.one_shot = true
	timer.wait_time = 3
	timer.start()

func _end_player_dead():
	get_tree().change_scene("res://src/scenes/MainMenu.tscn")
