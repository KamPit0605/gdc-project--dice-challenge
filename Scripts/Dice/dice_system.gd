extends Node

var RollingDiceCooldown: float
@onready var RollingDiceTimer = $Timers/RollingDiceTimer

#Global_DiceScript
#Global_PlayerScript
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	RollingDiceCooldown -= delta
	#print("Roll until  " + str(RollingDiceCooldown))
	
	if GlobalDiceScript.RollDice == true:
		RollingDiceCooldown = 8
		#RollingDiceTimer will be counting down
	
	if RollingDiceCooldown <= 0:
		RollingDiceTimer.start(3)
		GlobalDiceScript.RollDice = true
		RollingDiceCooldown = 0
	
	acquiringDice()

func _on_rolling_dice_timer_timeout():
	GlobalDiceScript.RollDice = false

func acquiringDice():
	if GlobalPlayerScript.PlayerLevel == 5:
		GlobalDiceScript.AcquiredDice = 2
	if GlobalPlayerScript.PlayerLevel == 6:
		GlobalDiceScript.AcquiredDice = 3
	if GlobalPlayerScript.PlayerLevel == 8:
		GlobalDiceScript.AcquiredDice = 4
