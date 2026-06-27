extends CharacterBody3D

#Globals
	#GlobalPlayerScript
	#GlobalDiceScript

signal endGame

@export var player = CharacterBody3D
#@export var PlayerMesh = Node3D
@export var rotationSpeed : float = 15
@export var PlayerTrigger = Area3D
@export var AttackTrigger = Area3D
@onready var TexturesNode = $Textures

@onready var LevelUpText = $Text/LevelUpText
@onready var TextCountdown = $Text/TextCountdown

#--MOVEMENT--
var SPEED = 5.0
const DefaultSPEED = 5.0
#const JUMP_VELOCITY = 4.5

#--HEALTH--
var HEALTH: int = 40
 #might change this to float
var MaxHealth: int = 40
const DefaultDamage: int = 5
var Damage: int = 5
@onready var DamageCooldown = $Timers/DamageCooldown
var DamageCooldownFloat: float = 0.15
var DamageTaken: bool
var HealthGain: int
var HealthGainBool: bool
@onready var HealthGainCooldown = $Timers/HealthGainCooldown
var AbilityDiceHealhMult: int = 1

#--HURT--
@export var HurtMeshInstance: MeshInstance3D
@onready var HurtVisualTimer = $Hurt/HurtVisualTimer

#--DEFENSE DICE REDUCE--
var DefenseDiceReduce: int = 1
var AbilityDiceReduce: int = 0

#--GRAVITY--
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#--ATTACKING--
@onready var Attacking = $Attacking/Attacking
@export var AttackingFloat: float
@onready var AttackCooldown = $Attacking/AttackCooldown
@export var AttackCooldownFloat: float
@onready var AttackMesh = $Attacking/AttackTrigger/AttackMesh
@onready var CriticalMesh = $Attacking/AttackTrigger/CriticalMesh
var EnableAutoAttack: bool

@onready var AttackGuide = $Attacking/Visuals/AttackGuide
@onready var AttackCloserGuide = $Attacking/Visuals/AttackCloserGuide
#var OnAttack: float = 0.0
#var AttackCooldown: float = 0.0
var EnableAttack: bool = false
var EnableAttackCooldown: bool = false

var attack_rng: float
var criticalRate: float = 0.85
var criticalHit: bool
const defaultCriticalRate: float = 0.85

var EnemyDetected: bool

#--AUDIO--
@onready var AudioStreaming = $Audios/AudioStreamPlayer3D
@onready var AudioStreaming2 = $Audios/AudioStreamPlayer3D2
@onready var AudioStreaming3 = $Audios/AudioStreamPlayer3D3
@onready var AudioStreamingEx = $Audios/AudioStreamPlayer
var AudioChange: int
var AudioVolumeDefault: float = 0.0

func _ready():
	AttackingFloat = 0.15
	AttackCooldownFloat = 1.0
	HealthGainBool = true
	HurtMeshInstance.visible = false
	HealthGain = 1
	TexturesNode.rotation_degrees = Vector3(-90,0,0)
	return
	
