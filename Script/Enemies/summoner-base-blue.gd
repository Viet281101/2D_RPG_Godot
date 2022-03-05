extends StaticBody2D

export(float) var summon_time = rand_range(10, 18) # in seconds
onready var nbr = 6

func _ready():
	pass 

func _process(_delta):
	if nbr == 0:
		$Timer.stop()
		queue_free()

func _desactive_summon():
	$AnimationPlayer.play("disactive")

func _desactive_summon_finish():
	$AnimationPlayer.play("idle")

func _call_blue_enemies():
	var enemy_die_effect4 = load("res://Scene/Enemies/Enemy_2.tscn")
	var enemy_death_effect4 = enemy_die_effect4.instance()
	var world = get_tree().current_scene
	world.call_deferred("add_child", enemy_death_effect4)
	enemy_death_effect4.global_position = $SummonPos.global_position

func _on_seek_player_body_entered(body):
	if body.name == "Player":
		$Timer.start(summon_time)
		$AnimationPlayer.play("active")
		_call_blue_enemies()
		nbr -= 1

func _on_Timer_timeout():
	$AnimationPlayer.play("active")
	_call_blue_enemies()
	nbr -= 1
