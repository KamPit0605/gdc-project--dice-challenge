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

#--XP--
var XP: int = 750
var XPMult: int = 1

#--MOVEMENT--
var SPEED = 2.0

#--HEALTH--
var Health: float = 400

#--critical DAMAGE--
var CRIT: int = 1
#--ATTACK DICE MULTIPLYER--
var AttackDiceMult: float = 1.0

#--ATTACKED--
@export var AttackedMeshInstance = MeshInstance3D
@export var CriticalAttackedMeshInstance = MeshInstance3D
@onready var AttackedTimer = $Attacked/AtackedTimer

#--PLAYER FOLLOW--
var Player: CharacterBody3D #@export

@onready var FollowingCooldownTimer = $FollowingCooldown
var FollowPlayer: bool = false

#--ADJUSTMENTS--
var TriggerOfF: float = 1.0 #variable for preventing any triggering happen within float time
var PlayerAreaCount: int = 0 #counts how many times it entered the Area3D (even in some OTHER way that I don't know)

#--SPAWNING--
var TopMidPosition = Node3D #@export
var BottomMidPosition = Node3D #@export
var Positioner: int #assigns the above positions to their respective ints

#@export var Cloned: bool = false

#--AUDIO--
@onready var AudioStreaming = $AudioStreamPlayer3D
var AudioChange: int
@onready var AudioStreaming2 = $AudioStreamPlayer3D2

# Called when the node enters the scene tree for the first time.
func _ready():
	#Cloned = true
	DisableALLTriggers()
	FollowingCooldownTimer.start(1)
	AudioChange = randi_range(0,1)
	AudioStreaming2.play()
	await FollowingCooldownTimer.timeout
	AudioPlaying("res://Audio/SFX/MB/180. Nuke.mp3")
	#if Cloned:
		#_ifSpawning()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	DamageLabel.text = str(Health)
	_debugPrinting()
	if (GlobalPlayerScript.Attacking == true && PlayerAttackTrigger == true && DamageCooldown == false): #damage taken
		Health -= 15 * CRIT * AttackDiceMult
		DamageCooldownTimer.start(DamageCooldownF)
		DamageLabel.visible = true
		_followcooldown(0.5)
		#print("OUCH!")
		AttackedTimer.start(0.25)
		_attackvisual()
		DamageCooldown = true
	
	_critical()
	_attackDiceMult()
	
	_XPMult()
	
	_Health()
	#_followingplayer()
	#_triggerAdjust()

func _debugPrinting():
	pass
	#print(Health, FollowPlayer)

func _physics_process(delta):
	#if Cloned:
		var targetPlayer = (Player.position - position).normalized()
		if FollowPlayer:
			position += targetPlayer * SPEED * delta

func _on_damage_cooldown_timeout():
	DamageCooldown = false
	
func _Health():
	if Health <= 0:
		GlobalPlayerScript.EnemyKilled = true
		GlobalPlayerScript.BossKilled = true
		GlobalPlayerScript.BossTypeKilled = 2
		GlobalPlayerScript.PlayerXP += (XP * XPMult)
		GlobalPlayerScript.LevelUpXP += (XP * XPMult)
		GlobalPlayerScript.EnemyKills += 1
		queue_free()
		#self.visible = false
		#FollowPlayer = false
		#Health = 0

func _XPMult():
	if GlobalGameSystem.OVERTIME == true:
		XPMult = 2

func _critical():
	if GlobalPlayerScript.criticalHit_indicator == true:
		CRIT = 2
	else:
		CRIT = 1
func _attackDiceMult():
	if (GlobalDiceScript.RollDice == false):
		if ((GlobalDiceScript.AttackDNum >= 2) && (GlobalDiceScript.AttackDNum <= 3)):
			AttackDiceMult = 1.0
		elif ((GlobalDiceScript.AttackDNum >= 4) && (GlobalDiceScript.AttackDNum <= 5)):
			AttackDiceMult = 1.5
		elif (GlobalDiceScript.AttackDNum == 6):
			AttackDiceMult = 2.0
		elif (GlobalDiceScript.AttackDNum == 1):
			AttackDiceMult = 0.5

func _attackvisual():
	if CRIT == 2:
		CriticalAttackedMeshInstance.visible = true
	else:
		AttackedMeshInstance.visible = true

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

#func _on_attack_trigger_area_exited(_area): (DIFFERENT FUNCTION: _on_enemy_trigger_area_entered(area)) 
	#PlayerAttackTrigger = false

func _on_enemy_trigger_area_entered(area):
	#print(area.name)
	if area.is_in_group("AttackTrigger"): #Detect Player's attack area
		PlayerAreaCount += 1
		if (PlayerAreaCount >= 1):
			PlayerAttackTrigger = true
			PlayerAreaCount = 2

	if area.is_in_group("Player"): #Hit Player
		_followcooldown(3)

func _on_enemy_trigger_area_exited(area):
	if area.is_in_group("AttackTrigger"):
		PlayerAttackTrigger = false
#func _followingplayer(): (KEEP THIS COMMENTED FOR NOW)
	#var targetPlayer = (Player.position - position).normalized()
	#if FollowPlayer:
		#position += targetPlayer * SPEED 

func _followcooldown(seconds):
	FollowPlayer = false
	FollowingCooldownTimer.start(seconds)
	

#func _spawning(PositionMarker):
	#transform.origin = PositionMarker.position
	#translate(Vector3(randf_range(-5,5),6,randf_range(-5,5)))
	
#func _ifSpawning():
	#Positioner = randi_range(0,1)
	#if Positioner == 0:
		#_spawning(TopMidPosition)
	#elif Positioner == 1:
		#_spawning(BottomMidPosition)

func _on_following_cooldown_timeout():
	#if Cloned:
		FollowPlayer = true


func _on_atacked_timer_timeout():
	AttackedMeshInstance.visible = false
	CriticalAttackedMeshInstance.visible = false

func AudioPlaying(SFX):
	AudioStreaming.stream = load(SFX)
	AudioStreaming.play()
	
	#Audio changing
func _AudioChange_Hit():
	AudioStreaming.pitch_scale = randf_range(0.80,1.2)
	if AudioChange == 0:
		AudioPlaying("res://Audio/SFX/MB/094. Hit1 0.mp3")
	elif AudioChange == 1:
		AudioPlaying("res://Audio/SFX/MB/096. Hit2 0.mp3")
	await AudioStreaming.finished
	AudioStreaming.pitch_scale = 1.0

func AudioChanging(max):
	AudioChange = randi_range(0,max)
