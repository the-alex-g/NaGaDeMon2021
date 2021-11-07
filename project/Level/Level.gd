extends Spatial

# signals
signal update_camera_rotation(new_rotation_y)

# enums

# constants

# exported variables
export var camera_rotation_speed := 2.0

# variables
var _ignore

# onready variables
onready var _player := $Player
onready var _camera_rotation_point := $CameraRotationPoint
onready var _hud := $HUD


func _ready()->void:
	randomize()


func _process(_delta:float)->void:
	_camera_rotation_point.translation = _player.translation
	if Input.is_action_pressed("rotate_camera_clock"):
		_camera_rotation_point.rotation_degrees.y -= 1*camera_rotation_speed
	if Input.is_action_pressed("rotate_camera_counter"):
		_camera_rotation_point.rotation_degrees.y += 1*camera_rotation_speed
	emit_signal("update_camera_rotation", _camera_rotation_point.rotation_degrees.y)
	_camera_rotation_point.rotation_degrees.y = fmod(_camera_rotation_point.rotation_degrees.y, 360)


func _on_Player_damaged(current_health:int)->void:
	_hud.update_player_health(current_health)
