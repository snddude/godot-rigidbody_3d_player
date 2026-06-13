class_name Player
extends RigidBody3D

const MIN_ROT_X: float = -90.0
const MAX_ROT_X: float = 90.0

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
@export var head: Node3D

var is_on_ceiling: bool = false
var is_on_slope: bool = false
var is_on_floor: bool = false
var experimental: bool = false
var wish_dir := Vector3.ZERO
var velocity := Vector3.ZERO
var ceiling_normal := Vector3.ZERO
var floor_normal := Vector3.ZERO


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		neck.rotation_degrees.y -= deg_to_rad(event.relative.x * sensitivity)
		head.rotation_degrees.x -= deg_to_rad(event.relative.y * sensitivity)
		head.rotation_degrees.x = clamp(head.rotation_degrees.x, MIN_ROT_X, MAX_ROT_X)

	if event.is_action_pressed("experimental"):
		experimental = not experimental


func _process(_delta: float) -> void:
	wish_dir = Vector3(Input.get_axis("left", "right"), 0.0, Input.get_axis("forward", "back"))


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	is_on_ceiling = false
	is_on_slope = false
	is_on_floor = false
	ceiling_normal = Vector3.ZERO
	floor_normal = Vector3.ZERO

	var contact_count: int = state.get_contact_count()
	var floor_contact_count: int = 0
	var ceiling_contact_count: int = 0
	var floor_normal_sum := Vector3.ZERO
	var ceiling_normal_sum := Vector3.ZERO

	for index: int in contact_count:
		var contact_normal: Vector3 = state.get_contact_local_normal(index)

		var contact_dot_down: float = contact_normal.dot(Vector3.DOWN)
		var contact_dot_up: float = contact_normal.dot(Vector3.UP)

		if contact_dot_down > 0.0:
			ceiling_normal_sum += contact_normal
			ceiling_contact_count += 1

		# Comparing against the actual value of max_slope_angle causes issues with movement on 
		# slopes that are of that exact angle. Adding a small value to it seems to negate them.
		if contact_dot_up > 0.0 and acos(contact_dot_up) <= deg_to_rad(max_slope_angle + 0.01):
			floor_normal_sum += contact_normal
			floor_contact_count += 1

		if state.get_contact_collider_object(index) is RigidBody3D:
			continue

		if not contact_normal.dot(Vector3.UP) == 0.0:
			continue

		if not contact_normal.dot(-velocity.normalized()) >= 0.0:
			continue

		# Slide along angled walls.
		var slid_velocity: Vector3 = velocity.slide(contact_normal)
		velocity.x = slid_velocity.x
		velocity.z = slid_velocity.z

	if ceiling_contact_count > 0:
		ceiling_normal = ceiling_normal_sum / ceiling_contact_count

	if floor_contact_count > 0:
		floor_normal = floor_normal_sum / floor_contact_count

	# Normalizing a vector that's near Vector3.ZERO may produce incorrect results.
	if not is_equal_approx(ceiling_normal.length(), 0.0):
		ceiling_normal = ceiling_normal.normalized()

	if not is_equal_approx(floor_normal.length(), 0.0):
		floor_normal = floor_normal.normalized()

	is_on_ceiling = ceiling_normal != Vector3.ZERO

	# Slide along ceilings.
	if is_on_ceiling and velocity.y > 0.0:
		velocity = velocity.slide(ceiling_normal)

	var normal_dot: float = floor_normal.dot(Vector3.UP)

	is_on_slope = normal_dot > 0.0 and normal_dot < 1.0
	is_on_floor = normal_dot == 1.0 or is_on_slope

	# Move along slopes.
	if is_on_slope:
		if experimental:
			var slid_velocity: Vector3 = velocity.slide(floor_normal)
			velocity.y = slid_velocity.y

			if velocity.y > 0.0:
				velocity.y = 0.0
			else:
				velocity.x = slid_velocity.x
				velocity.z = slid_velocity.z
		else:
			velocity = velocity.slide(floor_normal)

	state.set_linear_velocity(velocity)


func get_jump_velocity() -> float:
	return sqrt(2.0 * -get_gravity().y * (jump_height - 0.1))
