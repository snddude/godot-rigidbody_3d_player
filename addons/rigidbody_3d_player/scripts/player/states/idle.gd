class_name Idle
extends PlayerState


func physics_update(delta: float) -> void:
	player.velocity = lerp(
			player.velocity, 
			Vector3.ZERO, 
			1.0 - exp(-player.floor_decel_rate * delta)
	)

	if not player.is_on_floor:
		finished.emit(FALL)
	elif player.wish_dir.length() > 0.0:
		finished.emit(WALK)
	elif Input.is_action_just_pressed("jump"):
		player.position.y += 0.1 # This is probably terrible, but it helps when jumping on slopes.
		player.velocity.y = player.get_jump_velocity()
		finished.emit(FALL)
