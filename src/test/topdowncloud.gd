extends Node2D

class AddWater:
	func get_type():
		return RECIPEGENERATOR.op.WATER

var add_water_obj:AddWater = AddWater.new()

var bodies_entered:Dictionary = {}

func _on_MouseArea2D_mouse_entered():
	$AnimationPlayer.stop(false)
	$AnimationPlayer.play("CloudTransparent")

func _on_MouseArea2D_mouse_exited():
	$AnimationPlayer.stop(false)
	$AnimationPlayer.play_backwards("CloudTransparent")

func _on_Area2D_body_entered(body):
	if body.has_method("is_empty_bottle") and body.is_empty_bottle():
		var timer = Timer.new()
		add_child(timer)
		timer.connect("timeout", self, "on_timer_complete", [body])
		timer.one_shot = true
		timer.wait_time = 1
		timer.start()
		body.filling_with_water_start()
		bodies_entered[body] = timer

func _on_Area2D_body_exited(body):
	if body.has_method("is_empty_bottle") and body.is_empty_bottle() and bodies_entered.has(body):
		var timer = bodies_entered[body]
		timer.stop()
		timer.queue_free()
		bodies_entered.erase(body)
		body.filling_with_water_stop()

func on_timer_complete(body):
	if body.can_add_item(add_water_obj):
		body.add_item(add_water_obj)
		body.filling_with_water_stop()

export (float) var horizontal_margin = 300.0
export (float) var horizontal_speed = 50.0
export (float) var vertical_speed = 1
export (float) var vertical_oscillation_strength = 0.6

var horizontal_movement_dir = -1
var vertical_oscillation_phase = 0.0

func _process(delta):
	vertical_oscillation_phase += vertical_speed * delta
	vertical_oscillation_phase = fmod(vertical_oscillation_phase, 2*PI)
	position += Vector2(horizontal_speed * horizontal_movement_dir * delta, vertical_oscillation_strength*sin(vertical_oscillation_phase))
	var right_margin = get_viewport().size.x - horizontal_margin
	if position.x <= horizontal_margin or position.x >= right_margin:
		horizontal_movement_dir = -horizontal_movement_dir
		scale.x = -scale.x
#		shadow.scale.x = -shadow.scale.x
#		shadow.position.x = -shadow.position.x
	position.x = clamp(position.x, horizontal_margin, right_margin)
