class_name Walk
extends PlayerState


func enter() -> void:
	player.ceiling_check.enabled = false


func physics_update(delta: float) -> void:
	var direction: Vector3 = (player.neck.global_basis * player.wish_dir).normalized()

	player.velocity.x = lerp(player.velocity.x, 
			direction.x * player.walk_speed, 
			1.0 - exp(-player.floor_accel_rate * delta))
	player.velocity.z = lerp(player.velocity.z, 
			direction.z * player.walk_speed, 
			1.0 - exp(-player.floor_accel_rate * delta))

	if player.is_on_slope:
		player.velocity = player.velocity.slide(player.floor_normal)

		if player.velocity.length() > player.walk_speed:
			player.velocity = player.velocity.normalized() * player.walk_speed
	else:
		player.velocity.y = 0.0

	if player.wish_dir.length() == 0.0:
		finished.emit(IDLE)
	elif not player.is_on_floor:
		finished.emit(FALL)
	elif Input.is_action_just_pressed("jump"):
		player.velocity.y = sqrt(2.0 * player.gravity * player.jump_height)
		finished.emit(FALL)
