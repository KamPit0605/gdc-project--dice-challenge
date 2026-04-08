extends Camera3D

@export var AreaTrigger: Area3D
var FollowPlayer: bool = false
@export var PlayerMarker = Marker3D

var inArea: bool
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var targetPlayer = (PlayerMarker.global_position - position).normalized()
	if FollowPlayer == true:
		position += targetPlayer * 5 * delta

func _process(_delta):
	pass
	

func _on_timer_timeout():
	if inArea == false:
		FollowPlayer = true


func _on_camera_area_area_entered(area):
	if area.is_in_group("Player"):
		inArea = true
		FollowPlayer = false
