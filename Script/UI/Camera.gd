extends Camera2D

onready var topLeft = $Limit/TopLeft
onready var bottomRight = $Limit/BottomRight
export (NodePath) onready var camera_zoom = get_node(camera_zoom) as AnimationPlayer
export (NodePath) onready var light = get_node(light) as Light2D

func _ready():
	limit_top = topLeft.position.y
	limit_left = topLeft.position.x
	limit_bottom = bottomRight.position.y
	limit_right = bottomRight.position.x

func _input(_event):
	if Input.is_action_just_pressed("ui_view_map"):
		camera_zoom.play("view_map")
	if Input.is_action_just_pressed("ui_view_normal"):
		camera_zoom.play("normal")
	

