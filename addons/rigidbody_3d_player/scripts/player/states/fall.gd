class_name Fall
extends PlayerState


func enter() -> void:
	player.ceiling_check.enabled = true


func update(delta: float) -> void:
	var direction: Vector3 = (player.neck.global_basis * player.wish_dir).normalized()
	var rate: float = player.air_accel_rate if direction.length() > 0.0 else player.air_decel_rate

	player.velocity.x = lerp(player.velocity.x, direction.x * player.walk_speed, delta * rate)
	player.velocity.z = lerp(player.velocity.z, direction.z * player.walk_speed, delta * rate)

	if player.ceiling_check.is_colliding() and player.velocity.y > 0.0:
		player.velocity.y = 0.0

	player.velocity.y -= player.gravity * delta

	if player.is_on_floor and player.velocity.y < 0.0:
		finished.emit(IDLE)
