extends AudioStreamPlayer

export (Array, AudioStream) var songs

var cycle_songs
var cycle_position

func _ready():
	cycle_position = 0
	cycle_songs = true
	stream = songs[cycle_position]
	play()

func _on_finished():
	if cycle_songs:
		cycle_position += 1
		cycle_position %= songs.size()
		stream = songs[cycle_position]
	play()
