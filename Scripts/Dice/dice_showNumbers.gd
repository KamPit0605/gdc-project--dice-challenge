extends BoxContainer
#UI Script
#GlobalDiceScript

@onready var ADNum1 = $AttackDice/ADiceNums/Num1
@onready var ADNum2 = $AttackDice/ADiceNums/Num2
@onready var ADNum3 = $AttackDice/ADiceNums/Num3
@onready var ADNum4 = $AttackDice/ADiceNums/Num4
@onready var ADNum5 = $AttackDice/ADiceNums/Num5
@onready var ADNum6 = $AttackDice/ADiceNums/Num6

@onready var DDNum1 = $DefenseDice/DDiceNums/Num1
@onready var DDNum2 = $DefenseDice/DDiceNums/Num2
@onready var DDNum3 = $DefenseDice/DDiceNums/Num3
@onready var DDNum4 = $DefenseDice/DDiceNums/Num4
@onready var DDNum5 = $DefenseDice/DDiceNums/Num5
@onready var DDNum6 = $DefenseDice/DDiceNums/Num6

@onready var HDNum1 = $HealthDice/HDiceNums/Num1
@onready var HDNum2 = $HealthDice/HDiceNums/Num2
@onready var HDNum3 = $HealthDice/HDiceNums/Num3
@onready var HDNum4 = $HealthDice/HDiceNums/Num4
@onready var HDNum5 = $HealthDice/HDiceNums/Num5
@onready var HDNum6 = $HealthDice/HDiceNums/Num6

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	_diceNumbers()

func _diceNumbers():
	if (GlobalDiceScript.AttackDNum == 1):
		ADNum1.visible = true
	else:
		ADNum1.visible = false
	if (GlobalDiceScript.AttackDNum == 2):
		ADNum2.visible = true
	else:
		ADNum2.visible = false
	if (GlobalDiceScript.AttackDNum == 3):
		ADNum3.visible = true
	else:
		ADNum3.visible = false
	if (GlobalDiceScript.AttackDNum == 4):
		ADNum4.visible = true
	else:
		ADNum4.visible = false
	if (GlobalDiceScript.AttackDNum == 5):
		ADNum5.visible = true
	else:
		ADNum5.visible = false
	if (GlobalDiceScript.AttackDNum == 6):
		ADNum6.visible = true
	else:
		ADNum6.visible = false
		
	if (GlobalDiceScript.DefenseDNum == 1):
		DDNum1.visible = true
	else:
		DDNum1.visible = false
	if (GlobalDiceScript.DefenseDNum == 2):
		DDNum2.visible = true
	else:
		DDNum2.visible = false
	if (GlobalDiceScript.DefenseDNum == 3):
		DDNum3.visible = true
	else:
		DDNum3.visible = false
	if (GlobalDiceScript.DefenseDNum == 4):
		DDNum4.visible = true
	else:
		DDNum4.visible = false
	if (GlobalDiceScript.DefenseDNum == 5):
		DDNum5.visible = true
	else:
		DDNum5.visible = false
	if (GlobalDiceScript.DefenseDNum == 6):
		DDNum6.visible = true
	else:
		DDNum6.visible = false
		
	if (GlobalDiceScript.HealthDNum <= 1):
		HDNum1.visible = true
	else:
		HDNum1.visible = false
	if (GlobalDiceScript.HealthDNum == 2):
		HDNum2.visible = true
	else:
		HDNum2.visible = false
	if (GlobalDiceScript.HealthDNum == 3):
		HDNum3.visible = true
	else:
		HDNum3.visible = false
	if (GlobalDiceScript.HealthDNum == 4):
		HDNum4.visible = true
	else:
		HDNum4.visible = false
	if (GlobalDiceScript.HealthDNum == 5):
		HDNum5.visible = true
	else:
		HDNum5.visible = false
	if (GlobalDiceScript.HealthDNum >= 6):
		HDNum6.visible = true
	else:
		HDNum6.visible = false
func _hideDiceNumbers():
	pass
