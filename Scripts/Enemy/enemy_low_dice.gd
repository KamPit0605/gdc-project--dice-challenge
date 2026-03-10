extends RigidBody3D
#Globals
	#GlobalPlayerScript

@export var Enemy = RigidBody3D
@export var rotationSpeed: float = 15
@export var EnemyTrigger = Area3D
@onready var DamageCooldownTimer = $DamageCooldown
@onready var DamageLabel = $DamageLabel

var PlayerAttackTrigger: bool = false #entered player's Area3D
var DamageCooldown: bool = false
var DamageCooldownF: float = 0.5
#--MOVEMENT--
var SPEED = 5.0

#--HEALTH--
var Health: int = 30

#--ADJUSTMENTS--
var TriggerOfF: float = 1.0 #variable for preventing any triggering happen within float time
var PlayerAreaCount: int = 0 #counts how many times it entered the Area3D (even in some OTHER way that I don't know)

# Called when the node enters the scene tree for the first time.
func _ready():
	DisableALLTriggers()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	DamageLabel.text = str(Health)
	print(Health)
	if (GlobalPlayerScript.Attacking == true && PlayerAttackTrigger == true && DamageCooldown == false):
		Health -= 15
		DamageCooldownTimer.start(DamageCooldownF)
		DamageLabel.visible = true
		print("OUCH!")
		DamageCooldown = true
	
	_Health()
	#_triggerAdjust()

func _on_damage_cooldown_timeout():
	DamageCooldown = false
	
func _Health():
	if Health <= 0:
		self.visible = false
		Health = 0

func _triggerAdjust():
	pass
	#TriggerOfF - 0.1
	#if (TriggerOfF > 0):
	#	DisableALLTriggers()
	#else:
	#	TriggerOfF = 0

func DisableALLTriggers():
	PlayerAttackTrigger = false


func _on_attack_trigger_area_entered(_area): #player's trigger
	PlayerAreaCount += 1
	if (PlayerAreaCount > 1):
		PlayerAttackTrigger = true
		PlayerAreaCount = 2

func _on_attack_trigger_area_exited(_area):
	PlayerAttackTrigger = false
