extends StaticBody2D

const Drop = preload("res://Scene/FireFly.tscn")
var rng = RandomNumberGenerator.new()
var my_number
var firefly_apear_time = rand_range(30, 55)
export (NodePath) onready var time = get_node(time) as Timer
onready var hurtBox = $HurtBox

func _ready():
	randomize()
	_summon_firefly()

func _summon_firefly():
	modulate = Color("ffffff")
	rng.randomize()
	my_number = rng.randi_range(0,50)
	if my_number <= 5:
		var drop = Drop.instance()
		var world = get_tree().current_scene
		world.call_deferred("add_child", drop)
		drop.position = global_position
	time.start(firefly_apear_time)

func _on_Timer_timeout():
	_summon_firefly()


func _on_HurtBox_area_entered(_area):
	hurtBox.fire_hurt_effect(0.05)
	hurtBox.start_invincibility(0.4)
	firefly_apear_time += 10
	modulate = Color("b4b4b4")
