extends Control



@export var PlayButton: Button
@export var CreditsButton: Button
@export var QuitButton: Button
@export var game_scene = "res://Scenes/game_scene.tscn"
#var mainMenu_scene
#var ConnectButtons: bool = false
@onready var Credits = $Credits
@export var HideCreditsButton: Button
signal HideCredits
var CreditsShown: bool

#Games From SFX Sources
@onready var AtariGames = $Credits/SFXCredit/SFXCreditContainer/AtariContainer
@onready var HalfbrickGames = $Credits/SFXCredit/SFXCreditContainer/HalfbrickContainer
@onready var NintendoGames = $Credits/SFXCredit/SFXCreditContainer/NintendoContainer
@onready var VedinadGames = $Credits/SFXCredit/SFXCreditContainer/VedinadContainer


#--settings--
@onready var VibrateOnText = $Settings/Vibration/OnText
@onready var VibrateOffText = $Settings/Vibration/OffText

@onready var AudioBus_Music = AudioServer.get_bus_index("Music") #For settings
@onready var AudioBus_SFX = AudioServer.get_bus_index("SFX") #For settings
var AudioSliderStep: float = 0.25

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayButton.grab_focus()
	#TitleUI.visible = false
	#Menu.visible = false
	#get_tree().paused = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	if (Input.is_action_just_pressed("ui_cancel")):
		if (CreditsShown):
			HideCredits.emit()
	
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
	Credits.show()
	CreditsShown = true
	




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


func _on_hide_credits_button_pressed():
	HideCredits.emit()


func _on_hide_credits():
	CreditsShown = false
	Credits.hide()
	CreditsButton.grab_focus()

#Atari
func _on_atari_area_area_entered(area):
	if (area.is_in_group("Mouse")):
		AtariGames.show()
func _on_atari_area_area_exited(area):
	if (area.is_in_group("Mouse")):
		AtariGames.hide()
#Halfbrick
func _on_halfbrick_area_area_entered(area):
	if (area.is_in_group("Mouse")):
		HalfbrickGames.show()
func _on_halfbrick_area_area_exited(area):
	if (area.is_in_group("Mouse")):
		HalfbrickGames.hide()
#Nintendo
func _on_nintendo_area_area_entered(area):
	if (area.is_in_group("Mouse")):
		NintendoGames.show()
func _on_nintendo_area_area_exited(area):
	if (area.is_in_group("Mouse")):
		NintendoGames.hide()
#Vedinad
func _on_vedinad_area_area_entered(area):
	if (area.is_in_group("Mouse")):
		VedinadGames.show()
func _on_vedinad_area_area_exited(area):
	if (area.is_in_group("Mouse")):
		VedinadGames.hide()
