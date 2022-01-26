extends KinematicBody2D

# Damage
export(int) var damage = 6
export(int) onready var max_damage = damage * 5
export(float) var damage_multiplyer = 0.02
# Where to move varaiables
# ------------------------
onready var center = get_parent()
var move_dir = Vector2(0,0)
var move_to_pos = Vector2(0,0)
export(int) var max_distance_point = 25 # Maximum distance from move_to_pos (shouldn't be too big)
# ------------------------
var velocity = Vector2(0,0)
export(int) var max_speed = 5600
export(int) onready var friction = max_speed / 2
export(int) var acceleration = 800
var pos = Vector2(0,0)
# Rotation varaiables
# -------------------
export(float) var smooth_spd = 0.4
export(float) var rotate_speed = 5.0
export(int) var center_dis = 40 # In pixels
export(float) var max_rand_rotation = 0.1
var rand_rotation
# Varaibles for states
# --------------------
var is_moveing = true
var has_landed = false


func apply_velocity():
	velocity = move_and_slide(velocity)
#	print(get_local_mouse_position().distance_to(center.position))

func rotate_toward_mouse():
	global_rotation += get_local_mouse_position().angle() * smooth_spd

func rotate_around_center():
	global_position = get_target()

# Setting up the position it'll be moveing toward 
# and sets "has_landed" for states 
func setup_throw():
	move_to_pos = get_global_mouse_position()
	move_dir = (get_global_mouse_position() - global_position).normalized()
	pos = global_position
	has_landed = false


func rotate_when_thrown():
	global_rotation += rotate_speed
	
	

func move_to_throw_pos(delta):
	# Move if not at the cursor's remembered position
	# Else stop
	if global_position.distance_to(move_to_pos) >= max_distance_point:
		pos += move_dir * acceleration * delta
	else:
		velocity = velocity.move_toward(Vector2(0,0), friction)
		if velocity == Vector2(0,0):
			has_landed = true
	
	global_position = pos
	rotate_when_thrown()


# stay in position when LANDED
func setup_stay_at_pos():
	move_to_pos = global_position
func stay_at_pos():
	global_position = move_to_pos


func just_landed_effect():
	# particles, no damage
	pass
func landed_effect():
	# particles, if enemy enters an area then damage
	pass

func rotate_when_back_to_center():
	global_rotation -= rotate_speed
func back_to_center(delta):
	if global_position.distance_to(get_target()) >= max_distance_point / 2:
		move_dir = (get_target() - global_position).normalized()
		pos += move_dir * acceleration * delta
		rotate_when_back_to_center()
	else:
		# If i don't teleport it to the target, it might go back and forth 
		# towards the point, because it takes too big steps, 
		# but it's not visible for humans in my opinion
		pos = get_target()
	
	global_position = pos

func get_target(): # The target is the position wich I want to have it in the idle state
	var distance_to_mouse = get_global_mouse_position().distance_to(center.global_position)
	var direction
	if distance_to_mouse >= center_dis + 1:
		direction = global_position.direction_to(get_global_mouse_position()) * center_dis
#		print("bigger triggers! " + str(distance_to_mouse))
	else:
#		print("smaller triggers! " + str(distance_to_mouse))
		# This needs to be fixed
		# ----------------------
		# ----------------------
#		direction = global_position.direction_to(get_global_mouse_position()) * (center_dis / distance_to_mouse)
		direction = Vector2(0, center_dis).rotated(global_position.direction_to(get_global_mouse_position()).angle())
		# ----------------------
		# ----------------------
#		warp_mouse_pos(get_global_mouse_position() + global_position.direction_to(get_global_mouse_position()) * (center_dis + 1) / distance_to_mouse)
	var position_ = center.global_position + direction # * center_dis
	return position_


# Handling Damage dealt by the sword itself
#func SwordHitbox_area_entered(area):
#	if area.is_in_group("EnemyHitbox"):
#		if $SwordSpeed.speed != 0:
#			var dmg = min(damage + round(damage_multiplyer * $SwordSpeed.speed), max_damage)
#			area.get_parent().take_damage(dmg)

