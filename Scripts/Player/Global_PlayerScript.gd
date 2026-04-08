extends Node
#Global Script

var Attacking: bool = false

var PlayerLevel: int = 1

var PlayerXP: float = 0
var LevelUpXP: float = 0
var LevelUpQuota: int = 300

var EnemyKills: int = 0

var DamageTaken: bool
var GainHealthBool: bool

var criticalHit_indicator: bool

var autoAttacking_indicator: bool

var DeathPosition: Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	LevelingUp()
	XPXP(PlayerLevel)
	#print()
	if Input.is_action_just_pressed("Level Up"):
		PlayerLevel += 1
	

func LevelingUp():
	if LevelUpXP >= LevelUpQuota:
		PlayerLevel += 1;
		GainHealthBool = true
		Input.start_joy_vibration(0,0.15,0.15,0.75)
		LevelUpXP = 0;

func XPXP(Level):
	if Level == 2:
		LevelUpQuota = 900
	elif Level == 3:
		LevelUpQuota = 1320
	elif Level == 4:
		LevelUpQuota = 1800
	elif Level == 5:
		LevelUpQuota = 2400
	elif Level == 6:
		LevelUpQuota = 3120
	elif Level == 7:
		LevelUpQuota = 3840
	elif Level == 8:
		LevelUpQuota = 4560
	elif Level == 9:
		LevelUpQuota = 5280
	elif Level == 10:
		LevelUpQuota = 6000
