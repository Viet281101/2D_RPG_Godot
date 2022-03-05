extends Node2D

onready var animatedSprite = $AnimatedSprite


func _ready():
	animatedSprite.frame = 0
	animatedSprite.play("animate")



func _on_AnimatedSprite_animation_finished():
	var enemy_die_effect = load("res://Scene/Enemies/Enemy_0.tscn")
	var enemy_death_effect = enemy_die_effect.instance()
	var world = get_tree().current_scene
	world.call_deferred("add_child", enemy_death_effect)
	enemy_death_effect.global_position = $Hide_1.global_position
	queue_free()

