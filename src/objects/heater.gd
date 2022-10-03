extends Station

var potion_recipe = []
var potion_scene = preload("res://src/objects/Potion.tscn")

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
	update_potion()
	$Sprites/WithPotion/SmokeParticles.emitting = true
	$Sprites/WithPotion/SmokeParticles.restart()
	start_wait($Timer)

func get_spawn_obj():
	$Sprites/Empty.visible = true
	$Sprites/WithPotion.visible = false
	var instance = potion_scene.instance()
	instance.init(potion_recipe)
	item = null
	has_item = false
	$Timer.stop()
	return {"spawn_obj": instance, "parent": get_parent()}

func update_potion():
	$Sprites/WithPotion/PotionWhiteVersion.modulate = Color(0,0,0,0)

func animate_obj_start():
	pass

func animate_obj_stop():
	pass

