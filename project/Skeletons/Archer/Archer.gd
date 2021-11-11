extends Enemy

# signals

# enums

# constants

# exported variables

# variables
var _ammunition = preload("res://Projectiles/Arrow.tscn")

# onready variables

func _unique_attack()->void:
	var Arrow = _ammunition.instance()
	Arrow.rotation.y = rotation.y+PI
	Arrow.damage = damage_dealt
	Arrow.good = false
	Arrow.translation = $Body/RightArm/Weapon/ArrowSpawn.get_global_transform().origin
	get_parent().add_child(Arrow)

