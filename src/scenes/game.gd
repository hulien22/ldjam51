extends Node2D


var click_all = false
var ignore_unclickable = true
var cur_click_order = 0
var selected_obj
var has_obj:bool = false
var potion_recipes
var potions
var rng 

var tips:Array = [
	"Drag bottles under cloud   to fill with water",
	"Drop items into bottles to make potions",   
	"Give both  order and potion to goblin to deliver",
	"Throw unwanted items (like   this!) in the trash",
	"Complete orders before they turn red and expire!",
	"Right click a health potion if injured!"
	]
#	"Drag bottles under cloud   to fill with water", ]
var tips_scene = PRELOADS.tips_scene
var special_recip_scene = PRELOADS.special_recip_scene

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
					has_obj = true

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
					has_obj = true
					break

			if !click_all and !ignore_unclickable:
				break # Thus stops on the first shape
	elif event is InputEventMouseButton and event.button_index == BUTTON_LEFT and not event.pressed:
		if has_obj and selected_obj and selected_obj.has_method("drop"):
#			Check for stations
			var shapes = get_world_2d().direct_space_state.intersect_point(get_global_mouse_position(), 32, [], 0x7FFFFFFF, true, true)
			shapes.sort_custom(MyCustomSorter, "sort_ascending")
#			print(shapes)
			selected_obj.drop()
			for shape in shapes:
				if shape["collider"].has_method("can_add_item"):
					if shape["collider"].can_add_item(selected_obj):
						if shape["collider"].add_item(selected_obj):
							selected_obj.queue_free()
						break
			selected_obj = null
			has_obj = false
	
	if event is InputEventMouseButton and event.pressed and event.button_index == 2: # right mouse click
		# The last 'true' enables Area2D intersections, previous four values are all defaults
		var shapes = get_world_2d().direct_space_state.intersect_point(get_global_mouse_position(), 32, [], 0x7FFFFFFF, true, true)
		shapes.sort_custom(MyCustomSorter, "sort_ascending")

		for shape in shapes:
			if shape["collider"].has_method("drink"):
				if shape["collider"].drink():
					shape["collider"].queue_free()


func set_cur_click_order(co):
	cur_click_order = co

#func _notification(event):
#	match event:
#		NOTIFICATION_WM_MOUSE_EXIT:
#			if selected_obj and selected_obj.has_method("drop"):
#				selected_obj.drop()
#				selected_obj = null



# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	potion_recipes= RECIPEGENERATOR.generate_recipe_template()
	potions = RECIPEGENERATOR.potions.keys()
	garbage_items.append(PRELOADS.ground_eyeball_scene)
	garbage_items.append(PRELOADS.mushroom_scene)
	garbage_items.append(PRELOADS.plant_scene)
	garbage_items.append(PRELOADS.crystal_scene)
	garbage_items.append(PRELOADS.ground_lizard_scene)
#	garbage_items.append(preload("res://src/objects/tip.tscn"))
	
	
#	Summon tips on load
	spawn_tip(1.0)
#	for i in range(tips.size()):
#		var instance = tips_scene.instance()
#		instance.set_text(tips[i])
#		instance.global_position = $RequestSpawner.global_position
#
#		instance.global_position.x += rng.randf_range(-10,10)
#		cur_click_order += 1
#		instance.set_click_order(cur_click_order)
#		instance.rotation_degrees = rng.randi_range(-20,20)
#		add_child_in_x_secs(instance, 1 + i * 0.2)
		
	Music.unpause_on_scene_transition()
	pass # Replace with function body.

var special_count = 0
func _on_RecipeTimer_timeout():
	#ship out new recipe
	#pick random recipe
	if special_count < 3:
		var rnd_potion = special_count + RECIPEGENERATOR.potions.XASIO
		special_count += 1
		var instance = special_recip_scene.instance()
		instance.global_position = $RequestSpawner.global_position
		instance.set_potion(potions[rnd_potion], rnd_potion)
		instance.set_recipe(potion_recipes[rnd_potion])
		instance.angular_velocity = rand_range(-8,8)
		add_child(instance)
		$RecipeSpawner/RecipeTimer.wait_time += 30
		$RecipeSpawner/RecipeTimer.start()

#TODO spawn in special recipes

	pass # Replace with function body.


var current_potion = 0
var time_passed = 0
var time_multiplier = 10.0
var time_to_spawn_next_order1 = 0.0
var time_to_spawn_next_order2 = 20.0
var garbage_items:Array = []
var tip_index = 0

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
		add_child_in_x_secs(recipe_instance, things_spawned * 0.2)
		things_spawned += 1

	if time_passed >= time_to_spawn_next_order1:
		time_to_spawn_next_order1 = time_passed + min(spawn_request(things_spawned * 0.2) * 2.0, 60.0)
		things_spawned += 1
	elif time_passed >= time_to_spawn_next_order2:
		time_to_spawn_next_order2 = time_passed + min(spawn_request(things_spawned * 0.2) * 2.0, 60.0)
		things_spawned += 1
	
	var max_garbage_to_spawn = min(3 - things_spawned, 2)
	var min_garbage_to_spawn = 1 - things_spawned
	var garbage_to_spawn = max(0, rng.randi_range(min_garbage_to_spawn, max_garbage_to_spawn))
	
	for i in range(garbage_to_spawn):
		var garb_instance = garbage_items[rng.randi() % garbage_items.size()].instance()
		garb_instance.angular_velocity = rng.randf_range(-8,8)
		garb_instance.global_position = $RequestSpawner.global_position
		cur_click_order += 1
		garb_instance.set_click_order(cur_click_order)
		add_child_in_x_secs(garb_instance,things_spawned * 0.2)
		things_spawned += 1
	
	spawn_tip(things_spawned*0.2)
	things_spawned += 1
	
#	print("time ", time_passed, " ", time_to_spawn_next_order1, " ", time_to_spawn_next_order2, " ", garbage_to_spawn)

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

func spawn_tip(time):
	if tip_index < tips.size():
		var instance = tips_scene.instance()
		instance.set_text(tips[tip_index])
		tip_index += 1
		instance.global_position = $RequestSpawner.global_position
		instance.global_position.x += rng.randf_range(-10,10)
		cur_click_order += 1
		instance.set_click_order(cur_click_order)
		instance.angular_velocity = rng.randf_range(-8,8)
#		instance.rotation_degrees = rng.randi_range(-20,20)
		add_child_in_x_secs(instance, time)

func add_child_in_x_secs(instance, time):
	if time == 0:
		add_child(instance)
		return
	var timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "on_spawn_timer_complete", [timer, instance])
	timer.one_shot = true
	timer.wait_time = time
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
	Music.pause_on_scene_transition()
	get_tree().change_scene("res://src/scenes/MainMenu.tscn")

func _on_drink_potion(potion:int):
	var timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", self, "process_potion_drink_in_x", [timer, potion])
	timer.one_shot = true
	timer.wait_time = 1.1
	timer.start()
#	print("DRINKING", recipe)
	$DrinkAnimation.show()
	$DrinkAnimation/AnimationPlayer.play("drink potion")

func _on_AnimationPlayer_animation_finished():
	$DrinkAnimation.hide()
	
func process_potion_drink_in_x(timer, potion):
	match potion:
		RECIPEGENERATOR.potions.HEALTH:
			$HealthBar._on_heal()
	timer.queue_free()
	
func _end_player_win():
	Music.pause_on_scene_transition()
	get_tree().change_scene("res://src/scenes/OutroCutscene.tscn")

