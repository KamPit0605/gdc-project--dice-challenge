extends Control



@export var PlayButton: Button
@export var CreditsButton: Button
@export var QuitButton: Button
@export var game_scene = "res://Scenes/game_scene.tscn"
#var mainMenu_scene
#var ConnectButtons: bool = false

#--settings--
@onready var VibrateOnText = $Settings/Vibration/OnText
@onready var VibrateOffText = $Settings/Vibration/OffText

@onready var AudioBus_Music = AudioServer.get_bus_index("Music") #For settings
@onready var AudioBus_SFX = AudioServer.get_bus_index("SFX") #For settings
var AudioSliderStep: float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayButton.grab_focus()
	#TitleUI.visible = false
	#Menu.visible = false
	#get_tree().paused = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	VibrationEnabled()

func UiScoreResets():
	GlobalDiceScript.AcquiredDice = 0
	GlobalPlayerScript.PlayerLevel = 1
	GlobalPlayerScript.PlayerXP = 0
	GlobalPlayerScript.LevelUpXP = 0
	GlobalPlayerScript.LevelUpQuota = GlobalPlayerScript.LevelUp1stQuota
	GlobalPlayerScript.EnemyKills = 0
	GlobalPlayerScript.autoAttacking_indicator = false
	GlobalGameSystem.GameReset = 0
	GlobalGameSystem.GamePlaying = false
	









func _on_main_menu_select():
	GlobalDiceScript.AcquiredDice = 0

func _credits():
	pass
	




func _on_play_button_pressed():
	GlobalGameSystem._restart()
	UiScoreResets()
	get_tree().change_scene_to_packed(GlobalSceneStorage.game_scene)


func _on_credits_button_pressed():
	_credits()


func _on_quit_button_pressed():
	get_tree().quit()

func VibrationEnabled():
	if (GlobalPlayerScript.EnableVibration):
		VibrateOnText.visible = true
		VibrateOffText.visible = false
	elif (!GlobalPlayerScript.EnableVibration):
		VibrateOnText.visible = false
		VibrateOffText.visible = true

func _on_cv_button_pressed():
	if (GlobalPlayerScript.EnableVibration):
		GlobalPlayerScript.EnableVibration = false
	elif (!GlobalPlayerScript.EnableVibration):
		GlobalPlayerScript.EnableVibration = true


func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioBus_Music, linear_to_db(value))
	AudioServer.set_bus_mute(AudioBus_Music, value < AudioSliderStep)

func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioBus_SFX, linear_to_db(value))
	AudioServer.set_bus_mute(AudioBus_SFX, value < AudioSliderStep)
