extends Node

@onready var GameStart: bool
@onready var GamePlaying: bool
#--TIMERS--
@onready var Game_Timer = $Timers/Game_Timer
@onready var Game_OverTimer = $Timers/Game_OverTimer

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
