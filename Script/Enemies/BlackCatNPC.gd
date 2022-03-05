extends Area2D

var can_interact = false
var inputed = false
const DIALOG = preload("res://Scene/Enemies/DialogBox.tscn")

onready var hurtBox = $HurtBox

func _ready():
	pass 

func _physics_process(_delta):
	$AnimatedSprite.play("idle")

func _on_BlackCatNPC_body_entered(body):
	if body.name == "Player":
		$Label.visible = true
		can_interact = true

func _on_BlackCatNPC_body_exited(body):
	if body.name == "Player":
		$Label.visible = false
		can_interact = false

func _input(_event):
	if Input.is_key_pressed(KEY_E) and can_interact == true:
		$Label.visible = false
		var dialog = DIALOG.instance()
		get_parent().add_child(dialog)
		inputed = true
#	if Input.is_action_just_pressed("ui_accept"):
#		$AnimatedSprite.play("disapear")
#		queue_free()

func _on_Area2D_body_exited(_body):
#	var black_cat_disapear = load("res://Scene/BlackCatDisapear.tscn")
#	var black_cat_effect = black_cat_disapear.instance()
#	var world2 = get_tree().current_scene
#	world2.call_deferred("add_child", black_cat_effect)
#	black_cat_effect.global_position = global_position
#	queue_free()
	pass

func _on_HurtBox_area_entered(_area):
	var black_cat_disapear = load("res://Scene/Enemies/BlackCatDisapear.tscn")
	var black_cat_effect = black_cat_disapear.instance()
	var world = get_tree().current_scene
	world.call_deferred("add_child", black_cat_effect)
	black_cat_effect.global_position = global_position
	
	var black_cat_disapear2 = load("res://Scene/Heart_Healer.tscn")
	var black_cat_effect2 = black_cat_disapear2.instance()
	world.call_deferred("add_child", black_cat_effect2)
	black_cat_effect2.global_position = global_position
	
	if Global.current_level != "World" and inputed == false:
		var dialog = DIALOG.instance()
		get_parent().add_child(dialog)
	
	queue_free()
