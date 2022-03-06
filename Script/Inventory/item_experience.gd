class_name Item_Experience extends Item_Usable

var experience

func _init(data, parent_item).(data, parent_item):
	Global.connect("has_experience_item", self, "_on_has_experience_item")
	on_use_text = "Get %s exp point."
	condition = "Drink it now."
	can_always_use = true

func set_data(data):
	experience = data.exp
	.set_data(data)

func get_use_text():
	return on_use_text % experience

func _on_has_experience_item(value):
	can_use = value

func executed():
	print("You get %s exp point!" % experience)
	Global.emit_signal("get_experience_point", experience)

