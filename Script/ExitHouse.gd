extends Area2D

var stats = PlayerStats

func _ready():
	pass


func _on_ExitHouse_body_entered(body):
	if body.name == "Player" and stats.canPick == true and stats.canPick2 == true and stats.canPick3 == true:
		Global.direction = body.teleport_vector
		Global.from = get_parent().name
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://World.tscn")
		Global.in_dungeon = false
		if Global.first_level:
			Effects.scene_changer.fade_out()
