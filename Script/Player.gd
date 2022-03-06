extends KinematicBody2D

enum {
	MOVE, TELEPORT, ATTACK, SKILL, COMBO, POWER_UP, GET_FIRE, TRANSITION
}

var state = MOVE
var velocity = Vector2.ZERO
var teleport_vector = Vector2.DOWN
var change_scene_vector = Vector2.UP

var stats = PlayerStats
var bullet = BulletUi
var game_data : Dictionary
var rng = RandomNumberGenerator.new()
var my_number
var current_interactable

var portal_id = 0
var heart_healer_id = 0

var max_var_exp = 10
var lv_up_var = rand_range(0,1)

export (NodePath) onready var animationPlayer = get_node(animationPlayer) as AnimationPlayer
export (NodePath) onready var animationTree = get_node(animationTree) as AnimationTree
onready var animationState = animationTree.get("parameters/playback")
export (NodePath) onready var HitBoxPlayer = get_node(HitBoxPlayer) as Area2D
export (NodePath) onready var hurtBox = get_node(hurtBox) as Area2D
export (NodePath) onready var BlinkAnimationPlayer = get_node(BlinkAnimationPlayer) as AnimationPlayer
export (NodePath) onready var exp_bar = get_node(exp_bar) as TextureRect
export (NodePath) onready var exp_ui = get_node(exp_ui) as Label
onready var damage_hitbox = HitBoxPlayer.damage

var cursor_target = load("res://assets/Items/cursor_target_right.png")

export( NodePath ) onready var interact_zone = get_node( interact_zone ) as Area2D
export( NodePath ) onready var interact_labels = get_node( interact_labels ) as Control

signal experience_gained(growth_data)
signal leveling_up(lv_up)

func _ready():
	randomize()
	stats.connect("no_health", self, "_player_death_function")
# warning-ignore:return_value_discarded
	Global.connect("item_dropped", self, "_on_item_dropped")
	Global.connect("get_experience_point", self, "_get_level")
	Global.connect("heal_player", self, "_on_healing_player")
	
	Global.player = self.name
	animationTree.active = true
	HitBoxPlayer.knockback_vector = teleport_vector
#	update_data()
	exp_ui.update_text(stats.level, stats.experience, stats.experience_required)

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		TELEPORT:
			teleport_state()
		ATTACK:
			attack_state()
		SKILL:
			skill_state()
		COMBO:
			combo_state()
		POWER_UP:
			power_up_state()
		GET_FIRE:
			get_fire_state()
		TRANSITION:
			transition_state()

############################## LEVEL UP SYSTEME ################################

# warning-ignore:shadowed_variable
func get_required_experience(level):
	return round(pow(level, 1.8) + level * 4)

func gain_experience(amount):
	stats.experience_total += amount
	stats.experience += amount
	var growth_data = []
	while stats.experience >= stats.experience_required:
		stats.experience -= stats.experience_required
		growth_data.append([stats.experience_required, stats.experience_required])
		level_up(1)
	growth_data.append([stats.experience, stats.experience_required])
	stats.growth_data = growth_data
	emit_signal("experience_gained", stats.growth_data)

func level_up(lv_up):
	stats.level += lv_up
	if stats.level <= 25 and (stats.level % 2 != 0):
		stats.max_health += 1
	stats.experience_required = get_required_experience(stats.level + 1)
	stats.MAX_SPEED += lv_up_var
	stats.TELEPORT_SPEED += lv_up_var
	rng.randomize()
	my_number = rng.randi_range(0,20)
	if my_number <= 5:
		stats.damage_hitbox += lv_up
	elif stats.level >= 5 and stats.damage_hitbox == 1:
		stats.damage_hitbox += lv_up
	elif stats.level >= 10 and stats.damage_hitbox == 2:
		stats.damage_hitbox += lv_up
	emit_signal("leveling_up", lv_up)
	_level_up_sign_effect()

func _get_level(var_exp):
	gain_experience(var_exp)
	max_var_exp += var_exp
#	exp_bar.set_percent_value(max_var_exp)
	exp_ui.update_text(stats.level, stats.experience, stats.experience_required)

func _level_up_sign_effect():
	var level_up_signal = load("res://Scene/UI/LevelUpSignal.tscn")
	var level_up = level_up_signal.instance()
	$playerSprite.add_child(level_up)
	level_up.global_position = global_position

############################ END OF LEVEL UP SYSTEME ###########################


func _process( _delta ):
	_invisible()
	if not current_interactable:
		var overlapping_area = interact_zone.get_overlapping_areas()
		if overlapping_area.size() > 0 and overlapping_area[ 0 ].has_method( "interact" ):
			current_interactable = overlapping_area[ 0 ]
			interact_labels.display( current_interactable )

func _input( event ):
	if event.is_action_pressed("ui_pick") and current_interactable:
		current_interactable.interact()


