class_name Eyes
extends Camera3D

@export_group("Nodes")
@export var player_head: Node3D


func _process(delta: float) -> void:
	global_position = player_head.get_global_transform_interpolated().origin
	global_rotation = player_head.global_rotation
