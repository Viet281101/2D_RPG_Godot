extends StaticBody2D

var actived = false
export (NodePath) onready var hurtBox = get_node(hurtBox) as Area2D
export (NodePath) onready var animation = get_node(animation) as AnimationPlayer

func _ready():
	animation.play("null")

func _active_finish():
	animation.play("idle")

func _on_seek_player_body_entered(body):
	if body.name == "Player" and actived == false:
		yield(get_tree().create_timer(0.1), "timeout")
		animation.play("active")
		actived = true

func _on_HurtBox_area_entered(_area):
	hurtBox.fire_hurt_effect(0.02, 0)
	hurtBox.start_invincibility(0.4)
	yield(get_tree().create_timer(0.1), "timeout")
	animation.play("active")
	actived = true
