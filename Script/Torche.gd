extends StaticBody2D

var actived = false

func _ready():
	$AnimationPlayer.play("null")

func _active_finish():
	$AnimationPlayer.play("idle")

func _on_seek_player_body_entered(body):
	if body.name == "Player" and actived == false:
		yield(get_tree().create_timer(0.1), "timeout")
		$AnimationPlayer.play("active")
		actived = true

