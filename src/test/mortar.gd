extends "res://src/test/station.gd"

var ground_mushroom_scene = preload("res://src/test/GroundMushroom.tscn")

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
		RECIPEGENERATOR.op.FLOWER: return true
		RECIPEGENERATOR.op.THISTLE: return true
		RECIPEGENERATOR.op.LEAF: return true
		RECIPEGENERATOR.op.MUSHROOM: return true
		RECIPEGENERATOR.op.HERB: return true
		_: return false

func add_item(new_item):
	item = new_item.get_type()
	has_item = true
	match new_item.get_type():
		RECIPEGENERATOR.op.FLOWER:pass
		RECIPEGENERATOR.op.THISTLE: pass
		RECIPEGENERATOR.op.LEAF: pass
		RECIPEGENERATOR.op.MUSHROOM: 
			$Mortar/IngredientSprite.frame = 1
		RECIPEGENERATOR.op.HERB: pass
		_: pass
	start_wait($Timer)

func process_item():
	match item:
		RECIPEGENERATOR.op.FLOWER:pass
		RECIPEGENERATOR.op.THISTLE: pass
		RECIPEGENERATOR.op.LEAF: pass
		RECIPEGENERATOR.op.MUSHROOM: 
			item = RECIPEGENERATOR.op.GROUND_MUSHROOM
		RECIPEGENERATOR.op.HERB: pass
		_: pass
	$Mortar/IngredientSprite.frame += 1
	complete = true

func get_spawn_obj():
	var instance
	match item:
		RECIPEGENERATOR.op.GROUND_FLOWER:pass
		RECIPEGENERATOR.op.GROUND_THISTLE: pass
		RECIPEGENERATOR.op.GROUND_LEAF: pass
		RECIPEGENERATOR.op.GROUND_MUSHROOM: 
			instance = ground_mushroom_scene.instance()
		RECIPEGENERATOR.op.GROUND_HERB: pass
	item = null
	has_item = false
	$Mortar/IngredientSprite.frame = 0
	return {"spawn_obj": instance, "parent": get_parent()}

func animate_obj_start():
	$Mortar/Particles2D.emitting = true
	$Mortar/AnimationPlayer.play("Pestle")

func animate_obj_stop():
	$Mortar/Particles2D.emitting = false
	$Mortar/AnimationPlayer.stop(true)

