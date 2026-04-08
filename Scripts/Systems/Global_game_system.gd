extends Node

@onready var GameStart: bool
@onready var GamePlaying: bool
#--TIMERS--
@onready var Game_Timer = $Timers/Game_Timer
@onready var Game_OverTimer = $Timers/Game_OverTimer

@onready var OVERTIME: bool

@onready var endGame: bool = false


#--SCENES--
var gameOverScene = "res://Scenes/gameover_scene.tscn"


#@export var UniqueEnemy: RigidBody3D
# Called when the node enters the scene tree for the first time.
func _ready():
	#GamePlaying = true #(This should be used for debugging purposes)
	
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if GameStart == true:
		GamePlaying = true
		GameStart = false
	
	_endGame()

func _restart():
	GameStart = false
	GamePlaying = false
	OVERTIME = false

	

func _endGame():
	if endGame == true:
		get_tree().change_scene_to_file(gameOverScene)
		

func _on_player_dice_end_game():
	endGame = true
