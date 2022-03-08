class_name Item_Repellent extends Item_Usable

# warning-ignore:unused_signal
signal repellent(repellent_time)

var repellent

func _init(data, parent_item).(data, parent_item):
# warning-ignore:return_value_discarded
	self.connect("repellent", Global, "_on_repellent")
	on_use_text = "Make you invisible in %s second."
	condition = "Drink it now."
	can_always_use = true

func set_data(data):
	repellent = data.repellent
	.set_data(data)

func get_use_text():
	return on_use_text % repellent

func _on_has_experience_item(value):
	can_use = value

func executed():
	print("You are invisible in %s second" % repellent)
	if Global.repellent == false:
		emit_signal("repellent", repellent)
