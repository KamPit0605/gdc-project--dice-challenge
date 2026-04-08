extends Node
#Global Script

var RollDice: bool
@export var AcquiredDice: int

var AttackDNum: int
var DefenseDNum: int
var HealthDNum: int
var AbilityDRole: int

var CriticalRoll: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	RollDice = true
	AcquiredDice = 0 #(Change this anytime for debugging)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if RollDice == true:
		_rolldice()
	#AttackDNum = 6
	#DefenseDNum = 6
	#HealthDNum = 6
	acquiringDice()
	_criticalroll()

func _DiceNum(DiceNum):
	DiceNum = randi_range(1,6)
func _LimitDiceNum(DiceNum):
	if DiceNum < 1:
		DiceNum = 1
	if DiceNum > 6:
		DiceNum = 6

func acquiringDice():
	if AcquiredDice >= 1:
		_LimitDiceNum(AttackDNum)
	if AcquiredDice >= 2:
		_LimitDiceNum(AbilityDRole)
	if AcquiredDice >= 3:
		_LimitDiceNum(DefenseDNum)
	if AcquiredDice >= 4:
		_LimitDiceNum(HealthDNum)

func _rolldice():
	if AcquiredDice >= 1:
		AttackDNum = randi_range(1,6)
	if AcquiredDice >= 2:
		AbilityDRole = randi_range(1,5)
	if AcquiredDice >= 3:
		DefenseDNum = randi_range(1,6)
	if AcquiredDice >= 4:
		HealthDNum = randi_range(1,6)

func _criticalroll():
	if (!RollDice) && ((AttackDNum == 6) && (DefenseDNum == 6) && (HealthDNum == 6)):
		CriticalRoll = true
	else:
		CriticalRoll = false
