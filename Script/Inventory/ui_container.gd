extends Control

export (NodePath) onready var setting = get_node(setting) as Control
export (NodePath) onready var setting_btn = get_node(setting_btn) as Button
export (NodePath) onready var inventory_player = get_node(inventory_player) as Control
export (NodePath) onready var player_inventory_btn = get_node(player_inventory_btn) as Button
export (NodePath) onready var windows = get_node(windows) as CanvasLayer

var stats = PlayerStats

func _input(_event):
	if Input.is_action_just_pressed("ui_inventory") and stats.canPick == true and stats.canPick2 == true and stats.canPick3 == true:
		_on_player_inventory()

func _process(_delta):
	if Global.get_start == false:
		windows.set_layer(50)
	elif Global.get_start:
		windows.set_layer(5)
	if stats.canPick == false or stats.canPick2 == false or stats.canPick3 == false:
		_inventory_hide()
	else:
		_inventory_show()

func _on_setting_btn_pressed():
	if stats.canPick == true and stats.canPick2 == true and stats.canPick3 == true:
		_on_setting_menu()

func _on_Player_chest_pressed():
	if stats.canPick == true and stats.canPick2 == true and stats.canPick3 == true:
		_on_player_inventory()

func _on_player_inventory():
	inventory_player.visible = ! inventory_player.visible
	inventory_player.raise()

func _on_setting_menu():
	setting.visible = ! setting.visible
	setting.raise()

func _inventory_hide():
	hide()
	setting_btn.hide()
	player_inventory_btn.hide()
	setting.hide()
	inventory_player.hide()

func _inventory_show():
	show()
	setting_btn.show()
	player_inventory_btn.show()
