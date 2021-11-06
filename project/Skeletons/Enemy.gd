class_name Enemy
extends KinematicBody

# signals

# enums
enum MOVEMENT {PATROL, CHASE}

# constants
const DIRECTIONS := [0, PI/2, PI, PI*1.5]

# exported variables
export var speed := 2
export var health := 15
export var damage_dealt := 10
export var armor := 0.0

# variables
var _ignore
var _movement = MOVEMENT.PATROL
var _target:Spatial

# onready
onready var _sight_range := $SightRange
onready var _ray_cast := $RayCast


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
	
	if _movement == MOVEMENT.PATROL:
		var bodies_within_range:Array = _sight_range.get_overlapping_bodies()
		for body in bodies_within_range:
			if body is Player:
				if _can_see(body):
					_movement = MOVEMENT.CHASE
					_target = body
	
	if _movement == MOVEMENT.CHASE:
		if _can_see(_target):
			var target_position:Vector3 = _target.get_global_transform().origin
			var vector := target_position-get_global_transform().origin
			look_at(target_position, Vector3.UP)
			rotation.y += PI
			vector = vector.normalized()
			_ignore = move_and_collide(vector*delta*speed)
		else:
			_movement = MOVEMENT.PATROL


func _can_see(object:Spatial)->bool:
	var target_position:Vector3 = object.get_global_transform().origin
	_ray_cast.look_at(target_position, Vector3.UP)
	if _ray_cast.get_collider() == object:
		return true
	else:
		return false


func damage(damage:int)->void:
	health -= damage
	if health <= 0:
		queue_free()
