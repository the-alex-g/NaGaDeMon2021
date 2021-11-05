extends Spatial

# signals

# enums

# constants
const CAMERA_DISTANCE_FROM_PLAYER := Vector3(0,5,-2)

# exported variables

# variables
var _ignore

# onready variables
onready var _player := $Player
onready var _camera := $Camera


func _process(_delta:float)->void:
	_camera.transform.origin = _player.get_global_transform().origin + CAMERA_DISTANCE_FROM_PLAYER
