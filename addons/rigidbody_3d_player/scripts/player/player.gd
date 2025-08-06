class_name Player
extends RigidBody3D

@export_group("Camera")
@export var sensitivity: float
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
@export var neck: Node3D

var floor_angle: float = 0.0
var is_on_ceiling: bool = false
var is_on_slope: bool = false
var is_on_floor: bool = false
var wish_dir := Vector3.ZERO
var velocity := Vector3.ZERO
var floor_normal := Vector3.ZERO

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _process(_delta: float) -> void:
	wish_dir = Vector3(Input.get_axis("left", "right"), 0.0, Input.get_axis("forward", "back"))


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	is_on_ceiling = false
	is_on_slope = false
	is_on_floor = false

	var contact_count: int = state.get_contact_count()
	var normal_sum := Vector3.ZERO

	for index: int in contact_count:
		var contact_normal: Vector3 = state.get_contact_local_normal(index)

		is_on_ceiling = contact_normal.dot(Vector3.DOWN) == 1.0

		var contact_dot: float = contact_normal.dot(Vector3.UP)

		# Comparing against the actual value of max_slope_angle causes issues with movement on 
		# slopes that are of this exact angle. Adding a small value to it seems to negate this.
		if contact_dot > 0.0 and acos(contact_dot) <= deg_to_rad(max_slope_angle + 0.01):
			normal_sum += contact_normal

		if state.get_contact_collider_object(index) is RigidBody3D:
			continue

		if not contact_normal.dot(Vector3.UP) == 0.0:
			continue

		if not contact_normal.dot(-velocity.normalized()) >= 0.0:
			continue

		velocity = velocity.slide(contact_normal)

	floor_normal = normal_sum / contact_count if contact_count > 0 else Vector3.ZERO

	# Normalizing a Vector3.ZERO causes issues. Only normalize floor_normal if
	# it's a non-zero vector.
	if floor_normal.length() > 0.0:
		floor_normal = floor_normal.normalized()

	var normal_dot: float = floor_normal.dot(Vector3.UP)
	floor_angle = rad_to_deg(acos(normal_dot))

	is_on_slope = normal_dot > 0.0 and normal_dot < 1.0
	is_on_floor = normal_dot == 1.0 or is_on_slope

	var impulse: Vector3 = (velocity - state.linear_velocity) * mass
	state.apply_central_impulse(impulse)
