extends "res://src/objects/station.gd"

signal wrong_delivery
signal correct_delivery

var has_two_items
var second_item
# Called when the node enters the scene tree for the first time.
func _ready():
	$DestroyTimer.connect("timeout", self, "on_items_delivered")
	$DestroyTimer.set_wait_time(2)
	$DestroyTimer.one_shot = true
	has_two_items = false
	mode = RigidBody2D.MODE_STATIC
	regular_mode = RigidBody2D.MODE_STATIC
	movement_mode = RigidBody2D.MODE_RIGID
	movement_multiplier = 0.0
	allow_rotation = false

func can_add_item(new_item):
	print("my" + str(new_item))
	if has_two_items or not new_item.has_method("get_type"):
		return false
	if has_item:
		if item.get_type() == RECIPEGENERATOR.op.REQUEST:
			match new_item.get_type():
				RECIPEGENERATOR.op.POTION: return true
				_: return false
		elif item.get_type() == RECIPEGENERATOR.op.POTION:
			match new_item.get_type():
				RECIPEGENERATOR.op.REQUEST: return true
				_: return false
	else:
		match new_item.get_type():
			RECIPEGENERATOR.op.REQUEST: return true
			RECIPEGENERATOR.op.POTION: return true
			_: return false
	

func add_item(new_item):
	if has_item:
		has_two_items = true
		second_item = new_item
		disable_item(new_item, $Node2D/RightHand)
		$DestroyTimer.connect("timeout", new_item, "queue_free")
		$DestroyTimer.connect("timeout", item, "queue_free")
		$DestroyTimer.start()
		start_wait($Timer)
	else:
		item = new_item
		has_item = true
		disable_item(new_item, $Node2D/LeftHand)
	return false

func disable_item(new_item, new_parent):
	new_item.get_parent().remove_child(new_item)
	new_parent.add_child(new_item)
	new_item.position = Vector2(0,0)
	new_item.movement_mode = MODE_STATIC
	new_item.regular_mode = MODE_STATIC
	new_item.get_node("Collider").disabled = true
	
func enable_item():
	item.get_parent().remove_child(item)
	item.movement_mode = MODE_RIGID
	item.regular_mode = MODE_RIGID
	item.get_node("Collider").disabled = false

func process_item():
	item = null
	second_item = null
	has_item = false
	has_two_items = false

func on_items_delivered():
	print(str(item) + " " + str(second_item)) 
	var ops
	var potion
	if item.get_type() == RECIPEGENERATOR.op.REQUEST:
		ops = RECIPEGENERATOR.potions_recipes[RECIPEGENERATOR.potions[item.potion_request]]
		potion = second_item.current_recipe
	else:
		ops = RECIPEGENERATOR.potions_recipes[RECIPEGENERATOR.potions[second_item.potion_request]]
		potion = item.current_recipe
	print(ops) 
	print(potion)
	if ops.size() == potion.size():
		for i in range(ops.size()):
			if ops[i] != potion[i]:
				print("wrong")
				emit_signal("wrong_delivery")
				return
	else:
		print("wrong")
		emit_signal("wrong_delivery")
		return
	print("correct")
	emit_signal("correct_delivery")

func get_spawn_obj():
	enable_item()
	var instance = item
	item = null
	has_item = false
	complete = false
	return {"spawn_obj": instance, "parent": get_parent()}

func animate_obj_start():
	$Node2D/Delivery/AnimationPlayer.play("Pestle")

func animate_obj_stop():
	$Node2D/Delivery/AnimationPlayer.stop(true)

func can_pickup():
	return false

func can_spawn():
	return has_item and not has_two_items
