extends Area2D

var stats = PlayerStats
onready var exit_cm = $Label

func _ready():
	exit_cm.visible = false
	for key in InputMap.get_action_list("ui_drop"):
		if key is InputEventKey:
			exit_cm.text = String(OS.get_scancode_string(key.scancode))

func _process(_delta):
	if exit_cm.visible == true and Input.is_action_just_pressed("ui_drop"):
		exit_cm.visible = false
	if exit_cm.visible == false and Input.is_action_just_pressed("ui_pick"):
		exit_cm.visible = true

func _on_Exit_body_entered(body):
	if body.name == "Player" and stats.canPick == true and stats.canPick2 == true and stats.canPick3 == true:
		Global.direction = body.teleport_vector
		Global.from = get_parent().name
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://World.tscn")
		Global.in_dungeon = false
	if body.name == "Player" and stats.canPick == false or stats.canPick2 == false or stats.canPick3 == false:
		exit_cm.visible = true


func _on_Exit_body_exited(body):
	if body.name == "Player" and stats.canPick == false or stats.canPick2 == false or stats.canPick3 == false:
		exit_cm.visible = false
