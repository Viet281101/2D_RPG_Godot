class_name Item_Healing extends Item_Usable

var healing_amount

func _init(data, parent_item).(data, parent_item):
	Global.connect("player_life_changed", self, "_on_player_life_changed")
	on_use_text = "Heal %s life points."
	condition = "Need healing."
	can_always_use = true

func set_data(data):
	healing_amount = data.healing
	.set_data(data)

func get_use_text():
	return on_use_text % healing_amount

func _on_player_life_changed(health, max_health):
	can_use = health < max_health

func executed():
	Global.emit_signal("heal_player", healing_amount)
	print("Healing th player for %s life point!" % healing_amount)
	PlayerStats.health += healing_amount
