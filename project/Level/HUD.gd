extends CanvasLayer

# signals

# enums

# constants

# exported variables

# variables
var _ignore

# onready variables
onready var _health_bar := $HealthBar


func update_player_health(new_health:int)->void:
	_health_bar.value = new_health

