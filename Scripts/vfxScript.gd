extends Node3D
@onready var CriticalDice = $"Images/Critical Dice"
@onready var CriticalSuccess = $"Images/Critical Dice/Critical Success"
@onready var CriticalFailure = $"Images/Critical Dice/Critical Failure"

@onready var CriticalSuccessDie1 = $"Images/Critical Dice/Critical Success/Critical Success Die 1"
@onready var CriticalSuccessDie2 = $"Images/Critical Dice/Critical Success/Critical Success Die 2"
@onready var CriticalFailureDie1 = $"Images/Critical Dice/Critical Failure/Critical Success Die 1"
@onready var CriticalFailureDie2 = $"Images/Critical Dice/Critical Failure/Critical Success Die 2"

# Called when the node enters the scene tree for the first time.
func _ready():
	CriticalDice.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	CriticalRollVisual()
	

func _criticalSuccess():
	CriticalSuccessDie1.rotate_y(0.05)
	CriticalSuccessDie2.rotate_y(-0.05)
func _criticalFailure():
	CriticalFailureDie1.rotate_y(0.005)
	CriticalFailureDie2.rotate_y(-0.005)
	
func CriticalRollVisual():
	CriticalDice.show()
	if GlobalUi.CriticalRoleRate == 1:
		CriticalSuccess.show()
		_criticalSuccess()
	elif GlobalUi.CriticalRoleRate == 2:
		CriticalFailure.show()
		_criticalFailure()
	else:
		CriticalSuccess.hide()
		CriticalFailure.hide()
