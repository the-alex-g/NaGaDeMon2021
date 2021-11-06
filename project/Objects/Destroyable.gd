class_name Destroyable
extends StaticBody

# signals

# enums

# constants

# exported variables

# variables
var _ignore

# onready variables
onready var _mesh:MeshInstance = $MeshInstance

func _ready()->void:
	if get("MESHES") != null:
		var meshes:Array = get("MESHES")
		var mesh_index := randi()%meshes.size()
		var path_to_mesh:String = meshes[mesh_index]
		_mesh.mesh = load(path_to_mesh)


func damage(_damage:int)->void:
	if has_method("_drop"):
		call("_drop")
	queue_free()
