extends Station

var potion_scene = preload("res://src/objects/Potion.tscn")

var potion_recipe = []
var time_on_heat: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	mode = RigidBody2D.MODE_STATIC
	regular_mode = RigidBody2D.MODE_STATIC
	movement_mode = RigidBody2D.MODE_RIGID
	movement_multiplier = 0.5
	allow_rotation = false
	$Sprites/Empty.visible = true
	$Sprites/WithPotion.visible = false
	# can always grab from this if have an item
	complete = true
	$Sprites/WithPotion/PotionWhiteVersion.modulate = Color(0,0,0,0)
	process_time = 1


func can_add_item(new_item):
	if has_item or not new_item.has_method("get_type"):
		return false
	match new_item.get_type():
		RECIPEGENERATOR.op.WATER_BOTTLE: return true
		RECIPEGENERATOR.op.POTION: return true
		_: return false

func add_item(new_item):
	item = new_item.get_type()
	potion_recipe = new_item.get_current_recipe()
	time_on_heat = new_item.get_time_on_heat()
	# TODO check if heat time is on potion and if last op is a heating op
	# else reset heat time to 0
	
	has_item = true
	# Set the sprite sheet to the correct frame.
	# The order is based off the RECIPEGENERATOR.op enum
	update_potion()
	$Sprites/Empty.visible = false
	$Sprites/WithPotion.visible = true
	start_wait($Timer)

func process_item():
#	increase heat time
	time_on_heat += 1
	print(time_on_heat)
	var did_update = false
	if time_on_heat >= RECIPEGENERATOR.HEAT_LONG_LENGTH:
		did_update = update_recipe(RECIPEGENERATOR.op.HEAT_LONG)
	elif time_on_heat >= RECIPEGENERATOR.HEAT_MED_LENGTH:
		did_update = update_recipe(RECIPEGENERATOR.op.HEAT_MED)
	elif time_on_heat >= RECIPEGENERATOR.HEAT_SHORT_LENGTH:
		did_update = update_recipe(RECIPEGENERATOR.op.HEAT_SHORT)
	update_potion()
	if (did_update):
		$Sprites/WithPotion/SmokeParticles.emitting = true
		$Sprites/WithPotion/SmokeParticles.restart()
		$Sprites/WithPotion/SmokeParticles2.emitting = true
		$Sprites/WithPotion/SmokeParticles2.restart()
	else:
		$Sprites/WithPotion/SmokeParticles.emitting = true
		$Sprites/WithPotion/SmokeParticles.restart()
	start_wait($Timer)

func update_recipe(new_op):
	if (RECIPEGENERATOR.is_heat_op(potion_recipe.back())):
		if potion_recipe.back() == new_op:
			return false
		potion_recipe.pop_back()
		potion_recipe.push_back(new_op)
	else:
		potion_recipe.push_back(new_op)
	return true

func get_spawn_obj():
	var instance = potion_scene.instance()
	instance.init(potion_recipe)
	instance.set_time_on_heat(time_on_heat)
	item = null
	has_item = false
	$Timer.stop()
	$Sprites/WithPotion/SmokeParticles.restart()
	$Sprites/WithPotion/SmokeParticles.emitting = false
	$Sprites/WithPotion/SmokeParticles2.restart()
	$Sprites/WithPotion/SmokeParticles2.emitting = false
	$Sprites/Empty.visible = true
	$Sprites/WithPotion.visible = false
	return {"spawn_obj": instance, "parent": get_parent()}

func update_potion():
	$Sprites/WithPotion/PotionWhiteVersion.modulate = Color(RECIPEGENERATOR.get_color_from_recipe(potion_recipe))

func animate_obj_start():
	pass

func animate_obj_stop():
	pass

