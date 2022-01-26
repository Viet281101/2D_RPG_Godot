extends Position2D

export(float) var smooth_speed = 0.4

func rotate_to_mouse():
	global_rotation += get_local_mouse_position().angle() * smooth_speed

func reset_rotation():
	global_rotation = 0

