extends Node2D

export (Texture) var image
export (int) var health_max
export (int) var horizontal_spacing
export (Vector2) var image_scale

signal on_died

var current_health
var sprites

func _ready():
	sprites = []
	current_health = health_max
	for i in range(0, health_max):
		var sprite = Sprite.new()
		sprite.texture = image
		sprite.position.x = i*horizontal_spacing
		sprite.scale = image_scale
		sprites.append(sprite)
		add_child(sprite)

func _on_take_damage():
	current_health-=1
	sprites[current_health].visible = false
	if current_health == 0:
		emit_signal("on_died")
	
func _on_heal():
	if current_health == health_max:
		return
	sprites[current_health].visible = true
	current_health+=1
