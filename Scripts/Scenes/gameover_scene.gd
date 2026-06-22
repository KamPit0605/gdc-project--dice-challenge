extends Node3D


func _ready():
	if GlobalMusicScript.MusicPlayer: #This checks if it's set and exists
		GlobalMusicScript.MusicPlayer.stop()


func _process(delta):
	pass
