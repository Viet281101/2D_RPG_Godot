class_name Item_Usable extends Node

# warning-ignore:unused_signal
signal start_cooldown(item_usable)
# warning-ignore:unused_signal
signal cooldown_tick(cooldown_remaining)
# warning-ignore:unused_signal
signal can_use_changed(can_use)

var unlimited_use = false
var cooldown = 1
var cooldown_remaining = 0
var is_in_cooldown = false
var can_use = false setget set_can_use
var can_always_use = false
var on_use_text = ""
var condition = ""

var item : Item


func _init(data, parent_item):
	item = parent_item
	set_data(data)
# warning-ignore:return_value_discarded
	item.connect("item_placed_in_player_inventory", self, "_on_item_placed_in_player_inventory")

func _process(delta):
	if is_in_cooldown:
		cooldown_remaining -= delta
		emit_signal("cooldown_tick", cooldown_remaining)
		
		if cooldown_remaining <= 0:
			is_in_cooldown = false

func set_data(data):
	if data.has("unlimited_use"):
		unlimited_use = data.unlimited_use
	if data.has("cooldown"):
		cooldown = data.cooldown

func set_can_use(value):
	can_use = value
	emit_signal("can_use_changed", get_can_use())

func get_can_use():
	return (can_use or can_always_use) and item.item_slot and item.item_slot.is_on_player and not is_in_cooldown

func use():
	if get_can_use():
		executed()

func executed():
	pass

func _on_item_placed_in_player_inventory(value):
	pass

