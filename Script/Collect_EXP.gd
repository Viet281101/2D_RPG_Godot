extends KinematicBody2D

var max_speed = 60
var speed = 3.5
var player = null
var move = Vector2.ZERO


func _physics_process(_delta):
	move = Vector2.ZERO
	
	if player != null:
		move = position.direction_to(player.position) * max_speed
		$AnimationPlayer.play("idle")
	else:
		move = Vector2.ZERO
	
	move = move.normalized() * speed
	move = move_and_collide(move) 


func _ready():
	pass


func _on_experience_collect_area_entered(area):
	if (area.is_in_group("player_heart_collect")):
		call_deferred("queue_free")
#		queue_free()


func _on_seek_player_body_entered(body):
	if body != self:
		player = body

func _on_seek_player_body_exited(_body):
	player = null
