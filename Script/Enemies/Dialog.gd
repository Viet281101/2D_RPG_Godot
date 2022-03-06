extends Control

var dialog = ["Meoow, we meet again"]
var world_dialog = [
	"Hello and Welcome ! Just click ENTER to see all the dialog, that's important to you !!!",
	"Click 'Space' to open the Pause Menu and orther menu inside him,",
	"Hope that helps you to have a better playing time, and that's all",
	"I'm just a clone, so you can also kill me if you want, and how to kill me? Click 'Attack'! "
]
var sun_red_dialog = [
	"To get out of here, you need to drop this key (Scepter) into the circle of the sun.",
	"And that's what brought you here, watch out for the guards."
]
var mini_world_dialog = [
	"Maybe you don't know, that key (Scythe) is belong the death, so remember don't ever take it out of here",
	"I just warnning you this time."
]
var inside_magic_spell_dialog = [
	"This is the central corridor that connects to the magic circles in different areas.",
	"Be careful when entering them."
]

var dialog_index = 0
var finished = false

onready var text_dia = $RichTextLabel
onready var text_box = $TextureRect

func _ready():
	load_dialog()
	if Global.current_level == "World":
		dialog.append_array(world_dialog)
	elif Global.current_level == "InsideSunRedMagic":
		dialog.append_array(sun_red_dialog)
	elif Global.current_level == "MiniWorld1":
		dialog.append_array(mini_world_dialog)
	elif Global.current_level == "InsideMagicSpell":
		dialog.append_array(inside_magic_spell_dialog)

func _physics_process(_delta):
	$Ind.visible = finished
	if Input.is_action_just_pressed("ui_accept"):
		load_dialog()

func load_dialog():
	if dialog_index < dialog.size():
		finished = false
		text_dia.bbcode_text = dialog[dialog_index]
		text_dia.percent_visible = 0
		$Tween.interpolate_property(
			text_dia, "percent_visible", 0, 1, 1,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
		)
		$Tween.start()
	else:
		queue_free()
	dialog_index += 1


func _on_Tween_tween_completed(_object, _key):
	finished = true
