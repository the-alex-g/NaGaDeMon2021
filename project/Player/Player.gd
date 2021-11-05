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

# onready variables


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
	
	velocity *= speed*delta
	velocity = velocity.normalized()
	move_and_collide(Vector3(velocity.x, 0, velocity.y))
	var mouse_position := get_viewport().get_mouse_position()-SCREEN_SIZE/2
	var position_to_look_at := Vector3(mouse_position.x, 0, mouse_position.y)
	look_at(position_to_look_at, Vector3.UP)
