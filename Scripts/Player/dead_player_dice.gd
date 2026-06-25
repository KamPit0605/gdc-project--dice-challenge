extends CharacterBody3D
#GlobalPlayerScript
@onready var TextureNode = $Textures

# Called when the node enters the scene tree for the first time.
func _ready():
	global_position = GlobalPlayerScript.DeathPosition
	TextureNode.global_rotation = GlobalPlayerScript.DeathRotation
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
