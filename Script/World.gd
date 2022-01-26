extends Node2D

var Health_ui = preload("res://Scene/HeartUI.tscn")
onready var scepter = preload("res://Scene/Scepter.tscn")
var scepter_picked = false


func _ready():
	randomize()
	Global.current_level = self.name
	var health = Health_ui.instance()
	add_child(health)
	if Global.current_level == "World" and Global.sun_actived == true:
		$ScepterApearPos.position = Global.scepter_pos
	active_magic_effect()
	if Global.from != null:
		get_node("YSort/" + Global.player).set_position(get_node(Global.from + "Pos").position)
		get_node("YSort/" + Global.player).transition()

func active_magic_effect():
	if Global.current_level == "World" and Global.take_sun_pow == true and Global.take_sun_pow == true and Global.sun_broken == true:
		var world = get_tree().current_scene
		var add_scepter = scepter.instance()
		world.add_child(add_scepter)
		$Scepter.position = $ScepterApearPos.position
		Global.scepter_pos = $ScepterApearPos.position
		Global.sun_actived = true
#		Global.take_sun_pow = false

func _input(_event):
	if Input.is_action_just_pressed("ui_pick") and PlayerStats.canPick2 == false and Global.current_level == "World":
		scepter_picked = true
	if Input.is_action_just_pressed("ui_drop") and scepter_picked == true and Global.current_level == "World":
			$ScepterApearPos.position = $YSort/Player.position
			Global.scepter_pos = $ScepterApearPos.position
			scepter_picked = false

func _exit_tree():
	self.queue_free()
