class_name Player
extends KinematicBody

# signals
signal damaged(current_health)

# enums

# constants
const SCREEN_SIZE := Vector2(1024,600)

# exported variables
export var speed := 8

# variables
var _ignore
var _attacking := false
var _is_moving := false
var _damage := 10
var _camera_rotation_y := 0.0
var _health := 100

# onready variables
onready var _animations := $AnimationTree
onready var _attack_timer := $AttackTimer
onready var _sword_hit_area := $SwordHitArea
onready var _damage_timer := $DamageTimer


func _ready()->void:
	_attack_timer.wait_time = $AnimationPlayer.get_animation("Swing").length
	_damage_timer.wait_time = _attack_timer.wait_time/2


func _physics_process(delta:float)->void:
	var velocity := Vector2.ZERO
	if Input.is_action_pressed("left"):
		velocity.x += speed
	if Input.is_action_pressed("right"):
		velocity.x -= speed
	if Input.is_action_pressed("backward"):
		velocity.y -= speed
	if Input.is_action_pressed("forward"):
		velocity.y += speed
	if Input.is_action_just_pressed("Attack") and not _attacking:
		_attacking = true
		_animations.set("parameters/SwingReset/seek_position", 0)
		_attack_timer.start()
		_damage_timer.start()
	
	if velocity != Vector2.ZERO:
		_is_moving = true
	else:
		_is_moving = false
	
	_set_animation()
	
	velocity = velocity.normalized()
	velocity = velocity.rotated(deg2rad(-1*_camera_rotation_y))
	velocity *= speed*delta
	_ignore = move_and_collide(Vector3(velocity.x, 0, velocity.y))
	
	var mouse_position := get_viewport().get_mouse_position()-SCREEN_SIZE/2
	var position_to_look_at := Vector3(mouse_position.x, 0, mouse_position.y)
	look_at(position_to_look_at, Vector3.UP)
	rotation_degrees.y += _camera_rotation_y


func _set_animation()->void:
	if _is_moving:
		_animations.set("parameters/Movement/add_amount", 1)
	else:
		_animations.set("parameters/Movement/add_amount", 0)
	if _attacking:
		_animations.set("parameters/Final/add_amount", 1)
	else:
		_animations.set("parameters/Final/add_amount", 0)


func _on_AttackTimer_timeout()->void:
	_attacking = false


func _on_DamageTimer_timeout()->void:
	var overlapping_bodies:Array = _sword_hit_area.get_overlapping_bodies()
	for body in overlapping_bodies:
		if body.has_method("damage"):
			body.damage(_damage)


func damage(damage_taken:int)->void:
	_health -= damage_taken
	emit_signal("damaged", _health)


func _on_Main_update_camera_rotation(new_rotation_y:float)->void:
	_camera_rotation_y = new_rotation_y
