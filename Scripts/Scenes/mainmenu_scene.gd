extends Node3D



func _ready():
	if GlobalMusicScript.MusicPlayer: #This checks if it's set and exists
		GlobalMusicScript.MusicPlayer.stream = load("res://Audio/Music/Recovered from Addiction (GDC Casino).mp3")
		GlobalMusicScript.MusicPlayer.play()

func _process(delta):
	pass
