extends Area2D

var picked = false
var stats = PlayerStats
var cursor_target = load("res://assets/Items/cursor-3.png")
onready var hitbox = $HitBoxPivot/HitBox

func _ready():
	self.scale = Vector2(0.5, 0.5)
	for key in InputMap.get_action_list("ui_pick"):
		if key is InputEventKey:
			$Label.text = String(OS.get_scancode_string(key.scancode))

func _physics_process(_delta):
	hitbox.knockback_vector = Global.knockback_vector
	if picked == true:
		self.position = get_node("../Player").global_position
		global_rotation += get_local_mouse_position().angle()
	if PlayerStats.player_life == false:
#		queue_free()
		picked = false

func _input(_event):
	if Input.is_action_just_pressed("ui_pick"):
		_Label_invisible()
		var bodies = $Area2D.get_overlapping_bodies()
		for body in bodies:
			if body.name == "Player" and stats.canPick == true:
				picked = true
				_Label_invisible()
				stats.canPick = false
				$AnimationPlayer2.play("teleport")
				
	if Input.is_action_just_pressed("ui_drop") and picked == true:
		picked = false
		stats.canPick = true
		self.scale = Vector2(0.5, 0.5)
	
	if Input.is_action_just_pressed("ui_mouse_left") and picked == true:
		laser_fire()
	if Input.is_action_just_released("ui_mouse_left") and picked == true:
		active_finished()

func _Label_invisible():
	$Label.visible = false

func _on_Area2D_body_entered(body):
	if body.name == "Player" and picked == false and stats.canPick3 == true:
		$Label.visible = true

func _on_Area2D_body_exited(body):
	if body.name == "Player" and picked == false:
		_Label_invisible()

func laser_fire():
	$AnimationPlayer.play("active")
	$LightningLaser/AnimationPlayer.play("beam")

func _exit_tree():
	self.queue_free()

func active_finished():
	$AnimationPlayer.play("idle")
	$LightningLaser/AnimationPlayer.play("idle")
