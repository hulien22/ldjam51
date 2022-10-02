extends "res://src/test/station.gd"

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

func animate_obj_start():
	$Mortar/AnimationPlayer.play("Pestle")

func animate_obj_stop():
	$Mortar/AnimationPlayer.stop(true)

