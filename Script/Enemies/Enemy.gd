extends KinematicBody2D
class_name Enemy

export var ACCELERATION = 300
export var MAX_SPEED = 100
export var FRICTION = 200
export var WANDER_RANGE = 2

enum {
	IDLE,
	WANDER,
	CHASE
}
var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var max_hitpoints = 6

var state = IDLE

var portal_id = 0

export (NodePath) onready var stats = get_node(stats) as Node
export (NodePath) onready var hp_bar = get_node(hp_bar) as TextureRect
export (NodePath) onready var animationEnemy = get_node(animationEnemy) as AnimationPlayer
export (NodePath) onready var playerDetectionZone = get_node(playerDetectionZone) as Area2D
export (NodePath) onready var hurtBox = get_node(hurtBox) as Area2D
export (NodePath) onready var hitbox = get_node(hitbox) as Area2D
export (NodePath) onready var softCollision = get_node(softCollision) as Area2D
export (NodePath) onready var wanderController = get_node(wanderController) as Node2D

const Drop = preload("res://Scene/Enemies/Enemy_0.tscn")
var rng = RandomNumberGenerator.new()
var my_number

func _ready():
	state = pick_random_state([IDLE, WANDER])

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	_repellent()
	
	match state:
		IDLE:
			animationEnemy.play("Idle")
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			
			if wanderController.get_time_left() == 0:
				start_toward_random()
		WANDER:
			seek_player()
			
			if wanderController.get_time_left() == 0:
				start_toward_random()
				
			var direction = global_position.direction_to(wanderController.target_position)
			velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			
			if global_position.distance_to(wanderController.target_position) <= WANDER_RANGE:
				start_toward_random()
			
		CHASE:
			var player = playerDetectionZone.player
			if player != null :
#				var direction = (player.position - position).normalized()
#				var direction = (player.global_position - global_position).normalized()
				var direction = global_position.direction_to(player.global_position)
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
				animationEnemy.play("Attack")
			else: 
				animationEnemy.play("Idle")
				state = IDLE
				
			seek_player()
	
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	move()

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func start_toward_random():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_timer_wander(rand_range(1, 3))

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func enemyDeath():
	animationEnemy.play("Die")
	queue_free()

func move():
	velocity = move_and_slide(velocity)

func hurt_animate_finish():
	animationEnemy.play("Idle")
	state = IDLE

func _on_HurtBox_area_entered(area):
#	animationEnemy.play("Hurt")
	stats.health -= area.damage
	max_hitpoints = stats.health
	hp_bar.set_percent_value(max_hitpoints)
	knockback = area.knockback_vector * 210
	hurtBox.create_hit_effect()
	hurtBox.start_invincibility(0.4)


func _on_Stats_no_health():
#	animationEnemy.play("Die")
	var enemy_die_effect = load("res://Scene/Enemies/Enemy-1-DeathEffect.tscn")
	var enemy_death_effect = enemy_die_effect.instance()
	var world = get_tree().current_scene
	world.call_deferred("add_child", enemy_death_effect)
	enemy_death_effect.global_position = global_position
	yield(get_tree().create_timer(1), "timeout")
	
	var enemy_die_effect3 = load("res://Scene/Heart_Healer.tscn")
	var enemy_death_effect3 = enemy_die_effect3.instance()
	world.call_deferred("add_child", enemy_death_effect3)
	enemy_death_effect3.global_position = $Hide_1.global_position
	
	rng.randomize()
	my_number = rng.randi_range(0,75)
	if my_number <= 5:
		var drop = Drop.instance()
		world.call_deferred("add_child", drop)
		drop.position = $Hide_2.position
	
	enemyDeath()

func _on_HurtBox_invincible_started():
	animationEnemy.play("Hurt")

func _on_HurtBox_invincible_ended():
	animationEnemy.play("Stop")


func teleport_portal(area):
	for portal in get_tree().get_nodes_in_group("Portal_01"):
		if portal != area:
			if(portal_id == area.id):
				if (!portal.lockPortal):
					area.LockedPortal()
					global_position = portal.global_position


func _on_TransPort_Area_area_entered(area):
	if (area.is_in_group("Portal_01")):
		teleport_portal(area)

func _on_HurtBox2_area_entered(area):
	stats.health -= area.damage
	max_hitpoints = stats.health
	hp_bar.set_percent_value(max_hitpoints)
	hurtBox.fire_hurt_effect(0.05, 30)
	hurtBox.start_invincibility(0.4)


func _on_HurtBox2_invincible_ended():
	animationEnemy.play("Stop")

func _on_HurtBox2_invincible_started():
	animationEnemy.play("Hurt")

func _repellent():
	if Global.repellent == true:
		playerDetectionZone.monitoring = false
		hitbox.monitoring = false
	else:
		playerDetectionZone.monitoring = true
		hitbox.monitoring = true
		

func _exit_tree():
	self.queue_free()