#State systeme function
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		teleport_vector = input_vector
		HitBoxPlayer.knockback_vector = input_vector
		Global.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Teleport/blend_position", input_vector)
		animationTree.set("parameters/PowerUp/blend_position", input_vector)
		animationTree.set("parameters/GetFire/blend_position", input_vector)
		
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * stats.MAX_SPEED, stats.ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, stats.FRICTION * delta)
	get_node("CollisionShape2D").disabled = false
	get_node("Heart_collect/CollisionShape2D").disabled = false
	move()
	
	if Input.is_action_just_pressed("ui_pick") or Input.get_action_strength("ui_pick"):
		if stats.canPick2 == false:
			_get_level(-1)
			state = GET_FIRE
		elif stats.canPick2 == true:
			_get_level(1)
			state = POWER_UP
	
	if Input.is_action_just_pressed("ui_teleport"):
		if stats.level >= 0:
			state = TELEPORT
		if Global.in_dungeon == true:
			state = MOVE
			move()
	if Input.is_action_just_pressed("ui_attack"):
		state = ATTACK
	if Input.is_action_just_pressed("ui_skill_1"):
		state = SKILL
	if Input.is_action_just_pressed("ui_combo"):
		if Global.in_dungeon == true:
			state = MOVE
			move()
		else:
			state = COMBO
			move()

func move():
	velocity = move_and_slide(velocity)

func transition():
	$Transition.start()
	teleport_vector = Global.direction
	state = TRANSITION

func attack_animation_finish():
	state = MOVE

func teleport_animation_finish():
	velocity = Vector2.ZERO
	state = MOVE

func combo_animation_finish():
	animationPlayer.play("Skill-1")
#	animationPlayer.play("Combo")
	state = MOVE

func teleport_state():
	velocity = teleport_vector * stats.TELEPORT_SPEED
	animationState.travel("Teleport")
	move()

func attack_state():
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func skill_state():
	velocity = Vector2.ZERO
	animationPlayer.play("Skill-1")

func combo_state():
	animationPlayer.play("Combo")
	yield($AnimationPlayer, "animation_finished")
	move()
	animationPlayer.play("Combo")
	yield($AnimationPlayer, "animation_finished")

func  power_up_state():
	animationState.travel("PowerUp")

func get_fire_state():
	animationState.travel("GetFire")

func transition_state():
	velocity = Global.direction * stats.MAX_SPEED
	animationTree.set("parameters/Run/blend_position", Global.direction)
	animationTree.set("parameters/Attack/blend_position", Global.direction)
	animationTree.set("parameters/Teleport/blend_position", Global.direction)
	animationState.travel("Run")
	move()

################################# HURT ########################################

func _on_HurtBox_area_entered(area):
	stats.health -= area.damage
	if stats.max_health >= 15:
		stats.max_health -= area.damage
	animationPlayer.play("Hurt")
	hurtBox.start_invincibility(0.6)
	hurtBox.create_hit_effect()

func _on_HurtBox_invincible_started():
	animationPlayer.play("Hurt")
#	BlinkAnimationPlayer.play("Start")

func _on_HurtBox_invincible_ended():
	BlinkAnimationPlayer.play("Stop")

############################### END OF HURT ####################################


################################ PORTAL ########################################

func teleport_portal(area):
	for portal in get_tree().get_nodes_in_group("Portal_01"):
		if portal != area:
			if(portal_id == area.id):
				if (!portal.lockPortal):
					area.LockedPortal()
					global_position = portal.global_position

func _on_Transport_Area_area_entered(area):
	if (area.is_in_group("Portal_01")):
		teleport_portal(area)

############################### END OF PORTAL ##################################

func _player_death_function():
	stats.canPick = false
	stats.canPick2 = false
	stats.canPick3 = false
	queue_free()

func _on_Heart_collect_area_entered(area):
	if (area.is_in_group("heart_collect")):
		if stats.health != stats.max_health:
			stats.health += 1
		elif stats.health == stats.max_health:
			stats.max_health += 0
			stats.health += 0
	if (area.is_in_group("Exp_collect")):
		_get_level(10)

func _on_healing_player(health):
	stats.health += health

func _on_Transition_timeout():
	animationTree.set("parameters/Idle/blend_position", Global.direction)
	animationState.travel("Idle")
	state = MOVE

########################## Item Interact #######################################

func _on_interactable_zone_area_exited(area):
	if current_interactable == area:
		if current_interactable.has_method("out_of_range"):
			current_interactable.out_of_range()
		interact_labels.hide()
		current_interactable = null

func _on_item_dropped(item):
	var floor_item = RessourceManager.tscn.floor_item.instance()
	floor_item.item = item
	get_parent().add_child(floor_item)
	floor_item.position = position

############################################### Using Repellent ###
func _invisible():
	if Global.repellent == true:
		self.modulate = Color(1,1,1,0.3)
	else:
		self.modulate = Color(1,1,1,1)

