extends CanvasLayer

onready var buttoncontainer = get_node("Panel/VBoxContainer")
onready var buttonscript = load("res://KeyButton.gd")
var arrow_cursor = load("res://assets/Items/arrow-cursor.png")

var keybinds
var buttons = {}


func _ready():
	Input.set_custom_mouse_cursor(arrow_cursor)
	keybinds = Global.keybinds.duplicate()
	for key in keybinds.keys():
		var hbox = HBoxContainer.new()
		var label = Label.new()
		var button = Button.new()
		
		hbox.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		label.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		button.set_h_size_flags(Control.SIZE_EXPAND_FILL)
		
		label.text = key
		label.set( "custom_fonts/font", RessourceManager.font[8])
		label.align = Label.ALIGN_LEFT
		label.valign = Label.VALIGN_CENTER
		
		var button_value = keybinds[key]
		if button_value != null:
			button.text = OS.get_scancode_string(button_value)
		else:
			button.text = "Unassigned"
		
		button.set_script(buttonscript)
		button.key = key
		button.value = button_value
		button.menu = self
		button.toggle_mode = true
		button.focus_mode = Control.FOCUS_NONE
		button.set( "custom_fonts/font", RessourceManager.font[12])
		
		hbox.add_child(label)
		hbox.add_child(button)
		buttoncontainer.add_child(hbox)
		
		buttons[key] = button

func change_bind(key, value):
	keybinds[key] = value
	for k in keybinds.keys():
		if k != key and value != null and keybinds[k] == value:
			keybinds[k] = null
			buttons[k].value = null
			buttons[k].text = "Unassigned"



func _on_back_pressed():
	if Global.paused_on == true:
		pass
	if Global.paused_on == false:
		get_tree().paused = false
	queue_free()


func _on_save_pressed():
	Global.keybinds = keybinds.duplicate()
	Global.set_game_binds()
	Global.write_config()
	_on_back_pressed()



