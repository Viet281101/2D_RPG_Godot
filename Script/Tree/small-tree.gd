extends Node2D

#const smallTreeEffect = preload("res://Scene/smal-tree-effect.tscn")
const Drop = preload("res://Scene/Collect_EXP.tscn")
var rng = RandomNumberGenerator.new()
var my_number

func create_tree_effect():
	var small_tree_effect = load("res://Scene/smal-tree-effect.tscn")
	var tree_effect = small_tree_effect.instance()
	var world = get_tree().current_scene
	world.call_deferred("add_child", tree_effect)
	tree_effect.global_position = global_position
	
	var enemy_die_effect = load("res://Scene/Enemy_0.tscn")
	var enemy_death_effect = enemy_die_effect.instance()
	world.call_deferred("add_child", enemy_death_effect)
	enemy_death_effect.global_position = $Hide_1.global_position


func _on_HurtBox_area_entered(_area):
	create_tree_effect()
	queue_free()


func _on_HurtBox_area_exited(_area):
	rng.randomize()
	my_number = rng.randi_range(0,20)
	if my_number <= 5:
		var world = get_tree().current_scene
		var drop = Drop.instance()
#		drop.type = rng.randi() % 2
		world.call_deferred("add_child", drop)
		drop.position = position
