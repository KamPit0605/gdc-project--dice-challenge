extends RigidBody3D
#Globals
	#GlobalPlayerScript

@export var Enemy = RigidBody3D
@export var rotationSpeed: float = 15
@export var EnemyTrigger = Area3D

var PlayerAttackTrigger: bool = false #entered player's Area3D

#--MOVEMENT--
var SPEED = 5.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (GlobalPlayerScript.Attacking == true && PlayerAttackTrigger == true):
		print("OUCH!")


func _on_body_entered(body):
	pass # Replace with function body.


func _on_attack_trigger_area_entered(_area): #player's trigger
	PlayerAttackTrigger = true
func _on_attack_trigger_area_exited(area):
	PlayerAttackTrigger = false
