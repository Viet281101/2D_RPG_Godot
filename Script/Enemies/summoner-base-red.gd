extends StaticBody2D

var summon_time : float = rand_range(10, 18) # in seconds
onready var nbr = 0

func _ready():
#	$Timer.start(summon_time)
	pass
	

func _process(_delta):
	if nbr == 20:
		$Timer.stop()

func _desactive_summon():
	$AnimationPlayer.play("desactive")

func _desactive_summon_finish():
	$AnimationPlayer.play("idle")

func _call_red_enemies():
	var enemy_die_effect4 = load("res://Scene/Enemies/Enemy.tscn")
	var enemy_death_effect4 = enemy_die_effect4.instance()
	var world = get_tree().current_scene
	world.call_deferred("add_child", enemy_death_effect4)
	enemy_death_effect4.global_position = global_position


func _on_Timer_timeout():
	$AnimationPlayer.play("active")
	_call_red_enemies()
	nbr += 1

func _on_HurtBox_area_entered(_area):
	var enemy_die_effect2 = load("res://Scene/Enemies/EnemyExplosion.tscn")
	var enemy_death_effect2 = enemy_die_effect2.instance()
	var world = get_tree().current_scene
	world.call_deferred("add_child", enemy_death_effect2)
	enemy_death_effect2.global_position = global_position
	queue_free()

func _on_seek_player_body_entered(body):
	if body.name == "Player":
		$Timer.start(summon_time)
		$AnimationPlayer.play("active")
		_call_red_enemies()
		nbr += 1
