class_name StateMachine
extends Node

signal state_changed(new_state_path: String)

@export var initial_state: State

var current_state: State = null


func _ready() -> void:
	for child in get_children():
		if child is State:
			child.finished.connect(change_state)

	current_state = initial_state

	if owner:
		await owner.ready

	current_state.enter()


func _input(event: InputEvent) -> void:
	current_state.input_update(event)


func _process(delta: float) -> void:
	current_state.update(delta)


func _physics_process(delta: float) -> void:
	current_state.physics_update(delta)


func change_state(new_state_path: String) -> void:
	if not has_node(new_state_path):
		printerr('No such state "%s" in state machine "%s"'%[new_state_path, name])
		return

	current_state.exit()
	current_state = get_node(new_state_path)
	current_state.enter()

	state_changed.emit(new_state_path)
