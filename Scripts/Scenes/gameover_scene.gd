extends Node3D
@onready var AudioStreaming = $AudioStreamPlayer
var soundsPlayed: int

func _ready():
	if GlobalMusicScript.MusicPlayer: #This checks if it's set and exists
		GlobalMusicScript.MusicPlayer.stop()
	if GlobalMusicScript.AmbiencePlayer: #This checks if it's set and exists
		GlobalMusicScript.AmbiencePlayer.stop()
	#_AudioPlaying("res://Audio/SFX/WWE/WWE Royal Rumble Buzzer (2003 - Present).mp3")


func _process(delta):
	pass

func _AudioPlaying(SFX):
	AudioStreaming.stream = load(SFX)
	AudioStreaming.play()


func _on_audio_stream_player_finished():
	soundsPlayed += 1
	if soundsPlayed == 1:
		AudioStreaming.volume_db = -8.0
		_AudioPlaying("res://Audio/SFX/MB/018. Blocks2.mp3")
