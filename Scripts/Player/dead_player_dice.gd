extends CharacterBody3D
#GlobalPlayerScript

# Called when the node enters the scene tree for the first time.
func _ready():
	global_position = GlobalPlayerScript.DeathPosition

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
