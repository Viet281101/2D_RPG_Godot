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



func create_heart_collect_effect():
	var heart_collect_effect = load("res://Scene/heart_collect.tscn")
	var heart_effect = heart_collect_effect.instance()
	var world = get_tree().current_scene
	world.call_deferred("add_child", heart_effect)
	heart_effect.global_position = global_position


func _on_Area2D_body_entered(body):
	if body != self:
		player = body

func _on_Area2D_body_exited(_body):
	player = null

func _on_heart_collect_body_exited(_body):
	$AnimationPlayer.play("idle")

func _on_heart_collect_area_entered(area):
	if (area.is_in_group("player_heart_collect")):
		$AnimationPlayer.play("collect")
		create_heart_collect_effect()
		queue_free()
