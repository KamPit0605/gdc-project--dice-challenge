extends Control

@onready var CPassedUI = $VBoxContainer/Challenge/ChallengePassedUI
@onready var COverUI = $VBoxContainer/Challenge/ChallengeOverUI

@onready var XPUI = $XPCoinsKills/TotalXPUI
@onready var KillsUI = $XPCoinsKills/KillsUI/KillsTextUI

@onready var SelectCooldownTimer = $SelectCooldown
var SelectCooldown: bool = true

@export var PlayAgainMenu: Control
@export var MainMenuMenu: Control
@export var PlayAgainButton: Button
@export var MainMenuButton: Button
signal PlayAgainSelect
signal MainMenuSelect
var game_scene = preload("res://Scenes/game_scene.tscn")
#var mainMenu_scene


# Called when the node enters the scene tree for the first time.
func _ready():
	CPassedUI.visible = false
	COverUI.visible = false
	XPUI.visible = false
	KillsUI.visible = false
	PlayAgainMenu.visible = false
	MainMenuMenu.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var PlayerXPString = "%.0f" % GlobalPlayerScript.PlayerXP
	XPUI.text = str(PlayerXPString)
	KillsUI.text = str(GlobalPlayerScript.EnemyKills)

	if SelectCooldown == false:
		if Input.is_action_just_pressed("Confirm") :
			PlayAgainSelect.emit()
		if Input.is_action_just_pressed("Decline"):
			MainMenuSelect.emit()
		PlayAgainButton.pressed.connect(_playagain)
		MainMenuButton.pressed.connect(_mainmenu)

func _on_timer_timeout():
	XPUI.visible = true
	KillsUI.visible = true
	if GlobalGameSystem.OVERTIME == true:
		CPassedUI.visible = true
	else:
		COverUI.visible = true


func _on_select_cooldown_timeout():
	PlayAgainMenu.visible = true
	MainMenuMenu.visible = true
	SelectCooldown = false

func _playagain():
	PlayAgainSelect.emit()
func _mainmenu():
	pass

func _on_play_again_select():
	get_tree().change_scene_to_packed(game_scene)

func _on_main_menu_select():
	pass # Replace with function body.
