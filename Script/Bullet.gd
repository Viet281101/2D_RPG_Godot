extends Area2D

var move = Vector2.ZERO
var look_vec = Vector2.ZERO
var player = null
var speed = 4
var life_time = rand_range(2, 4)

func _ready():
#	$Sprite.frame = 0
	$Sprite.play("run")
	look_vec = player.position - global_position
	$Timer.start(life_time)


func _physics_process(delta):
	move = Vector2.ZERO
	
	move = move.move_toward(look_vec, delta)
	move = move.normalized() * speed
	position += move


func _on_VisibilityNotifier2D_screen_exited():
	_explosion()


func _on_VisibilityNotifier2D_viewport_exited(_viewport):
	_explosion()


func _on_HurtBox_body_entered(body):
	if body.name == "Player":
		_explosion()

func _on_Bullet_body_entered(_body):
	_explosion()
#	print("DISAPEAR!!!!")


func _on_Timer_timeout():
	_explosion()

func _explosion():
	var bullet_explosion = load("res://Scene/BulletExplosion.tscn")
	var explosion = bullet_explosion.instance()
	var world = get_tree().current_scene
	world.call_deferred("add_child", explosion)
	explosion.global_position = global_position
	queue_free()
