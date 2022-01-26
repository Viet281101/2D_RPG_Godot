extends Node2D

onready var animated = $AnimationPlayer

func _ready():
	animated.play("die")


func _on_AnimationPlayer_animation_finished(_anim_name):
	var enemy_die_effect6 = load("res://Scene/Enemy_0.tscn")
	var enemy_death_effect6 = enemy_die_effect6.instance()
	var world = get_tree().current_scene
	world.call_deferred("add_child", enemy_death_effect6)
	enemy_death_effect6.global_position = $Hide_1.global_position
	queue_free()
