extends Node

@onready var SpawnerCooldown = $SpawnerCooldown

@export var EnemyLowLevel: PackedScene
@export var EnemyStrongLevel: PackedScene
@export var EnemyBigLevel: PackedScene
@export var EnemyHugeLevel: PackedScene
@export var targetPlayer: Node3D

@export var TopPositionMarker: Node3D
@export var BottomPositionMarker: Node3D
@export var TopMidReset: Node3D
@export var BottomMidReset: Node3D

@export var UpPositionStageMarker: Node3D
@export var DownPositionStageMarker: Node3D
@export var LeftPositionStageMarker: Node3D
@export var RightPositionStageMarker: Node3D

var Spawning: bool
var SpawnCount: int

var RoundsSpawn: int #how many times the enemies spawned
var _10RoundsSpawn: int #every 10 rounds...
var _10RoundCount: int
var SpawnRNG: int #the chance for different enemies

var SpawnPosition: int

# Called when the node enters the scene tree for the first time.
func _ready():
	SpawnCount = 6#randi_range(1,6)
	Spawning = true
	#var new_instance = EnemyLowLevell.instantiate()
	#add_child(new_instance)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (SpawnCount > 0) && (Spawning == true) && (GlobalGameSystem.GamePlaying == true):
		#var EnemyLowSpawned = EnemyLowLevel.instantiate()
		#add_child(EnemyLowSpawned)
		SpawnPosition = randi_range(0,5)
		SpawnRNG = randi_range(0,50)
		_instanceDifferentTypes()
		SpawnCount -= 1
		
	else:
		SpawnCount = 0
		Spawning = false
		
	#if _10RoundsSpawn > 10:
		#_10RoundsSpawn = 0



func _instancing(Enemy):
	var Instance_Level = Enemy.instantiate()
	add_child(Instance_Level)
	Instance_Level.Player = targetPlayer
	if SpawnPosition == 0:
		Instance_Level.position = Vector3(TopPositionMarker.global_position.x,6,TopPositionMarker.global_position.z)
		TopPositionMarker.translate(Vector3(randf_range(-5,5),0,randf_range(-5,2)))
		#Instance_Lowlevel.translate(Vector3(randf_range(-5,5),6,randf_range(-5,5)))
	elif SpawnPosition == 1:
		Instance_Level.position = Vector3(BottomPositionMarker.global_position.x,6,BottomPositionMarker.global_position.z)
		BottomPositionMarker.translate(Vector3(randf_range(-5,5),0,randf_range(-5,2)))
	elif SpawnPosition == 2:
		Instance_Level.position = Vector3(UpPositionStageMarker.global_position.x,6,UpPositionStageMarker.global_position.z)
	elif SpawnPosition == 3:
		Instance_Level.position = Vector3(DownPositionStageMarker.global_position.x,6,DownPositionStageMarker.global_position.z)
	elif SpawnPosition == 4:
		Instance_Level.position = Vector3(LeftPositionStageMarker.global_position.x,6,LeftPositionStageMarker.global_position.z)
	elif SpawnPosition == 5:
		Instance_Level.position = Vector3(RightPositionStageMarker.global_position.x,6,RightPositionStageMarker.global_position.z)
	#Instance_LowLevel.TopMidPosition = TopPositionMarker
	#Instance_LowLevel.BottomMidPosition = BottomPositionMarker
func _instanceDifferentTypes():
	if SpawnRNG >= 30:
		if RoundsSpawn >= 5:
			_instancing(EnemyStrongLevel)
	else:
		_instancing(EnemyLowLevel)
	if _10RoundsSpawn == 10:
		_instancing(EnemyBigLevel)
		_10RoundsSpawn = 0
		_10RoundCount += 1
	if _10RoundCount == 3:
		_instancing(EnemyHugeLevel)
		_10RoundCount = 0


func _on_spawner_cooldown_timeout():
	#EnemyLowLevel.Cloned = true
	SpawnCount = randi_range(4,8)
	if RoundsSpawn >= 10:
		SpawnCount = randi_range(6,12)
	elif RoundsSpawn >= 20:
		SpawnCount = randi_range(8,16)
	elif RoundsSpawn >= 30:
		SpawnCount = randi_range(12,24)
	Spawning = true
	TopPositionMarker.global_position = TopMidReset.global_position
	BottomPositionMarker.global_position = BottomMidReset.global_position
	RoundsSpawn += 1
	_10RoundsSpawn += 1
	SpawnerCooldown.start(6)
