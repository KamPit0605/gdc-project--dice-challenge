extends CharacterBody3D


@export var player = CharacterBody3D
#@export var PlayerMesh = Node3D
@export var rotationSpeed : float = 15
@export var PlayerTrigger = Area3D
@export var AttackTrigger = Area3D


#--MOVEMENT--
var SPEED = 5.0
#const JUMP_VELOCITY = 4.5

#--GRAVITY--
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#--ATTACKING--
@onready var Attacking = $Attacking/Attacking
@export var AttackingFloat: float
@onready var AttackCooldown = $Attacking/AttackCooldown
@export var AttackCooldownFloat: float
@onready var AttackMesh = $Attacking/AttackTrigger/AttackMesh
#var OnAttack: float = 0.0
#var AttackCooldown: float = 0.0
var EnableAttack: bool = false
var EnableAttackCooldown: bool = false



func _ready():
	return

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

	AttackingFunc()

	move_and_slide()

func AttackingFunc():
	if (Input.is_action_just_pressed("Attack") && EnableAttackCooldown == false):
		Attacking.start(AttackingFloat)
		AttackCooldown.start(AttackCooldownFloat)
		AttackMesh.visible = true
		EnableAttack = true
		EnableAttackCooldown = true


func _on_attacking_timeout():
	EnableAttack = false
	AttackMesh.visible = false

func _on_attack_cooldown_timeout():
	EnableAttackCooldown = false
