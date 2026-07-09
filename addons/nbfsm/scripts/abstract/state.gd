@abstract
@icon("res://addons/nbfsm/assets/sprites/icons/state.svg")
class_name State
extends Node

signal finished(new_state_path: String)


func enter() -> void:
	pass


func input_update(event: InputEvent) -> void:
	pass


func unhandled_input_update(event: InputEvent) -> void:
	pass


func update(delta: float) -> void:
	pass


func physics_update(delta: float) -> void:
	pass


func intergrate_forces_update(state: PhysicsDirectBodyState3D) -> void:
	pass


func exit() -> void:
	pass
