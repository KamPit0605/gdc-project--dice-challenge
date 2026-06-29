extends Control

@onready var PauseUI = $VBoxContainer/Pause

var Pausing = false

@export var Menu: Control
@export var ResumeButton: Button
@export var PlayAgainButton: Button
@export var MainMenuButton: Button
@export var game_scene = preload("res://Scenes/game_scene.tscn")
@export var mainmenu_scene = preload("res://Scenes/mainmenu_scene.tscn")
signal ResumeSelect
signal RestartSelect
signal MainmenuSelect

#var mainMenu_scene
#var ConnectButtons: bool = false

#--settings--
@onready var VibrateOnText = $Settings/Vibration/OnText
@onready var VibrateOffText = $Settings/Vibration/OffText

@onready var AudioBus_Music = AudioServer.get_bus_index("Music") #For settings
@onready var AudioBus_SFX = AudioServer.get_bus_index("SFX") #For settings
var AudioSliderStep: float = 0.5
@onready var MusicSlider = $Settings/Music/MusicSlider
@onready var SFXSlider = $Settings/SFX/SFXSlider
@export var Settings: Control

# Called when the node enters the scene tree for the first time.
func _ready():
	PauseUI.visible = false
	Menu.visible = false
	Settings.visible = false
	get_tree().paused = false
	
	MusicSlider.value = db_to_linear(AudioServer.get_bus_volume_db(1)) #volume setting
	SFXSlider.value = db_to_linear(AudioServer.get_bus_volume_db(2)) #volume setting


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("Pause") :
		_Pausing()
		
		
	PauseMenu()
	VibrationEnabled()

	if (Pausing) && Input.is_action_just_pressed("Unpause(controller)"):
		_resuming()

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
	

func _Pausing():
	ResumeButton.grab_focus()
	if !Pausing:
		Pausing = true
		get_tree().paused = true
	else:
		get_tree().paused = false
		Pausing = false

func PauseMenu():
	if Pausing:
		PauseUI.visible = true
		Menu.visible = true
		Settings.visible = true
	else:
		PauseUI.visible = false
		Menu.visible = false
		Settings.visible = false





func _on_main_menu_select():
	GlobalGameSystem._restart()
	UiScoreResets()
	get_tree().change_scene_to_packed(mainmenu_scene)

func _resuming():
	_Pausing()
	Pausing = false
	

func _on_resume_button_pressed():
	_resuming()

func _on_restart_button_pressed():
	GlobalGameSystem._restart()
	UiScoreResets()
	get_tree().reload_current_scene()


func _on_main_menu_button_pressed():
	_on_main_menu_select()


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
