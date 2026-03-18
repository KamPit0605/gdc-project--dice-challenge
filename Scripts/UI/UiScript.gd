extends Control

@export var Player = CharacterBody3D

#--TEXTS--
@onready var HealthUI = $HealthLevelXP/HealthUI
@onready var LevelUI = $HealthLevelXP/LevelUI
@onready var XPUI = $HealthLevelXP/XPUI


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	HealthUI.text = str(Player.HEALTH) + " / " + str(Player.MaxHealth) 
	
	#pass
