extends Object

class_name Operation

enum Op {WATER, HEAT, COOL, SHAKE,
 LEAF, HERB, THISTLE, FLOWER, MUSHROOM,
 GROUND_LEAF, GROUND_HERB, GROUND_THISTLE, GROUND_FLOWER, GROUND_MUSHROOM}

var op_id
var is_ground: bool

func _init(defaultOperation = Op.WATER):
	op_id = defaultOperation
	is_ground = false

func isGround():
	return op_id == Op.GROUND_LEAF or \
		   op_id == Op.GROUND_HERB or \
		   op_id == Op.GROUND_THISTLE or \
		   op_id == Op.GROUND_FLOWER or \
		   op_id == Op.GROUND_MUSHROOM

func grind():
	if op_id == Op.LEAF:
		op_id = Op.GROUND_LEAF
	elif op_id == Op.HERB:
		op_id = Op.GROUND_HERB
	elif op_id == Op.THISTLE:
		op_id = Op.GROUND_THISTLE
	elif op_id == Op.FLOWER:
		op_id = Op.GROUND_FLOWER
	elif op_id == Op.MUSHROOM:
		op_id = Op.GROUND_MUSHROOM

