extends Area2D

var stats = PlayerStats
onready var exit_cm = $seek_player_exit/Label

func _ready():
	exit_cm.visible = false
	for key in InputMap.get_action_list("ui_drop"):
		if key is InputEventKey:
			exit_cm.text = String(OS.get_scancode_string(key.scancode))

func _process(_delta):
	if Global.take_sun_pow == true:
		$"Sun-broker-magic2".visible = false
	if exit_cm.visible == true and Input.is_action_just_pressed("ui_drop") and Global.take_sun_pow == true:
		exit_cm.visible = false
		$AnimationPlayer.play("active")

func _on_ExitSunRedMagic_body_entered(body):
	if body.name == "Player" and stats.canPick == true and stats.canPick2 == true and stats.canPick3 == true:
		Global.sun_broken = true
		Global.direction = body.teleport_vector
		Global.from = get_parent().name
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://World.tscn")
		Global.in_dungeon = false
		if Global.first_level:
			Effects.scene_changer.fade_out()
	if body.name == "Player" and stats.canPick == false or stats.canPick2 == false or stats.canPick3 == false and Global.take_sun_pow == true:
		exit_cm.visible = true


func _on_seek_player_exit_body_entered(body):
	if body.name == "Player" and stats.canPick == false or stats.canPick2 == false or stats.canPick3 == false and Global.take_sun_pow == true:
		exit_cm.visible = true


func _on_seek_player_exit_body_exited(body):
	if body.name == "Player" and stats.canPick == false or stats.canPick2 == false or stats.canPick3 == false and Global.take_sun_pow == true:
		exit_cm.visible = false
