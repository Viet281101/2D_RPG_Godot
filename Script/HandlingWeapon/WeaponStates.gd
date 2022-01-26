extends StateMachine

onready var center_pos = parent.get_parent()
var has_attacked = false

func _ready():
	add_state("in_hand")
	add_state("thrown")
	add_state("moveing")
	add_state("just_landed")
	add_state("landed")
	add_state("call_back")
	call_deferred("set_state", states.in_hand)


func state_logic(delta):
	parent.apply_velocity()
	match state:
		states.in_hand:
			parent.rotate_toward_mouse()
			center_pos.rotate_to_mouse()
		states.thrown:
			parent.setup_throw()
		states.moveing:
			parent.move_to_throw_pos(delta)
		states.just_landed:
			parent.setup_stay_at_pos()
			parent.just_landed_effect()
		states.landed:
			parent.landed_effect()
			parent.stay_at_pos()
		states.call_back:
			center_pos.rotate_to_mouse()
			parent.back_to_center(delta)


func get_transition(_delta):
	if Input.is_action_just_pressed("ui_mouse_left"):
		has_attacked = true
	match state:
		states.in_hand:
			if has_attacked == true:
				has_attacked = false
				return states.thrown
		states.thrown:
			return states.moveing
		states.moveing:
			if parent.has_landed:
				return states.just_landed
		states.just_landed:
			return states.landed
		states.landed:
			if has_attacked == true:
				has_attacked = false
				return states.call_back
		states.call_back:
			if parent.global_position.distance_to(parent.get_target()) < parent.max_distance_point / 4:
				return states.in_hand
	return null

#func enter_state(_new_state, _old_state):
#	pass
#
#func exit_state(_old_state, _new_state):
#	pass
