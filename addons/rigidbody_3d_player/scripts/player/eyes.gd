class_name Eyes
extends Camera3D

@export_group("Nodes")
@export var player: Player


func _process(delta: float) -> void:
	global_position = player.head.get_global_transform_interpolated().origin
	global_rotation = player.head.global_rotation
