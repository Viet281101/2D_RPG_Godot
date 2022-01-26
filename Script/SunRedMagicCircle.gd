extends Area2D

var stats = PlayerStats
onready var enterKey = $seek_player/EnterKey
var opened = false

func _ready():
	enterKey.visible = false
	for key in InputMap.get_action_list("ui_drop"):
		if key is InputEventKey:
			enterKey.text = String(OS.get_scancode_string(key.scancode))


func _on_SunRedMagicCircle_body_entered(body):
	if body.name == "Player" and Global.active_sun == false and stats.canPick == true and stats.canPick2 == true and stats.canPick3 == true:
		Global.direction = body.teleport_vector
		Global.from = get_parent().name
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Scene/InsideSunRedMagic.tscn")
		Global.in_dungeon = true
		Global.active_sun = true
#	if body.name == "Player" and Global.active_sun == true and Global.sun_broken == true:
#		$AnimationPlayer.play("break")

func _process(_delta):
#	if Input.is_action_just_pressed("ui_drop") and enterKey.visible == true and opened == false:
#		_opening_door()
#		enterKey.visible = false
#	if Input.is_action_just_pressed("ui_pick") and opened == true:
#		_open_finish()
#		enterKey.visible = true
	if Global.active_sun == true and Global.sun_broken == true:
		$AnimationPlayer.play("break")

func _close_finish():
	$AnimationPlayer.play("idle")

func _open_finish():
	$AnimationPlayer.play("close")
	opened = false

func _opening_door():
	$AnimationPlayer.play("open")
	opened = true

func _broken_finish():
	queue_free()

func _on_seek_player_body_entered(body):
	if body.name == "Player" and stats.canPick == true and stats.canPick2 == true and stats.canPick3 == true:
		enterKey.visible = false
		_opening_door()
	if body.name == "Player" and stats.canPick == false or stats.canPick2 == false or stats.canPick3 == false:
		enterKey.visible = true
		_close_finish()
