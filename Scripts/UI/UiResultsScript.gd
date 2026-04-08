extends Control

@onready var CPassedUI = $VBoxContainer/Challenge/ChallengePassedUI
@onready var COverUI = $VBoxContainer/Challenge/ChallengeOverUI

@onready var XPUI = $XPCoinsKills/TotalXPUI
@onready var KillsUI = $XPCoinsKills/KillsUI/KillsTextUI

# Called when the node enters the scene tree for the first time.
func _ready():
	CPassedUI.visible = false
	COverUI.visible = false
	XPUI.visible = false
	KillsUI.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var PlayerXPString = "%.0f" % GlobalPlayerScript.PlayerXP
	XPUI.text = str(PlayerXPString)
	KillsUI.text = str(GlobalPlayerScript.EnemyKills)


func _on_timer_timeout():
	XPUI.visible = true
	KillsUI.visible = true
	if GlobalGameSystem.OVERTIME == true:
		CPassedUI.visible = true
	else:
		COverUI.visible = true
