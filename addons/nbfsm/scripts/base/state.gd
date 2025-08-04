class_name State
extends Node

signal finished(new_state_path: String)


func enter() -> void:
	pass


@warning_ignore("unused_parameter")
func input_update(event: InputEvent) -> void:
	pass


@warning_ignore("unused_parameter")
func update(delta: float) -> void:
	pass


@warning_ignore("unused_parameter")
func physics_update(delta: float) -> void:
	pass


func exit() -> void:
	pass
