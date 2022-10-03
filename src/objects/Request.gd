extends "res://src/objects/draggable_rigid.gd"

var potion_request: String =""
var time = 20.0
var time_remain=0
var color 

signal request_expired

func _init(request: String =""):
	potion_request = request
#	current_recipe.push_back(RECIPEGENERATOR.op.WATER)

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("request_expired", get_parent().get_node("HealthBar"), "_on_take_damage")
	$Area2D/FailLabel.visible=false
	$Area2D/TextTimer.wait_time = time 
	$Area2D/TextTimer.one_shot = true
	$Area2D/TextTimer.start()
	z_index = 0
	time_remain = time
	collision_mask = 1<<12
	
func _process(delta):
	time_remain = $Area2D/TextTimer.time_left
	color = $Sprite.modulate
	$Sprite.modulate = Color(1,time_remain/time,time_remain/time)

func get_type():
	return RECIPEGENERATOR.op.REQUEST
	
func get_potion_request():
	return potion_request

func set_potion_request(potion):
	potion_request=potion
	$Area2D/Label.text = "1 " + potion_request + " POTION"

func set_time(t:float):
	time = t

func can_delete():
	return time_remain == 0

func _on_TextTimer_timeout():
	$Area2D/FailLabel.visible=true
	$Area2D/TextTimer.stop()
	$Area2D/SmokeParticles2.emitting = true
	emit_signal("request_expired")

func pause_text_timer():
	$Area2D/TextTimer.set_paused(true)
	
func unpause_text_timer():
	$Area2D/TextTimer.set_paused(false)
