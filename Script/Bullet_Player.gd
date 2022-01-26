extends Area2D

var vel = Vector2()
var speed = 3
var movement = Vector2()
onready var mouse_pos = null
onready var hitbox = $HitBox
onready var stats = PlayerStats


func _ready():
	mouse_pos = get_local_mouse_position()
	$AudioStreamPlayer.play()
#	$AnimationPlayer.play("fire")

func _process(_delta):
	hitbox.knockback_vector = Global.knockback_vector
	if stats.level <= 7:
		$Sprite.scale = Vector2(0.8, 0.8)
		$RetroExplosion.visible = false
	elif stats.level >= 8 and stats.level <= 14:
		$Sprite.scale = Vector2(1.0, 1.0)
		$RetroExplosion.visible = false
	elif stats.level >= 15:
		$Sprite.scale = Vector2(1.1, 1.1)
		$RetroExplosion.visible = true
		

func _physics_process(delta):
	hitbox.knockback_vector = Global.knockback_vector
	movement = movement.move_toward(mouse_pos, delta)
	movement = movement.normalized() * speed
	position = position + movement
#	look_at(get_global_mouse_position())
#	rotation += get_local_mouse_position().angle()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Bullet_Player_body_entered(_body):
	var bullet_explosion = load("res://Scene/FireBallExplosion.tscn")
	var explosion = bullet_explosion.instance()
	var world = get_tree().current_scene
	world.call_deferred("add_child", explosion)
	explosion.global_position = global_position
	if stats.level <= 7:
		explosion.scale = Vector2(1.0, 1.0)
	elif stats.level >= 8 and stats.level <= 14:
		explosion.scale = Vector2(1.1, 1.1)
	elif stats.level >= 15:
		explosion.scale = Vector2(1.2, 1.2)
	queue_free()


