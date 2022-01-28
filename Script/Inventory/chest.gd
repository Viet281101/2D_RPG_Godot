class_name Chest extends Area2D

export (int) var size = 1
export (String) var inventory_name
export (Array, String) var items

var inventory : Inventory
var action = "open"
var object_name = "Chest"

func _init():
	inventory = preload("res://Scene/InventorySysteme/inventory.tscn").instance()

func _ready():
	object_name = inventory_name
	inventory.size = size
	inventory.inventory_name = inventory_name
	set_items()

func set_items():
	for i in items:
		inventory.add_item(Global.get_items(i))

func interact():
	Global.emit_signal("inventory_opened", inventory)
	$Sprite.frame = 1

func out_of_range():
	if inventory.is_open:
		Global.emit_signal("inventory_closed", inventory)
		$Sprite.frame = 0
		$Sprite.self_modulate = ("bababa")
