class_name Player
extends KinematicBody

# signals
signal damaged(current_health)

# enums

# constants
const SCREEN_SIZE := Vector2(1024,600)
const MELEE_WEAPON_TRANSLATION := Vector3(-0.461, 0.283, 0.056)
const MELEE_WEAPON_ROTATION := Vector3(22.418, 90, 61.384)
const RANGED_WEAPON_TRANSLATION := Vector3(-0.461, 0.332, 0)
const RANGED_WEAPON_ROTATION := Vector3(10, 0, 15)
const EQUIPMENT_INFORMATION := {
	"crossbow_common":{
		"damage":7,
		"armor":0,
		"armor_reduction":false,
		"armor_bypass":false,
		"ranged":true,
		"slot":"weapon",
		"mesh":"res://Models/obj/crossbow_common.obj",
	},
	"crossbow_uncommon":{
		"damage":10,
		"armor":0,
		"armor_reduction":false,
		"armor_bypass":false,
		"ranged":true,
		"slot":"weapon",
		"mesh":"res://Models/obj/crossbow_uncommon.obj",
	},
	"crossbow_rare":{
		"damage":13,
		"armor":0,
		"armor_reduction":false,
		"armor_bypass":false,
		"ranged":true,
		"slot":"weapon",
		"mesh":"res://Models/obj/crossbow_rare.obj",
	},
	"sword_common":{
		"damage":10,
		"armor":0,
		"armor_reduction":false,
		"armor_bypass":false,
		"ranged":false,
		"slot":"weapon",
		"mesh":"res://Models/obj/sword_common.obj",
	},
	"sword_uncommon":{
		"damage":13,
		"armor":0,
		"armor_reduction":false,
		"armor_bypass":false,
		"ranged":false,
		"slot":"weapon",
		"mesh":"res://Models/obj/sword_uncommon.obj",
	},
	"sword_rare":{
		"damage":15,
		"armor":0,
		"armor_reduction":false,
		"armor_bypass":false,
		"ranged":false,
		"slot":"weapon",
		"mesh":"res://Models/obj/sword_rare.obj",
	},
	"dagger_common":{
		"damage":7,
		"armor":0,
		"armor_reduction":false,
		"armor_bypass":true,
		"ranged":false,
		"slot":"weapon",
		"mesh":"res://Models/obj/dagger_common.obj",
	},
	"dagger_uncommon":{
		"damage":10,
		"armor":0,
		"armor_reduction":false,
		"armor_bypass":true,
		"ranged":false,
		"slot":"weapon",
		"mesh":"res://Models/obj/dagger_uncommon.obj",
	},
	"dagger_rare":{
		"damage":13,
		"armor":0,
		"armor_reduction":false,
		"armor_bypass":true,
		"ranged":false,
		"slot":"weapon",
		"mesh":"res://Models/obj/dagger_rare.obj",
	},
	"double_axe_common":{
		"damage":10,
		"armor":0,
		"armor_reduction":false,
		"armor_bypass":false,
		"ranged":false,
		"slot":"weapon",
		"mesh":"res://Models/obj/axeDouble_common.obj",
	},
	"double_axe_uncommon":{
		"damage":15,
		"armor":0,
		"armor_reduction":false,
		"armor_bypass":false,
		"ranged":false,
		"slot":"weapon",
		"mesh":"res://Models/obj/axeDouble_uncommon.obj",
	},
	"double_axe_rare":{
		"damage":20,
		"armor":0,
		"armor_reduction":false,
		"armor_bypass":false,
		"ranged":false,
		"slot":"weapon",
		"mesh":"res://Models/obj/axeDouble_rare.obj",
	},
	"axe_common":{
		"damage":9,
		"armor":0,
		"armor_reduction":true,
		"armor_bypass":false,
		"ranged":false,
		"slot":"weapon",
		"mesh":"res://Models/obj/axe_common.obj",
	},
	"axe_uncommon":{
		"damage":12,
		"armor":0,
		"armor_reduction":true,
		"armor_bypass":false,
		"ranged":false,
		"slot":"weapon",
		"mesh":"res://Models/obj/axe_common.obj",
	},
	"axe_rare":{
		"damage":15,
		"armor":0,
		"armor_reduction":true,
		"armor_bypass":false,
		"ranged":false,
		"slot":"weapon",
		"mesh":"res://Models/obj/axe_common.obj",
	},
	"hammer_common":{
		"damage":10,
		"armor":0,
		"armor_reduction":true,
		"armor_bypass":false,
		"ranged":false,
		"slot":"weapon",
		"mesh":"res://Models/obj/hammer_common.obj",
	},
	"hammer_uncommon":{
		"damage":13,
		"armor":0,
		"armor_reduction":true,
		"armor_bypass":false,
		"ranged":false,
		"slot":"weapon",
		"mesh":"res://Models/obj/hammer_uncommon.obj",
	},
	"hammer_rare":{
		"damage":15,
		"armor":0,
		"armor_reduction":false,
		"armor_bypass":true,
		"ranged":false,
		"slot":"weapon",
		"mesh":"res://Models/obj/hammer_rare.obj",
	},
	"shield_common":{
		"damage":0,
		"armor":0.2,
		"armor_reduction":false,
		"armor_bypass":false,
		"ranged":false,
		"slot":"shield",
		"mesh":"res://Models/obj/shield_common.obj",
	},
	"shield_uncommon":{
		"damage":0,
		"armor":0.4,
		"armor_reduction":false,
		"armor_bypass":false,
		"ranged":false,
		"slot":"shield",
		"mesh":"res://Models/obj/shield_uncommon.obj",
	},
	"shield_rare":{
		"damage":0,
		"armor":0.6,
		"armor_reduction":false,
		"armor_bypass":false,
		"ranged":false,
		"slot":"shield",
		"mesh":"res://Models/obj/shield_rare.obj",
	},
}
const PATH_TO_ARROW := "res://Projectiles/Arrow.tscn"

