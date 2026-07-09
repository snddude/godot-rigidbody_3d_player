@tool
@icon("res://addons/nbfsm/assets/sprites/icons/state_machine.svg")
class_name StateMachine
extends Node

signal state_changed(new_state_path: String)

@export var initial_state: State:
	set(value):
		initial_state = value

		if Engine.is_editor_hint():
			update_configuration_warnings()


var current_state: State = null


func _ready() -> void:
	if Engine.is_editor_hint():
		update_configuration_warnings()

	for child in get_children():
		if child is State:
			child.finished.connect(change_state)

	current_state = initial_state

	if owner != null:
		await owner.ready

	current_state.enter()


func _get_configuration_warnings() -> PackedStringArray:
	if initial_state == null:
		return ["StateMachine needs a reference to an initial State. Assign one in the inspector"]

	return []


func input_update(event: InputEvent) -> void:
	current_state.input_update(event)


func unhandled_input_update(event: InputEvent) -> void:
	current_state.unhandled_input_update(event)


func update(delta: float) -> void:
	current_state.update(delta)


func physics_update(delta: float) -> void:
	current_state.physics_update(delta)


func integrate_forces_update(state: PhysicsDirectBodyState3D) -> void:
	current_state.intergrate_forces_update(state)


func change_state(new_state_path: String) -> void:
	if not has_node(new_state_path):
		push_error("StateMachine %s missing %s state" % [name, new_state_path])
		return

	current_state.exit()
	current_state = get_node(new_state_path)
	current_state.enter()

	state_changed.emit(new_state_path)
