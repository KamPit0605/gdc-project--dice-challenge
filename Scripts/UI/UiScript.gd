extends Control

@export var Player = CharacterBody3D

#--TEXTS--
@onready var HealthUI = $HealthLevelXP/HealthUI
@onready var LevelUI = $HealthLevelXP/LevelUI
@onready var XPUI = $HealthLevelXP/XPUI

@onready var TotalXPUI = $XPCoinsKills/TotalXPUI
@onready var CoinsUI = 0
@onready var KillsUI = $XPCoinsKills/KillsUI/KillsTextUI
#GlobalPlayerScript

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	HealthUI.text = str(Player.HEALTH) + " / " + str(Player.MaxHealth) 
	
	LevelUI.text = str(GlobalPlayerScript.PlayerLevel)
	
	var LevelUpXPString = "%.0f" % GlobalPlayerScript.LevelUpXP
	var PlayerXPString = "%.0f" % GlobalPlayerScript.PlayerXP
	XPUI.text = str(LevelUpXPString) + " / " + str(GlobalPlayerScript.LevelUpQuota)
	
	TotalXPUI.text = str(PlayerXPString)
	KillsUI.text = str(GlobalPlayerScript.EnemyKills)
	#pass
