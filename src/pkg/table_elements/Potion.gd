extends Object

class_name Potion

# the sequence of operations that created the Potion
var operation_sequence = Array()

func _init():
	operation_sequence = [Operation.new()]

# Add a new operation to the Potion
# Do not allow Water to be added
# Do not allow the same Operation to be added twice in a row
func addOperation(operation):
	if operation != Operation.Op.WATER and \
	   operation != operation_sequence[-1]:
		operation_sequence.append(operation)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
