extends CanvasLayer

export var hearts = 4 setget set_hearts
export var max_hearts = 5 setget set_max_hearts

export (NodePath) onready var heartUIFull = get_node(heartUIFull) as TextureRect
export (NodePath) onready var heartUIEmpty = get_node(heartUIEmpty) as TextureRect
export (NodePath) onready var heart_multi_ui = get_node(heart_multi_ui) as Control
export (NodePath) onready var heart_multi_nbr = get_node(heart_multi_nbr) as Label

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if heartUIFull != null:
		heartUIFull.rect_size.x = hearts * 16

func set_max_hearts(value):
	max_hearts = max(value, 1)
	self.hearts = min(hearts, max_hearts)
	if heartUIEmpty != null:
		heartUIEmpty.rect_size.x = max_hearts * 16

func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
# warning-ignore:return_value_discarded
	PlayerStats.connect("health_changed", self, "set_hearts")
# warning-ignore:return_value_discarded
	PlayerStats.connect("max_health_changed", self, "set_max_hearts")
# warning-ignore:return_value_discarded
	Global.connect("repellent_time", self, "_on_repellent_time")
	heart_multi_ui.visible = false
	heart_multi_nbr.set("custom_colors/font_color", Color("8a0808"))

func _process(_delta):
	if hearts > 10 and max_hearts > 14:
		heartUIEmpty.visible = false
		heartUIFull.visible = false
		heart_multi_ui.visible = true
		heart_multi_nbr.text = String(hearts)
	else:
		heartUIEmpty.visible = true
		heartUIFull.visible = true
		heart_multi_ui.visible = false
		

###################################################### Countdown ###
func _on_repellent_time():
	if Global.repellent == true and Global.timer > 0:
		$Repellent.visible = true
		$Repellent.text    = str(Global.timer)
	else:
		$Repellent.visible = false
		Global.repellent   = false