func _process(_delta):
	if Input.is_action_just_pressed('Auto_Attack'):
		if !EnableAutoAttack:
			EnableAutoAttack = true
			GlobalPlayerScript.autoAttacking_indicator = true
		else:
			EnableAutoAttack = false
			GlobalPlayerScript.autoAttacking_indicator = false

	DiceRotation()
	PlayerHealth()
	_defenseDice()
	_abilityDice()
	_criticalChanges()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("Move_Left", "Move_Right", "Move_Forward", "Move_Backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = lerp(velocity.x, direction.x * SPEED, .2)
		velocity.z = lerp(velocity.z, direction.z * SPEED, .2)
	else:
		velocity.x = lerp(velocity.x,move_toward(velocity.x, 0, SPEED),.2)
		velocity.z = lerp(velocity.z,move_toward(velocity.z, 0, SPEED),.2)

	if (Input.is_action_just_pressed("Attack")): #" && EnableAttackCooldown == false" is in "AtackingFunc()"
		AttackingFunc()
	#AttackingFunc()
	_autoAttackEnemy()
	_CriticalAttackSound()
	
	criticalFunction()
	#_AudioChange_Attacking()
	if GlobalPlayerScript.AudioAbility == true:
		_AudioChange_Abilities()
	_Audio_EnemyKilled()
	
	move_and_slide()

#Attack Functions
func criticalFunction():
	if attack_rng >= criticalRate:
		criticalHit = true
		print("CRIT")
	else:
		criticalHit = false

	if criticalHit == true:
		GlobalPlayerScript.criticalHit_indicator = true
	else:
		GlobalPlayerScript.criticalHit_indicator = false

func AttackingFunc():
	if EnableAttackCooldown == false:
		GlobalPlayerScript.Attacking = true
		attack_rng = randf_range(0.1,1.0)
		print(attack_rng)
		Attacking.start(AttackingFloat)
		AttackCooldown.start(AttackCooldownFloat)
		AttackMesh.visible = true
		EnableAttack = true
		if criticalHit == true:
			CriticalMesh.visible = true
			Input.start_joy_vibration(0,0.5,0.5,0.15)
			if (!EnemyDetected): AudioPlaying2("res://Audio/SFX/MB/016. Axe Throw.mp3")
		_AudioChange_Attacking()
		AudioChanging(3)
		EnableAttackCooldown = true


func _on_attacking_timeout():
	GlobalPlayerScript.Attacking = false
	EnableAttack = false
	AttackMesh.visible = false
	CriticalMesh.visible = false

func _on_attack_cooldown_timeout():
	EnableAttackCooldown = false

#PLAYER TRIGGERS
func _on_attack_trigger_area_entered(area):
	if area.is_in_group("Enemies"):
		EnemyDetected = true
		AttackCloserGuide.visible = true
		_CriticalAttackSound()

func _autoAttackEnemy():
	if (EnemyDetected == true && EnableAutoAttack == true):
		AttackingFunc()

func _CriticalAttackSound():
	if (GlobalPlayerScript.criticalHit_indicator) && (EnableAttack) && (EnemyDetected):
		AudioStreaming2.volume_db = -2.0
		AudioPlaying2("res://Audio/SFX/FN/Critical.wav")
		await AudioStreaming2.finished
		AudioStreaming2.volume_db = AudioVolumeDefault
		

func _on_attack_trigger_area_exited(area):
	if area.is_in_group("Enemies"):
		EnemyDetected = false
		AttackCloserGuide.visible = false


#Health Functions
func PlayerHealth():
	if HEALTH >= MaxHealth:
		HEALTH = MaxHealth
	if GlobalPlayerScript.GainHealthBool == true:
		HEALTH += 5
		MaxHealth += 5
		LevelUpText.visible = true
		TextCountdown.start(2.0)
		_Audio_LevelUp()
		GlobalPlayerScript.GainHealthBool = false
		
	if ((GlobalDiceScript.RollDice == false) && ((GlobalDiceScript.AcquiredDice >= 4) || GlobalDiceScript.AbilityDRole == 3)):
		GainingHealth()
		
	if HEALTH <= 0:
		GlobalPlayerScript.DeathPosition = global_position
		GlobalPlayerScript.DeathRotation = TexturesNode.global_rotation
		emit_signal("endGame")

func GainingHealth():
	if HealthGainBool == true:
		HEALTH += (HealthGain * AbilityDiceHealhMult)
		HealthGainCooldown.start(2.0)
		HealthGainBool = false
	if (GlobalDiceScript.AcquiredDice >= 4):
		if (GlobalDiceScript.HealthDNum == 1):
			HealthGain = 1
		elif (GlobalDiceScript.HealthDNum == 2):
			HealthGain = 2
		elif (GlobalDiceScript.HealthDNum == 3):
			HealthGain = 3
		elif (GlobalDiceScript.HealthDNum >= 4) && (GlobalDiceScript.HealthDNum <= 5):
			HealthGain = 6
		elif (GlobalDiceScript.HealthDNum == 6):
			HealthGain = 12

func _defenseDice():
	if ((GlobalDiceScript.RollDice == false) && (GlobalDiceScript.AcquiredDice >= 3)):
		if ((GlobalDiceScript.DefenseDNum >= 1) && (GlobalDiceScript.DefenseDNum <= 2)):
			DefenseDiceReduce = 1
		elif ((GlobalDiceScript.DefenseDNum >= 3) && (GlobalDiceScript.DefenseDNum <= 5)):
			DefenseDiceReduce = 2
		elif GlobalDiceScript.DefenseDNum == 6:
			DefenseDiceReduce = 3
func _on_health_gain_cooldown_timeout():
	HealthGainBool = true

func _abilityDice():
	if ((GlobalDiceScript.AcquiredDice >= 2) && (GlobalDiceScript.RollDice == false)):
		if GlobalDiceScript.AbilityDRole == 1:  #SPEED Buff!
			SPEED = 7.0
		elif (!GlobalDiceScript.AbilityDRole == 1) || (!GlobalDiceScript.CriticalRoll):
			SPEED = DefaultSPEED
		
		if GlobalDiceScript.AbilityDRole == 2: #SHIELD Buff!
			AbilityDiceReduce = 1
		else:
			AbilityDiceReduce = 0
		
		if GlobalDiceScript.AbilityDRole == 3: #HEALTH regen Buff (multiplier)!
			if GlobalDiceScript.AcquiredDice >= 4:
				AbilityDiceHealhMult = 2
		else:
			AbilityDiceHealhMult = 1
		
		if GlobalDiceScript.AbilityDRole == 4: #attack cooldown reduce
			AttackCooldownFloat = 0.75
		elif (!GlobalDiceScript.AbilityDRole == 4) || (!GlobalDiceScript.CriticalRoll):
			AttackCooldownFloat = 1.0
		
		if GlobalDiceScript.AbilityDRole >= 5:
			criticalRate = 0.75
		else:
			criticalRate = defaultCriticalRate

func _criticalChanges():
	if GlobalDiceScript.CriticalRoll:
		SPEED = 9.0
		AttackCooldownFloat = 0.5

func TakingDamage():
	HEALTH -= Damage / (DefenseDiceReduce + AbilityDiceReduce)
	HurtMeshInstance.visible = true
	HurtVisualTimer.start(0.25)
	_AudioChange_Damaging()
	AudioChanging(0)
#other function
func _on_player_trigger_area_entered(area):
	if (area.is_in_group("Enemies") && DamageTaken == false):
		Damage = DefaultDamage
		if (area.is_in_group("StrongEnemy")):
			Damage = 15
		if (area.is_in_group("BigEnemy")):
			Damage = 45
		if (area.is_in_group("BossEnemy")):
			Damage = 75
			AudioPlaying("res://Audio/SFX/MB/178. Noodle Stop.mp3")
		if (area.is_in_group("GhostEnemy")):
			Damage = 20
		if (area.is_in_group("GhostStrongEnemy")):
			Damage = 40
		GlobalPlayerScript.DamageTaken = true
		TakingDamage()
		
		Input.start_joy_vibration(0,1.0,1.0,0.2)
		DamageCooldown.start(DamageCooldownFloat)
		DamageTaken = true
func _on_damage_cooldown_timeout():
	DamageTaken = false


func _on_text_countdown_timeout():
	LevelUpText.visible = false


func _on_player_trigger_area_exited(area):
	pass # Replace with function body.



func _on_hurt_visual_timer_timeout():
	HurtMeshInstance.visible = false

func DiceRotation():
	if GlobalPlayerScript.PlayerLevel == 4:
		TexturesNode.rotation_degrees = Vector3(0,0,0)
	elif GlobalPlayerScript.PlayerLevel == 6:
		TexturesNode.rotation_degrees = Vector3(0,0,90)
	elif GlobalPlayerScript.PlayerLevel == 8:
		TexturesNode.rotation_degrees = Vector3(0,0,-90)
	elif GlobalPlayerScript.PlayerLevel == 10:
		TexturesNode.rotation_degrees = Vector3(-180,0,0)
	elif GlobalPlayerScript.PlayerLevel == 12:
		TexturesNode.rotation_degrees = Vector3(90,0,0)

func AudioPlaying(SFX):
	AudioStreaming.stream = load(SFX)
	AudioStreaming.play()
func AudioPlaying2(SFX):
	AudioStreaming2.stream = load(SFX)
	AudioStreaming2.play()
func AudioPlaying3(SFX):
	AudioStreaming3.stream = load(SFX)
	AudioStreaming3.play()

#Audio changing and playing
func _AudioChange_Attacking():
	if AudioChange == 0:
		AudioPlaying("res://Audio/SFX/FN/Sword-swipe-1.wav")
	elif AudioChange == 1:
		AudioPlaying("res://Audio/SFX/FN/Sword-swipe-3.wav")
	elif AudioChange == 2:
		AudioPlaying("res://Audio/SFX/FN/Sword-swipe-4.wav")
	elif AudioChange == 3:
		AudioPlaying("res://Audio/SFX/FN/Sword-swipe-4.wav")
func _AudioChange_Damaging():
	if AudioChange == 0:
		AudioPlaying2("res://Audio/SFX/MB/078. fireplace.mp3")
	#elif AudioChange == 1:
		#AudioPlaying("res://Audio/SFX/MB/078. fireplace.mp3")
func _AudioChange_Abilities():
	if GlobalDiceScript.AbilityDRole == 1:
		AudioPlaying2("res://Audio/SFX/MBYB/ 005F - Sound Effects - 4 Game Fun Pack Monopoly Boggle _1.mp3")
	elif GlobalDiceScript.AbilityDRole == 2:
		AudioPlaying2("res://Audio/SFX/SSB/se_item_backshield_get.wav")
	elif GlobalDiceScript.AbilityDRole == 3:
		AudioPlaying2("res://Audio/SFX/SSB/se_common_lifeup.wav")

func _Audio_EnemyKilled():
	if GlobalPlayerScript.EnemyKilled == true:
		AudioStreaming3.pitch_scale = randf_range(0.75,1.75)
		AudioPlaying3("res://Audio/SFX/MB/189. Player Damage.mp3")
		if (GlobalPlayerScript.BossKilled):
			AudioStreaming3.pitch_scale = 1.0
			AudioPlaying3("res://Audio/SFX/MB/064. enemy spawn.mp3")
		await AudioStreaming3.finished
		AudioStreaming3.pitch_scale = 1.0
		

func _Audio_LevelUp():
	AudioPlaying3("res://Audio/SFX/MB/099. Holy Book.mp3")
	AudioStreamingEx.play()
	await AudioStreamingEx.finished
	AudioStreamingEx.pitch_scale += 0.05

func AudioChanging(max):
	AudioChange = randi_range(0,max)
