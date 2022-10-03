extends "res://src/objects/station.gd"

var ground_mushroom_scene = preload("res://src/ingredients/GroundMushroom.tscn")
var ground_crystal_scene = preload("res://src/ingredients/GroundCrystal.tscn")
var ground_lizard_scene = preload("res://src/ingredients/GroundLizard.tscn")
var ground_plant_scene = preload("res://src/ingredients/GroundPlant.tscn")
var ground_eyeball_scene = preload("res://src/ingredients/GroundEyeball.tscn")

var ground_scenes = [ground_plant_scene, ground_lizard_scene,
ground_crystal_scene, ground_eyeball_scene, ground_mushroom_scene]

# Called when the node enters the scene tree for the first time.
func _ready():
	mode = RigidBody2D.MODE_STATIC
	regular_mode = RigidBody2D.MODE_STATIC
	movement_mode = RigidBody2D.MODE_RIGID
	movement_multiplier = 0.5
	allow_rotation = false

func can_add_item(new_item):
	if has_item or not new_item.has_method("get_type"):
		return false
	match new_item.get_type():
		RECIPEGENERATOR.op.EYEBALL: return true
		RECIPEGENERATOR.op.CRYSTAL: return true
		RECIPEGENERATOR.op.PLANT: return true
		RECIPEGENERATOR.op.MUSHROOM: return true
		RECIPEGENERATOR.op.LIZARD: return true
		_: return false

func add_item(new_item):
	item = new_item.get_type()
	has_item = true
	# Set the sprite sheet to the correct frame.
	# The order is based off the RECIPEGENERATOR.op enum
	$Mortar/IngredientSprite.frame = new_item.get_type()-9
	start_wait($Timer)
	return true

func process_item():
	# The ground version is 10 ahead in the enum
	item += 10
	# The ground version is 10 frames ahead
	$Mortar/IngredientSprite.frame += 10
	complete = true

func get_spawn_obj():
	# The index in ground_scenes is the RECIPEGENERATOR.op enum value - 20
	var instance = ground_scenes[item-20].instance()
	item = null
	has_item = false
	complete = false
	$Mortar/IngredientSprite.frame = 0
	return {"spawn_obj": instance, "parent": get_parent()}

func animate_obj_start():
	$Mortar/Particles2D.emitting = true
	$Mortar/Pestle/Particles2D.emitting = true
	$Mortar/AnimationPlayer.play("Pestle")

func animate_obj_stop():
	$Mortar/Particles2D.emitting = false
	$Mortar/Pestle/Particles2D.emitting = false
	$Mortar/AnimationPlayer.stop(true)

