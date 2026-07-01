extends Node
#Global Script
var MusicPlayer: AudioStreamPlayer = null
var AmbiencePlayer: AudioStreamPlayer = null
var Pitch: float = 1.0
var VolumeDB: float = 0.0

func _ready():
	MusicPlayer = AudioStreamPlayer.new()
	MusicPlayer.stream = load("res://Audio/Music/Recovered from Addiction (GDC Casino).mp3")
	MusicPlayer.autoplay = true
	MusicPlayer.set_bus('Music')
	#Adjustments()
	add_child(MusicPlayer) #maintains music by adding this node to scenes

	AmbiencePlayer = AudioStreamPlayer.new()
	AmbiencePlayer.stream = load("res://Audio/Music/Crowd Ambience ｜ 10 Minutes ｜ HQ Stereo Sound_1.mp3")
	AmbiencePlayer.autoplay = true
	AmbiencePlayer.set_bus('Music')
	#Adjustments()
	AmbiencePlayer.volume_db = -8.0
	add_child(AmbiencePlayer)


func _process(delta):
	Adjustments()
	
	if MusicPlayer:
		Looping()
		
		#vvv Critical Rolling changes music "pitch" vvv
		if GlobalUi.CriticalRoleRate == 1:
			Dynamics(1.5)
		elif GlobalUi.CriticalRoleRate == 2:
			Dynamics(0.5)
		else:
			Dynamics(1)

func Looping():
	if MusicPlayer.get_playback_position() >= 169.08: #168.46 for web build (HTML)
			MusicPlayer.play(15.5)


func Adjustments():
	MusicPlayer.pitch_scale = Pitch
	MusicPlayer.volume_db = VolumeDB

func Dynamics(PitchChange):
	MusicPlayer.pitch_scale = PitchChange
