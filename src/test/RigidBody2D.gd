extends RigidBody2D

var click_order = 0

func on_click():
	self.get_parent().on_click()

func get_click_order():
	return click_order

func set_click_order(co):
	click_order = co
