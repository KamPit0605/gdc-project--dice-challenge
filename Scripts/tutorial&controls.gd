extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	self.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GlobalGameSystem.GamePlaying == true:
		self.hide()
