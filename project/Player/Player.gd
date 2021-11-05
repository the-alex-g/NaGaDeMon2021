class_name Player
extends KinematicBody

# signals

# enums

# constants
const SCREEN_SIZE := Vector2(1024,600)

# exported variables
export var speed := 10

# variables
var _ignore
var _attacking := false
var _is_moving := false

# onready variables
onready var _animations := $AnimationTree
onready var _attack_timer := $AttackTimer


func _ready()->void:
	_attack_timer.wait_time = $AnimationPlayer.get_animation("Swing").length


func _physics_process(delta)->void:
	var velocity := Vector2.ZERO
	if Input.is_action_pressed("left"):
		velocity.x += 1
	if Input.is_action_pressed("right"):
		velocity.x -= 1
	if Input.is_action_pressed("backward"):
		velocity.y -= 1
	if Input.is_action_pressed("forward"):
		velocity.y += 1
	if Input.is_action_just_pressed("Attack") and not _attacking:
		_attacking = true
		_animations.set("parameters/SwingReset/seek_position", 0)
		_attack_timer.start()
	
	if velocity != Vector2.ZERO:
		_is_moving = true
	else:
		_is_moving = false
	
	_set_animation()
	
	velocity *= speed*delta
	velocity = velocity.normalized()
	move_and_collide(Vector3(velocity.x, 0, velocity.y))
	var mouse_position := get_viewport().get_mouse_position()-SCREEN_SIZE/2
	var position_to_look_at := Vector3(mouse_position.x, 0, mouse_position.y)
	look_at(position_to_look_at, Vector3.UP)


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