# exported variables
export var speed := 8

# variables
var _ignore
var _attacking := false
var _is_moving := false
var _bypass_armor := false
var _reduce_armor := false
var _armor := 0
var _damage := 10
var _camera_rotation_y := 0.0
var _health := 100
var _is_ranged_weapon_equipped := true
var _has_helmet := false

# onready variables
onready var _animations := $AnimationTree
onready var _attack_timer := $AttackTimer
onready var _sword_hit_area := $SwordHitArea
onready var _damage_timer := $DamageTimer
onready var _weapon := $Body/RightArm/Weapon


func _ready()->void:
	_attack_timer.wait_time = $AnimationPlayer.get_animation("Swing").length
	_damage_timer.wait_time = _attack_timer.wait_time/2
	_equip_new_item("sword_common")


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
		if _is_ranged_weapon_equipped:
			_animations.set("parameters/ShootReset/seek_position", 0)
		else:
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
		if _is_ranged_weapon_equipped:
			_animations.set("parameters/Attack/add_amount", 1)
		else:
			_animations.set("parameters/Attack/add_amount", 0)
	else:
		_animations.set("parameters/Final/add_amount", 0)


func _on_AttackTimer_timeout()->void:
	_attacking = false


func _on_DamageTimer_timeout()->void:
	if _is_ranged_weapon_equipped:
		var Arrow = load(PATH_TO_ARROW).instance()
		Arrow.damage = _damage
		Arrow.good = true
		Arrow.translation = $Body/RightArm/Weapon/ArrowSpawn.get_global_transform().origin
		Arrow.rotation.y = rotation.y+PI
		get_parent().add_child(Arrow)
	else:
		var overlapping_bodies:Array = _sword_hit_area.get_overlapping_bodies()
		for body in overlapping_bodies:
			if body.has_method("damage"):
				body.damage(_damage, _reduce_armor, _bypass_armor)


func damage(damage_taken:int)->void:
	_health -= damage_taken
	emit_signal("damaged", _health)


func _on_Main_update_camera_rotation(new_rotation_y:float)->void:
	_camera_rotation_y = new_rotation_y


func _equip_new_item(item_name:String)->void:
	var item_info:Dictionary = EQUIPMENT_INFORMATION[item_name]
	var new_mesh := load(item_info["mesh"])
	if item_info["slot"] == "weapon":
		_weapon.mesh = new_mesh
		_bypass_armor = item_info["armor_bypass"]
		_reduce_armor = item_info["armor_reduction"]
		if item_info["ranged"] == true:
			_is_ranged_weapon_equipped = true
			_weapon.rotation_degrees = RANGED_WEAPON_ROTATION
			_weapon.translation = RANGED_WEAPON_TRANSLATION
		else:
			_is_ranged_weapon_equipped = false
			_weapon.rotation_degrees = MELEE_WEAPON_ROTATION
			_weapon.translation = MELEE_WEAPON_TRANSLATION
	elif item_info["slot"] == "shield":
		$Body/LeftArm/Shield.mesh = new_mesh
		_armor = item_info["armor"]
		if _has_helmet:
			_armor += 0.1
	_damage = item_info["damage"]
