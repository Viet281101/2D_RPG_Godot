extends Area2D

const HitEffect = preload("res://Scene/HitEffect.tscn")
const HitFireEffect = preload("res://Scene/RetroExplosion.tscn")

var invincible = false setget set_invincible

onready var timer = $Timer
onready var collisionShape = $CollisionShape2D

signal invincible_started
signal invincible_ended

func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal("invincible_started")
	else:
		emit_signal("invincible_ended")

func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

func create_hit_effect():
	var effect = HitEffect.instance()
	var main = get_tree().current_scene
	main.call_deferred("add_child", effect)
	effect.global_position = global_position

func fire_hurt_effect(scale_eff, pos_y):
	var effect = HitFireEffect.instance()
	var main = get_tree().current_scene
	main.call_deferred("add_child", effect)
	effect.global_position = global_position - Vector2(0, pos_y)
	effect.scale = Vector2(scale_eff, scale_eff)

func _on_Timer_timeout():
	self.invincible = false


func _on_HurtBox_invincible_started():
	set_deferred("monitorable", false)
#	collisionShape.set_deferred("disabled", true)


func _on_HurtBox_invincible_ended():
	monitorable = true
