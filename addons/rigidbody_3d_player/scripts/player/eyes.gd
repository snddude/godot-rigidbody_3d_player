class_name Eyes
extends Camera3D

@export var sensitivity: float
@export_group("Nodes")
@export var neck: Node3D


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		neck.rotation_degrees.y -= deg_to_rad(event.relative.x * sensitivity)
		rotation_degrees.x -= deg_to_rad(event.relative.y * sensitivity)
		rotation_degrees.x = clamp(rotation_degrees.x, -90.0, 90.0)


func _process(delta: float) -> void:
	global_position = neck.get_global_transform_interpolated().origin
	global_rotation.y = neck.global_rotation.y
