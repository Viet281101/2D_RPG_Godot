extends KinematicBody2D


export var FRICTION = 200

export (NodePath) onready var hurtBox = get_node(hurtBox) as Area2D
export (NodePath) onready var hitbox = get_node(hitbox) as Area2D
export (NodePath) onready var stats = get_node(stats) as Node
export (NodePath) onready var softCollision = get_node(softCollision) as Area2D
export (NodePath) onready var playerDetectionZone = get_node(playerDetectionZone) as Area2D

var player = null
var move = Vector2.ZERO
var speed = 600

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

const Drop = preload("res://Scene/Collect_EXP.tscn")
var rng = RandomNumberGenerator.new()
var my_number

func _physics_process(delta):
	_repellent()
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
	if body != self:
		player = body

func _on_Area2D_body_exited(_body):
	player = null

func _on_HurtBox_area_entered(area):
	stats.health -= area.damage
	knockback = Global.knockback_vector * 180
#	knockback = area.knockback_vector * 180
	hurtBox.create_hit_effect()
	hurtBox.start_invincibility(0.4)

func _on_Stats_no_health():
	var enemy_die_effect3 = load("res://Scene/Enemies/Enemy_0_DeathEffect.tscn")
	var enemy_death_effect3 = enemy_die_effect3.instance()
	var world = get_tree().current_scene
	world.call_deferred("add_child", enemy_death_effect3)
	enemy_death_effect3.global_position = global_position
	
	rng.randomize()
	my_number = rng.randi_range(0,65)
	if my_number <= 5:
		var drop = Drop.instance()
		world.call_deferred("add_child", drop)
		drop.position = position
	
	queue_free()

func _on_HurtBox_invincible_ended():
	$AnimationPlayer.play("idle")

func _on_HurtBox_invincible_started():
	$AnimationPlayer.play("hurt")

func _on_HurtBox2_area_entered(area):
	stats.health -= area.damage
	hurtBox.fire_hurt_effect(0.005, 12)
	hurtBox.start_invincibility(0.4)
#	print(area.damage)

func _on_Area2D2_body_entered(_body):
	queue_free()
#	print("DISAPEAR")

func _repellent():
	if Global.repellent == true:
		playerDetectionZone.monitoring = false
		hitbox.monitoring = false
	else:
		playerDetectionZone.monitoring = true
		hitbox.monitoring = true

func _exit_tree():
	self.queue_free()
