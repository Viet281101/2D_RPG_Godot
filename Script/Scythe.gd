class_name Scythe extends Area2D


const Comment_text = preload("res://Scene/TextBoxScythe.tscn")
var picked = false
var stats = PlayerStats
onready var light_label = $Label/Light2D
onready var hitbox = $HitBoxPivot/HitBox

func _ready():
	if Global.take_death_pow == true and Global.current_level != "World":
		self.position = Global.scythe_pos
	$Label.visible = false
	self.scale = Vector2(0.5, 0.5)
	for key in InputMap.get_action_list("ui_pick"):
		if key is InputEventKey:
			$Label.text = String(OS.get_scancode_string(key.scancode))

func _physics_process(_delta):
	hitbox.knockback_vector = Global.knockback_vector
	if picked == true:
		self.position = get_node("../Player/PositionPick").global_position
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
				if Global.take_death_pow == false:
					var text = Comment_text.instance()
					get_parent().add_child(text)
					Global.take_death_pow = true
				stats.canPick = false
				$AnimationPlayer.play("teleport")
				
	if Input.is_action_just_pressed("ui_drop") and picked == true:
		picked = false
		stats.canPick = true
		self.scale = Vector2(0.5, 0.5)
		if Global.current_level != "World":
			Global.scythe_pos = self.position
	
	if Input.is_action_just_pressed("ui_combo") and picked == true:
		$AnimationPlayer.play("Combo")
		$AnimationPlayer.play("Combo")
		_Label_invisible()

	if Input.is_action_just_pressed("ui_attack") and picked == true:
		$AnimationPlayer.play("Attack")
		_Label_invisible()

	if Input.is_action_just_pressed("ui_skill_1") and picked == true:
		$AnimationPlayer.play("Skill_1")
		_Label_invisible()
		yield(get_tree().create_timer(3), "timeout")

	if Input.is_action_just_pressed("ui_teleport") and picked == true:
		$AnimationPlayer.play("teleport")
		_Label_invisible()
		
	if Input.is_action_just_pressed("ui_mouse_left") and picked == true:
		_Label_invisible()

func _Label_invisible():
	$Label.visible = false
#	$Label.modulate = ("#00ffffff")
#	light_label.visible = false
#	light_label.modulate = ("00ffffff")

func _on_Area2D_body_entered(body):
	if body.name == "Player" and picked == false and stats.canPick == true:
		$Label.visible = true
#		$Label.modulate = ("#ff0000")
#		light_label.visible = true
#		light_label.modulate = ("ff0000")

func _on_Area2D_body_exited(body):
	if body.name == "Player" and picked == false:
		_Label_invisible()

func _exit_tree():
	self.queue_free()

