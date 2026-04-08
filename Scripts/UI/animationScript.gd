extends Node
#GlobalDiceScript
@export var DiceAnimation: AnimationPlayer

@export var RollingSelectedDice = 0 #plays whatever correlated dice
#1 = Attack
#2 = Defense
#3 = Health
#4 = Ability

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_diceRolling()


func _diceRolling():
	if GlobalDiceScript.RollDice == true:
		if RollingSelectedDice == 1:
			DiceAnimation.play("AttackDiceRolling")
		elif RollingSelectedDice == 2:
			DiceAnimation.play("DefenseDiceRolling")
		elif RollingSelectedDice == 3:
			DiceAnimation.play("HealthDiceRolling")
		elif RollingSelectedDice == 4:
			DiceAnimation.play("AbilityDiceRolling")
	else:
		DiceAnimation.seek(0.0,true)
		DiceAnimation.stop(true)
