class_name Player
extends RigidBody3D

@export_group("Movement")
@export var walk_speed: float
@export var jump_height: float
@export var max_slope_angle: float
@export_subgroup("Acceleration")
@export var floor_accel_rate: float
@export var floor_decel_rate: float
@export var air_accel_rate: float
@export var air_decel_rate: float
@export_group("Nodes")
@export var collider: CollisionShape3D
@export var floor_check: ShapeCast3D
@export var ceiling_check: ShapeCast3D
@export var neck: Node3D

var floor_angle: float = 0.0
var is_on_slope: bool = false
var is_on_floor: bool = false
var wish_dir := Vector3.ZERO
var velocity := Vector3.ZERO
var floor_normal := Vector3.ZERO

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _process(_delta: float) -> void:
	wish_dir = Vector3(Input.get_axis("left", "right"), 0.0, Input.get_axis("forward", "back"))

	is_on_slope = false
	is_on_floor = false

	var collision_count: int = floor_check.get_collision_count()
	var normal_sum := Vector3.ZERO

	for index: int in collision_count:
		normal_sum += floor_check.get_collision_normal(index)

	floor_normal = (normal_sum / collision_count).normalized()

	var normal_dot: float = floor_normal.dot(Vector3.UP)
	floor_angle = rad_to_deg(acos(normal_dot))

	if floor_angle <= max_slope_angle:
		is_on_slope = normal_dot > 0.0 and normal_dot < 1.0
		is_on_floor = normal_dot == 1.0 or is_on_slope


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	for index: int in state.get_contact_count():
		if state.get_contact_collider_object(index) is RigidBody3D:
			continue

		var contact_normal: Vector3 = state.get_contact_local_normal(index)

		if not contact_normal.dot(Vector3.UP) == 0.0:
			continue

		if not contact_normal.dot(-velocity.normalized()) >= 0.0:
			continue

		velocity = velocity.slide(contact_normal)

	var impulse: Vector3 = (velocity - state.linear_velocity) * mass
	state.apply_central_impulse(impulse)
