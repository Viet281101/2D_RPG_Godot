extends CanvasLayer

const CHAR_READ_RATE = 0.05

onready var textbox_container = $TextBoxContainer
onready var start_symbol = $TextBoxContainer/MarginContainer/HBoxContainer/Start
onready var end_symbol = $TextBoxContainer/MarginContainer/HBoxContainer/End
onready var label = $TextBoxContainer/MarginContainer/HBoxContainer/Label


enum State {
	READY,
	READING,
	FINISH
}

var currant_state = State.READY

var text_queue = [
	"Use 'Attack', 'Skill' and 'Combo' with this Scythe!",
	"Remember his name is Scythe of the Death !"
]

func _ready():
	print("Starting state to: State.READY")
	hide_textbox()
#	queue_text("First Text queue up !")
#	queue_text("Second Text queue up !")
#	queue_text("Third Text queue up !")
#	queue_text("Fourth Text queue up !")


func _process(_delta):
	match currant_state:
		State.READY:
			if !text_queue.empty():
				display_text()
		State.READING:
			if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_attack") or Input.is_action_just_pressed("ui_combo") or Input.is_action_just_pressed("ui_skill_1") or Input.is_action_just_pressed("ui_pause") or Input.is_action_just_pressed("ui_pick"):
				label.percent_visible = 1.0
				$Tween.stop_all()
				end_symbol.text = "v"
				change_state(State.FINISH)
		State.FINISH:
			if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_attack") or Input.is_action_just_pressed("ui_combo") or Input.is_action_just_pressed("ui_skill_1") or Input.is_action_just_pressed("ui_pause") or Input.is_action_just_pressed("ui_pick"):
				change_state(State.READY)
				hide_textbox()
			if Input.is_action_just_pressed("ui_mouse_left"):
				change_state(State.READY)
				hide_textbox()


func queue_text(next_text):
	text_queue.push_back(next_text)

func hide_textbox():
	start_symbol.text = ""
	end_symbol.text = ""
	label.text = ""
	textbox_container.hide()

func show_textbox():
	start_symbol.text = "*"
	textbox_container.show()


func display_text():
	var next_text = text_queue.pop_front()
	label.text = next_text
	label.percent_visible = 0.0
	change_state(State.READING)
	show_textbox()
	$Tween.interpolate_property(label, "percent_visible", 0.0, 1.0, len(next_text) * CHAR_READ_RATE, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()


func _on_Tween_tween_all_completed():
	end_symbol.text = "v"
	change_state(State.FINISH)


func change_state(next_state):
	currant_state = next_state
	match currant_state:
		State.READY:
			print("Changing state to: State.READY")
		State.READING:
			print("Changing state to: State.READING")
		State.FINISH:
			print("Changing state to: State.FINISH")

