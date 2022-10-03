extends AudioStreamPlayer

export (Array, AudioStream) var songs

var cycle_songs
var cycle_position

func _ready():
	cycle_position = 0
	cycle_songs = true
	stream = songs[cycle_position]
	play()

func change_track(inc_cycle_posn = 1):
	if cycle_songs:
		cycle_position += inc_cycle_posn
		cycle_position %= songs.size()
		stream = songs[cycle_position]

func _on_finished():
	change_track()
	play()

var was_playing = true
func pause_on_scene_transition():
	was_playing = !Music.stream_paused
	Music.stream_paused = true
	print("MUSIC PAUSE")

func unpause_on_scene_transition():
	if was_playing:
		Music.stream_paused = false
		print("MUSIC UNPAUSE")
