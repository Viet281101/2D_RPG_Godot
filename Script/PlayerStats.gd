extends Node


var game_data : Dictionary

export var ACCELERATION = 500
export(float) var MAX_SPEED = 80
export(float) var TELEPORT_SPEED = 120
export var FRICTION = 500
export var damage_hitbox = 1

export(int) var max_health = 5 setget set_max_health
var health = max_health setget set_health
var player_life = true

export(int) var level = 0
var experience = 0
var experience_total = 0
var experience_required = get_required_experience(level + 1)

var canPick = true
var canPick2 = true
var canPick3 = true

var growth_data = []

# SIGNAL
signal no_health
signal health_changed(value)
signal max_health_changed(value)

signal experience_gained(growth_data)

#func _process(delta):
#	if health <= 0:
#		emit_signal("no_health")

func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)

func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")
		var player_die = load("res://Scene/GameOverTest.tscn")
		var player_death = player_die.instance()
		var world3 = get_tree().current_scene
		player_life = false
		world3.add_child(player_death)


func _ready():
	self.health = max_health
	update_data()

#level up systeme
# warning-ignore:shadowed_variable
func get_required_experience(level):
	return round(pow(level, 1.8) + level * 4)

func gain_experience(amount):
	experience_total += amount
	experience += amount
	while experience >= experience_required:
		experience -= experience_required
		growth_data.append([experience_required, experience_required])
		level_up(1)
	growth_data.append([experience, experience_required])
	emit_signal("experience_gained", growth_data)

func level_up(lv_up):
	level += lv_up
	max_health += 1
	experience_required = get_required_experience(level + 1)
#	var status = ['MAX_SPEED', 'TELEPORT_SPEED', 'damage_hitbox']
#	var random_status = status[randi() % status.size()]
#	set(random_status, get(random_status) + randi() % 4 + 2)

func update_data():
	game_data = {
		"player_data" : {
			"health" : health,
			"max_health": max_health,
			"speed": MAX_SPEED,
			"teleport_speed": TELEPORT_SPEED,
			"damage_hit": damage_hitbox,
			"pick_item_1": canPick,
			"pick_item_2": canPick2,
			"pick_item_3": canPick3
		},

		"level_data" : {
			"level": level,
			"experience": experience,
			"experience_total": experience_total,
			"experience_required": experience_required,
			"growth": growth_data
		}
	}
	var file = File.new()
	file.open("user://save_game.json", File.WRITE)
	var json = to_json(game_data)
	file.store_line(json)
	file.close()

func load_game():
	var file = File.new()
	if file.file_exists("user://save_game.json"):
		file.open("user://save_game.json", File.READ)
		game_data = parse_json(file.get_as_text())
		file.close()

func reset():
	canPick = true
	canPick2 = true
	canPick3 = true
	health = max_health
	player_life = true
	

func _exit_tree():
	self.queue_free()
