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


# Called when the node enters the scene tree for the first time.
func _ready():
	PauseUI.visible = false
	Menu.visible = false
	get_tree().paused = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("Pause") :
		_Pausing()
		
		
	PauseMenu()

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
	else:
		PauseUI.visible = false
		Menu.visible = false





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
