extends Control

export (NodePath) onready var setting = get_node(setting) as Control
export (NodePath) onready var inventory_player = get_node(inventory_player) as Control
export (NodePath) onready var windows = get_node(windows) as CanvasLayer


func _input(_event):
	if Input.is_action_just_pressed("ui_inventory"):
		_on_player_inventory()

func _process(_delta):
	if Global.get_start == false:
		windows.set_layer(50)
	elif Global.get_start:
		windows.set_layer(5)

func _on_setting_btn_pressed():
	setting.visible = ! setting.visible
	setting.raise()

func _on_Player_chest_pressed():
	_on_player_inventory()

func _on_player_inventory():
	inventory_player.visible = ! inventory_player.visible
	inventory_player.raise()
