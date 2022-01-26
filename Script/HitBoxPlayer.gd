extends Area2D

var damage = 1
var knockback_vector = Vector2.ZERO


func _ready():
	damage = PlayerStats.damage_hitbox

func _on_Player_leveling_up(_lv_up):
	damage = PlayerStats.damage_hitbox
