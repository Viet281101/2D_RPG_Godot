extends Control

export( NodePath ) onready var lbl_action = get_node( lbl_action ) as Label
export( NodePath ) onready var lbl_name = get_node( lbl_name ) as Label

func _ready():
	hide()
	lbl_name.rect_scale.x = 0.5
	lbl_name.rect_scale.y = 0.5
	for key in InputMap.get_action_list("ui_pick"):
		if key is InputEventKey:
			lbl_action.text = String(OS.get_scancode_string(key.scancode))

func display( interactable ):
	lbl_name.text = interactable.object_name
	show()
