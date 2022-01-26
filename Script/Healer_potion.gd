extends Area2D


func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player":
			$AnimationPlayer.play("collect")
			yield($AnimationPlayer,"animation_finished")
			emit_signal("coin_collected")
			set_collision_mask_bit(0, false)
			queue_free()
		else:
			$AnimationPlayer.play("idle")
