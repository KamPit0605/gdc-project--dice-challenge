extends CharacterBody3D

#Globals
	#GlobalPlayerScript

@export var player = CharacterBody3D
#@export var PlayerMesh = Node3D
@export var rotationSpeed : float = 15
@export var PlayerTrigger = Area3D
@export var AttackTrigger = Area3D

@onready var LevelUpText = $Text/LevelUpText
@onready var TextCountdown = $Text/TextCountdown

#--MOVEMENT--
var SPEED = 5.0
#const JUMP_VELOCITY = 4.5

#--HEALTH--
var HEALTH: int = 40
 #might change this to float
var MaxHealth: int = 40
const DefaultDamage: int = 5
var Damage: int = 5
@onready var DamageCooldown = $DamageCooldown
var DamageCooldownFloat: float = 0.1
var DamageTaken: bool

#--GRAVITY--
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#--ATTACKING--
@onready var Attacking = $Attacking/Attacking
@export var AttackingFloat: float
@onready var AttackCooldown = $Attacking/AttackCooldown
@export var AttackCooldownFloat: float
@onready var AttackMesh = $Attacking/AttackTrigger/AttackMesh
var EnableAutoAttack: bool

@onready var AttackGuide = $Attacking/Visuals/AttackGuide
@onready var AttackCloserGuide = $Attacking/Visuals/AttackCloserGuide
#var OnAttack: float = 0.0
#var AttackCooldown: float = 0.0
var EnableAttack: bool = false
var EnableAttackCooldown: bool = false

var EnemyDetected: bool

func _ready():
	AttackingFloat = 0.15
	AttackCooldownFloat = 1.0
	return

func _process(_delta):
	if Input.is_action_just_pressed('Auto_Attack'):
		if !EnableAutoAttack:
			EnableAutoAttack = true
		else:
			EnableAutoAttack = false

	PlayerHealth()

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
	move_and_slide()

#Attack Functions
func AttackingFunc():
	if EnableAttackCooldown == false:
		GlobalPlayerScript.Attacking = true
		Attacking.start(AttackingFloat)
		AttackCooldown.start(AttackCooldownFloat)
		AttackMesh.visible = true
		EnableAttack = true
		EnableAttackCooldown = true


func _on_attacking_timeout():
	GlobalPlayerScript.Attacking = false
	EnableAttack = false
	AttackMesh.visible = false

func _on_attack_cooldown_timeout():
	EnableAttackCooldown = false

#PLAYER TRIGGERS
func _on_attack_trigger_area_entered(area):
	if area.is_in_group("Enemies"):
		EnemyDetected = true
		AttackCloserGuide.visible = true

func _autoAttackEnemy():
	if (EnemyDetected == true && EnableAutoAttack == true):
		AttackingFunc()

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
		GlobalPlayerScript.GainHealthBool = false

func TakingDamage():
	HEALTH -= Damage
#other function
func _on_player_trigger_area_entered(area):
	if (area.is_in_group("Enemies") && DamageTaken == false):
		Damage = DefaultDamage
		if (area.is_in_group("StrongEnemy")):
			Damage = 15
		TakingDamage()
		
		DamageCooldown.start(DamageCooldownFloat)
		DamageTaken = true
func _on_damage_cooldown_timeout():
	DamageTaken = false

func _on_text_countdown_timeout():
	LevelUpText.visible = false


func _on_player_trigger_area_exited(area):
	pass # Replace with function body.
