extends KinematicBody2D

export var FRICTION = 200

onready var Bullet = preload("res://Scene/Bullet.tscn")
onready var hurtBox = $HurtBox
onready var stats = $Stats
onready var hp_bar = $HP_Bar_2
onready var softCollision = $SoftCollision

var player = null
var move = Vector2.ZERO
var speed = 400

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var max_hitpoints = 18

const Drop = preload("res://Scene/Enemy.tscn")
var rng = RandomNumberGenerator.new()
var my_number

func _physics_process(delta):
	move = Vector2.ZERO
	
	if player != null:
		move = position.direction_to(player.position) * speed
	else:
		move = Vector2.ZERO
	
	move = move.normalized()
	move = move_and_collide(move)
	
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		player = body

func _on_Area2D_body_exited(_body):
	player = null

func fire():
	var bullet = Bullet.instance()
	bullet.position = get_global_position()
	bullet.player = player
	get_parent().add_child(bullet)
	$Timer.set_wait_time(1)

func _on_Timer_timeout():
	if player != null:
		fire()

func _on_HurtBox_area_entered(area):
	stats.health -= area.damage
	max_hitpoints = stats.health
	hp_bar.set_percent_value(max_hitpoints)
	knockback = Global.knockback_vector * 220
#	knockback = area.knockback_vector * 220
	hurtBox.create_hit_effect()
	hurtBox.start_invincibility(0.4)

func _on_Stats_no_health():
	var enemy_die_effect2 = load("res://Scene/Enemy2_death.tscn")
	var enemy_death_effect2 = enemy_die_effect2.instance()
	var world = get_tree().current_scene
	world.call_deferred("add_child", enemy_death_effect2)
	enemy_death_effect2.global_position = global_position
	
	var enemy_die_effect3 = load("res://Scene/Heart_Healer.tscn")
	var enemy_death_effect3 = enemy_die_effect3.instance()
	world.call_deferred("add_child", enemy_death_effect3)
	enemy_death_effect3.global_position = global_position
	
	rng.randomize()
	my_number = rng.randi_range(0,80)
	if my_number <= 5:
		var drop = Drop.instance()
		world.call_deferred("add_child", drop)
		drop.position = $Hide_2.position
	queue_free()

func _hurt_finish():
	$AnimationEnemy_2.play("Idle")

func _on_HurtBox_invincible_ended():
	$AnimationEnemy_2.play("Idle")

func _on_HurtBox_invincible_started():
	$AnimationEnemy_2.play("Hurt")

func _on_HurtBox2_area_entered(area):
	stats.health -= area.damage
	max_hitpoints = stats.health
	hp_bar.set_percent_value(max_hitpoints)
	hurtBox.fire_hurt_effect(0.2, 30)
	hurtBox.start_invincibility(0.4)

func _on_HurtBox2_invincible_started():
	$AnimationEnemy_2.play("Hurt")

func _on_HurtBox2_invincible_ended():
	$AnimationEnemy_2.play("Stop")

func _exit_tree():
	self.queue_free()
