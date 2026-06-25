extends Node3D



func _ready():
	if GlobalMusicScript.MusicPlayer: #This checks if it's set and exists
		GlobalMusicScript.MusicPlayer.stream = load("res://Audio/Music/Recovered from Addiction (GDC Casino).mp3")
		GlobalMusicScript.MusicPlayer.play()
	if GlobalMusicScript.AmbiencePlayer: #This checks if it's set and exists
		GlobalMusicScript.AmbiencePlayer.stream = load("res://Audio/Music/Crowd Ambience ｜ 10 Minutes ｜ HQ Stereo Sound_1.mp3")
		GlobalMusicScript.AmbiencePlayer.play()

func _process(delta):
	pass
