class_name Walk
extends PlayerState


func physics_update(delta: float) -> void:
	var direction: Vector3 = (player.neck.global_basis * player.wish_dir).normalized()

	player.velocity.x = lerp(
			player.velocity.x, 
			direction.x * player.walk_speed, 
			1.0 - exp(-player.floor_accel_rate * delta)
	)
	player.velocity.z = lerp(
			player.velocity.z, 
			direction.z * player.walk_speed, 
			1.0 - exp(-player.floor_accel_rate * delta)
	)

	# If the player is on a slope they can move quicker than desired.
	if player.velocity.length() > player.walk_speed:
		player.velocity = player.velocity.normalized() * player.walk_speed

	if player.wish_dir.length() == 0.0:
		finished.emit(IDLE)
	elif not player.is_on_floor:
		finished.emit(FALL)
	elif Input.is_action_just_pressed("jump"):
		player.position.y += 0.1 # This is probably terrible, but it helps when jumping on slopes.
		player.velocity.y = player.get_jump_velocity()
		finished.emit(FALL)
