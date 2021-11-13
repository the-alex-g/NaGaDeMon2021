class_name Ammo
extends KinematicBody

# signals

# enums

# constants

# exported variables
export var speed := 10

# variables
var _ignore
var good = true
var damage := 0

# onready variables

func _physics_process(delta:float)->void:
	var direction := Vector3.FORWARD.rotated(Vector3.UP, rotation.y)
	direction *= speed*delta
	var collision := move_and_collide(direction)
	if collision != null:
		if (good and collision.collider is Enemy) or (not good and collision.collider.has_method("damage")):
			collision.collider.damage(damage)
		queue_free()
