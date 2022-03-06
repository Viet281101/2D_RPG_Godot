extends Area2D

var stats = PlayerStats
onready var enterKey = $seek_player/EnterKey
var opened = false

func _ready():
#	$AnimationPlayer.play("close")
	enterKey.visible = false
	for key in InputMap.get_action_list("ui_drop"):
		if key is InputEventKey:
			enterKey.text = String(OS.get_scancode_string(key.scancode))


func _on_Entrance_body_entered(body):
	if body.name == "Player" and stats.canPick == true and stats.canPick2 == true and stats.canPick3 == true:
		Global.direction = body.teleport_vector
		Global.from = get_parent().name
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Scene/MiniWorld1.tscn")
		Global.in_dungeon = true
		if Global.first_level:
			Effects.scene_changer.fade_out()

func _process(_delta):
	if Input.is_action_just_pressed("ui_drop") and enterKey.visible == true and opened == false:
		_opening_door()
		enterKey.visible = false
	if Input.is_action_just_pressed("ui_pick") and opened == true:
		_open_finish()
		enterKey.visible = true

func _close_finish():
	$AnimationPlayer.play("idle")

func _open_finish():
	$AnimationPlayer.play("close")
	opened = false

func _opening_door():
	$AnimationPlayer.play("open")
	opened = true

func _on_seek_player_body_entered(body):
	if body.name == "Player" and stats.canPick == true and stats.canPick2 == true and stats.canPick3 == true:
		enterKey.visible = false
		_opening_door()
	if body.name == "Player" and stats.canPick == false or stats.canPick2 == false or stats.canPick3 == false:
		enterKey.visible = true
		_close_finish()


func _on_seek_player_body_exited(body):
	if body.name == "Player" and stats.canPick == true and stats.canPick2 == true and stats.canPick3 == true:
		enterKey.visible = false
		_open_finish()
	if body.name == "Player" and stats.canPick == false or stats.canPick2 == false or stats.canPick3 == false:
		enterKey.visible = false
		_close_finish()

