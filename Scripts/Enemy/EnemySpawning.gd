extends Node

@onready var SpawnerCooldown = $SpawnerCooldown

@export var EnemyLowLevel: PackedScene
@export var targetPlayer: Node3D

@export var TopPositionMarker: Node3D
@export var BottomPositionMarker: Node3D
@export var TopMidReset: Node3D
@export var BottomMidReset: Node3D

var Spawning: bool
var SpawnCount: int

var SpawnPosition: int

# Called when the node enters the scene tree for the first time.
func _ready():
	SpawnCount = 6#randi_range(1,6)
	Spawning = true
	#var new_instance = EnemyLowLevell.instantiate()
	#add_child(new_instance)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (SpawnCount > 0) && (Spawning == true):
		#var EnemyLowSpawned = EnemyLowLevel.instantiate()
		#add_child(EnemyLowSpawned)
		SpawnPosition = randi_range(0,1)
		_instancing()
		SpawnCount -= 1
		
	else:
		SpawnCount = 0
		Spawning = false



func _instancing():
	var Instance_LowLevel = EnemyLowLevel.instantiate()
	add_child(Instance_LowLevel)
	Instance_LowLevel.Player = targetPlayer
	if SpawnPosition == 0:
		Instance_LowLevel.position = Vector3(TopPositionMarker.position.x,6,TopPositionMarker.position.z)
		TopPositionMarker.translate(Vector3(randf_range(-5,5),0,randf_range(-5,2)))
		#Instance_Lowlevel.translate(Vector3(randf_range(-5,5),6,randf_range(-5,5)))
	elif SpawnPosition == 1:
		Instance_LowLevel.position = Vector3(BottomPositionMarker.position.x,6,BottomPositionMarker.position.z)
		BottomPositionMarker.translate(Vector3(randf_range(-5,5),0,randf_range(-5,2)))
	#Instance_LowLevel.TopMidPosition = TopPositionMarker
	#Instance_LowLevel.BottomMidPosition = BottomPositionMarker



func _on_spawner_cooldown_timeout():
	#EnemyLowLevel.Cloned = true
	SpawnCount = randi_range(4,8)
	Spawning = true
	TopPositionMarker.global_position = TopMidReset.global_position
	BottomPositionMarker.global_position = BottomMidReset.global_position
	SpawnerCooldown.start(10)
