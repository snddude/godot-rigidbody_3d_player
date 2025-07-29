class_name Idle
extends PlayerState


func enter() -> void:
	player.ceiling_check.enabled = false


func physics_update(delta: float) -> void:
	player.velocity = lerp(player.velocity, Vector3.ZERO, delta * player.floor_decel_rate)

	if not player.is_on_floor:
		finished.emit(FALL)
	elif player.wish_dir.length() > 0.0:
		finished.emit(WALK)
	elif Input.is_action_just_pressed("jump"):
		player.velocity.y = sqrt(2.0 * player.gravity * player.jump_height)
		finished.emit(FALL)
