class_name Scepter extends Area2D


onready var Bullet_Player = preload("res://Scene/Artifact/Bullet_Player.tscn")
const Comment_text = preload("res://Scene/Artifact/TextBox.tscn")

var cursor_target = load("res://assets/Items/cursor-2.png")
var cursor_target_click = load("res://assets/Items/cursor.png")
var arrow_cursor = load("res://assets/Items/arrow-cursor.png")

export (NodePath) onready var light_label = get_node(light_label) as Label
onready var hitbox = $HitBoxPivot/HitBox
onready var light_fire = $Light
var stats = PlayerStats

var fire_time = false
var picked = false

export var bullet_number = 0
var bullet_speed = 1000

signal p_up 
signal p_down

func _ready():
	randomize()
	if Global.take_sun_pow == true and Global.current_level != "World":
		self.position = Global.scepter_pos
	light_label.visible = false
	self.scale = Vector2(0.5, 0.5)
	for key in InputMap.get_action_list("ui_pick"):
		if key is InputEventKey:
			light_label.text = String(OS.get_scancode_string(key.scancode))
#	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _physics_process(_delta):
	hitbox.knockback_vector = Global.knockback_vector
	flame_rotate()
	if picked == true:
		self.position = get_node("../YSort/Player/PositionPick2").global_position
#		_Label_invisible()
		global_rotation += get_local_mouse_position().angle()
	if PlayerStats.player_life == false:
		picked = false
		Input.set_custom_mouse_cursor(arrow_cursor)
		stats.canPick2 = true
#		queue_free()

func _input(_event):
	_bullet_limit_number()
	if Input.is_action_just_pressed("ui_pick"):
		_Label_invisible()
		var bodies = $Area2D.get_overlapping_bodies()
		for body in bodies:
			if body.name == "Player" and stats.canPick2 == true:
				picked = true
				Input.set_custom_mouse_cursor(cursor_target)
				light_label.visible = false
				stats.canPick2 = false
				$AnimationPlayer2.play("teleport")
				var text = Comment_text.instance()
				if Global.take_sun_pow == false and Global.current_level != "World":
					get_parent().add_child(text)
					Global.take_sun_pow = true
				
	if Input.is_action_just_pressed("ui_drop") and picked == true:
		picked = false
		stats.canPick2 = true
		Input.set_custom_mouse_cursor(arrow_cursor)
		self.scale = Vector2(0.5, 0.5)
		if Global.current_level != "World":
			Global.scepter_pos = self.position
	
	
	if Input.is_action_just_pressed("ui_pick") and picked == true:
		bullet_number += 1
		emit_signal("p_up")
		light_fire_on()
		Input.set_custom_mouse_cursor(cursor_target)
	

	if Input.is_action_just_pressed("ui_teleport") and picked == true:
		_Label_invisible()
		$AnimationPlayer2.play("teleport")
		_Label_invisible()

	if Input.is_action_just_pressed("ui_mouse_left") and picked == true and fire_time == true:
		fire()
		emit_signal("p_down")
		light_fire_on()
		Input.set_custom_mouse_cursor(cursor_target)
		
		
	if Input.is_action_just_pressed("ui_mouse_left") and picked == true and fire_time == false:
		light_fire_off()
		Input.set_custom_mouse_cursor(cursor_target_click)

func fire():
	var bullet = Bullet_Player.instance()
	bullet.position = $fireballpos.get_global_position()
	get_parent().add_child(bullet)
	bullet.look_at(get_global_mouse_position())
	bullet_number -= 1

func _on_Scepter_body_entered(body):
	if body.name == "Player" and picked == false and stats.canPick2 == true:
		light_label.visible = true

func _Label_invisible():
	light_label.visible = false

func _on_Scepter_body_exited(body):
	if body.name == "Player":
		light_label.visible = false

func _bullet_limit_number():
	if bullet_number > 0:
		fire_time = true
	if bullet_number <= 0:
		fire_time = false

func light_fire_on():
	if picked == true and fire_time == true:
		light_fire.visible = true
		if stats.level >= 15:
			$RetroExplosion.visible = true
			$fire.visible = false
		else:
			$RetroExplosion.visible = false
			$fire.visible = true
		_Label_invisible()

func light_fire_off():
	light_label.visible = true
	$fire.visible = false
	$RetroExplosion.visible = false
	light_fire.visible = false

func flame_rotate():
	if $fire.global_rotation != 0:
		$fire.global_rotation = 0

func _on_Area2D_body_entered(body):
	if body.name == "Player" and picked == false and stats.canPick2 == true:
		light_label.visible = true

func _exit_tree():
	self.queue_free()
