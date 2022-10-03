extends DraggableBody2D

const PLAY_TOP_LEFT  = Vector2(-20,-44)
const PLAY_BOT_RIGHT = Vector2(32,-6)
const BACK_TOP_LEFT  = Vector2(-92,-44)
const BACK_BOT_RIGHT = Vector2(-70,-6)
const PAUS_TOP_LEFT  = Vector2(-68,-44)
const PAUS_BOT_RIGHT = Vector2(-47,-6)
const NEXT_TOP_LEFT  = Vector2(-44,-44)
const NEXT_BOT_RIGHT = Vector2(-23,-6)

func on_first_held():
	var local_m_p = get_local_mouse_position()
	if is_point_in_rect(PLAY_TOP_LEFT, PLAY_BOT_RIGHT, local_m_p):
		Music.stream_paused = false
		if not $AnimatedSprite.playing:
			$AnimatedSprite.play()
			$AnimatedSprite/Particles2D.emitting = true
	elif is_point_in_rect(PAUS_TOP_LEFT, PAUS_BOT_RIGHT, local_m_p):
		Music.stream_paused = true
		if $AnimatedSprite.playing:
			$AnimatedSprite.stop()
			$AnimatedSprite/Particles2D.emitting = false
	elif is_point_in_rect(BACK_TOP_LEFT, BACK_BOT_RIGHT, local_m_p):
#		numbers are off by one, since changing songs will finish a song, and that will increment the track too
		Music.change_track(-2)
	elif is_point_in_rect(NEXT_TOP_LEFT, NEXT_BOT_RIGHT, local_m_p):
		Music.change_track(0)
	.on_first_held()
	
func is_point_in_rect(top_left:Vector2, bottom_right:Vector2, point:Vector2) -> bool:
	return point.x >= top_left.x and point.x <= bottom_right.x and point.y >= top_left.y and point.y <= bottom_right.y

func _physics_process(delta):
	._physics_process(delta)
	$AnimatedSprite/Particles2D.rotation = -rotation

func can_delete():
	return false

