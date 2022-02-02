extends CanvasLayer

export (NodePath) onready var level_name = get_node(level_name) as Label
export (NodePath) onready var show_animate = get_node(show_animate) as AnimationPlayer

func _ready():
	if get_parent().name == "World":
		level_name.text = "The forest of Firefly"
		show_name()
	if get_parent().name == "MiniWorld1":
		level_name.text = "The dungeon of ancient civilization"
		show_name()
	if get_parent().name == "InsideSunRedMagic":
		level_name.text = "Temple of Helios"
		show_name()

func show_name():
	show_animate.play("ShowName")
	yield(show_animate, "animation_finished")
	queue_free()
