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
var XP: int = 60

#--MOVEMENT--
var SPEED = 3.0

#--HEALTH--
var Health: int = 30

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

# Called when the node enters the scene tree for the first time.
func _ready():
	#Cloned = true
	DisableALLTriggers()
	FollowingCooldownTimer.start(1)
	#if Cloned:
		#_ifSpawning()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	DamageLabel.text = str(Health)
	_debugPrinting()
	if (GlobalPlayerScript.Attacking == true && PlayerAttackTrigger == true && DamageCooldown == false): #damage taken
		Health -= 15
		DamageCooldownTimer.start(DamageCooldownF)
		DamageLabel.visible = true
		_followcooldown(0.5)
		print("OUCH!")
		DamageCooldown = true
	
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
		GlobalPlayerScript.PlayerXP += XP
		GlobalPlayerScript.LevelUpXP += XP
		GlobalPlayerScript.EnemyKills += 1
		queue_free()
		#self.visible = false
		#FollowPlayer = false
		#Health = 0


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
		_followcooldown(1.0)

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
