class_name Enemy
extends KinematicBody

# signals

# enums
enum MOVEMENT {PATROL, CHASE, CATCH_UP}

# constants
const DIRECTIONS := [0, PI/2, PI, PI*1.5]

# exported variables
export var speed := 2
export var health := 15
export var damage_dealt := 10

# variables
var _ignore
var _movement = MOVEMENT.PATROL

# onready 


func _ready()->void:
	rotation.y = DIRECTIONS[randi()%4]


func _physics_process(delta:float)->void:
	var velocity := Vector3.ZERO
	
	if _movement == MOVEMENT.PATROL:
		velocity.z += speed*delta
		velocity = velocity.rotated(Vector3.UP, rotation.y)
		var collision := move_and_collide(velocity)
		if collision != null:
			rotation.y = DIRECTIONS[randi()%4]


func damage(damage:int)->void:
	health -= damage
	if health <= 0:
		queue_free()
