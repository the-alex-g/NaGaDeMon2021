extends Spatial

# signals
signal update_camera_rotation(new_rotation_y)

# enums

# constants

# exported variables

# variables
var _ignore

# onready variables
onready var _player := $Player
onready var _camera_rotation_point := $CameraRotationPoint


func _ready()->void:
	randomize()


func _process(_delta:float)->void:
	_camera_rotation_point.translation = _player.translation
	if Input.is_action_pressed("rotate_camera_clock"):
		_camera_rotation_point.rotation_degrees.y -= 1
	if Input.is_action_pressed("rotate_camera_counter"):
		_camera_rotation_point.rotation_degrees.y += 1
	emit_signal("update_camera_rotation", _camera_rotation_point.rotation_degrees.y)
	_camera_rotation_point.rotation_degrees.y = fmod(_camera_rotation_point.rotation_degrees.y, 360)
