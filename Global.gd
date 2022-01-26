extends Node

onready var settingmenu = load("res://Scene/MenuGlobal.tscn")
onready var pausemenu = load("res://Scene/Pause.tscn")
var filepath = "res://keybinds.ini"
var configfile

var keybinds = {}
const ITEM_PATH = "res://Script/Inventory/items.json"
const AFFIXES_PATH = "res://Script/Inventory/affixes.json"
const RARE_NAMES_PATH = "res://Script/Inventory/rare_names.json"

onready var items = {}
onready var rare_names = {}
onready var affix_groups = {}
onready var placeholder = {
	Game_Enums.EQUIPEMENT_TYPE.HEAD: preload("res://assets/Iventory/placeholder_head.png"),
	Game_Enums.EQUIPEMENT_TYPE.CHEST: preload("res://assets/Iventory/placeholder_chest.png"),
	Game_Enums.EQUIPEMENT_TYPE.OFFHAND: preload("res://assets/Iventory/placeholder_offhand.png"),
	Game_Enums.EQUIPEMENT_TYPE.MAIN_HAND: preload("res://assets/Iventory/placeholder_main_hand.png")
}

var get_start = false
var see_credit = false
var current_level
var from
var direction = Vector2.ZERO
var player = "Player"
var in_dungeon = false
var active_sun = false
var sun_actived = false
var sun_broken = false
var take_sun_pow = false
var take_death_pow = false
var scepter_pos = Vector2(0,0)
var scythe_pos = Vector2(0,0)
var music_on = true
var knockback_vector = Vector2.ZERO

var is_paused = true
var paused_on = false
export (NodePath) onready var Music = get_node(Music) as AudioStreamPlayer

#Inventory Signal : 
# warning-ignore:unused_signal
signal inventory_opened(inventory)
# warning-ignore:unused_signal
signal inventory_closed( inventory )
# warning-ignore:unused_signal
signal inventory_ready(inventory)
# warning-ignore:unused_signal
signal player_inventory_ready(inventories)
# warning-ignore:unused_signal
signal ui_scale_changed(value)
# warning-ignore:unused_signal
signal item_picked( item, sender )
# warning-ignore:unused_signal
signal item_dropped( item )

func _init():
	randomize()

func _input(_event):
	if Input.is_key_pressed(KEY_INSERT):
		add_child(settingmenu.instance())
		if paused_on == true:
			pass
		if paused_on == false:
			get_tree().paused = true
	
	if Input.is_key_pressed(KEY_SPACE) and is_paused == true:
		add_child(pausemenu.instance())
		get_tree().paused = true
		paused_on = true
		is_paused = false
	if Input.is_key_pressed(KEY_SPACE) and is_paused == false:
		is_paused = false

func _ready():
	var file = File.new()
	# items
	file.open( ITEM_PATH, File.READ )
	items = parse_json(file.get_as_text())
	file.close()
	
	# names
	file.open( RARE_NAMES_PATH, File.READ )
	rare_names = parse_json(file.get_as_text())
	file.close()
	
	# affixes group
	file.open(AFFIXES_PATH, File.READ)
	var data = parse_json(file.get_as_text())
	for id in data:
		affix_groups[id] = Affix_Group.new(id, data[id])
	file.close()
	
	configfile = ConfigFile.new()
	if configfile.load(filepath) == OK:
		for key in configfile.get_section_keys("keybinds"):
			var key_value = configfile.get_value("keybinds", key)
			
			if str(key_value) != "":
				keybinds[key] = key_value
			else:
				keybinds[key] = null
	else:
		print("CONFIG FILE NOT FOUND")
		get_tree().quit()
	
	set_game_binds()

# Music Control
func play_music():
	Music.play()

func stop_music():
	Music.stop()

# Items Manager
func get_items(id : String) -> Item:
	return Item.new(id, items[id])

func get_placholder(id):
#	return placeholder[id]
	if id <= 1:
		return placeholder[id+1]
	else:
		return placeholder[id]

# Get random equipable item
func rng_generate_rarity(ilvl) -> Item:
	var valid_items_key = []
	for i in items:
		if items[ i ].has("type") and ilvl >= items[ i ].level and Game_Enums.EQUIPEMENT_TYPE[items[i].type] != Game_Enums.EQUIPEMENT_TYPE.NONE:
			valid_items_key.append( i )
	var item = get_items(valid_items_key[ randi() % valid_items_key.size()])
	return generate_rarity(item, ilvl)


func generate_rarity(item, ilvl) -> Item:
	item.components.base_stats.scale = randf()
	
	# Get random rarity
	var number_of_affixes = 0
	var rng = randf()
	if rng >= 0.99 and item.unique_data: # 1%
		item.rarity = Game_Enums.RARITY.UNIQUE
		roll_unique(item)
		return item
	elif rng >= 0.9: # 9%
		item.rarity = Game_Enums.RARITY.RARE
		number_of_affixes = (randi() % 3) + 3
		set_rare_name(item)
	elif rng >= 0.6: # 30%
		item.rarity = Game_Enums.RARITY.MAGIC
		number_of_affixes = (randi() % 2) + 1
	else:
		return item
	
	# Set the affixes
	var random_affix_group = get_random_affix_group(number_of_affixes, item.equipment_type, ilvl)
	var item_affix_list_data = []
	
	for affix_group in random_affix_group:
		var data = {
			"affix_group": affix_group.id,
			"affix": affix_group.get_random_affix(ilvl),
			"scale": randf()
		}
		item_affix_list_data.append(data)
	
	item.components["affix_list"] = Item_Affix_List.new(item_affix_list_data, item.rarity)
	return item


func get_random_affix_group(affix_amount, item_type, ilvl) -> Array:
	var valid_prefixes : Array = get_valid_affixes_group(Game_Enums.AFFIX_TYPE.PREFIX, item_type, ilvl)
	var valid_suffixes : Array = get_valid_affixes_group(Game_Enums.AFFIX_TYPE.SUFFIX, item_type, ilvl)
	
	valid_prefixes.shuffle()
	valid_suffixes.shuffle()
	
	var prefix_amount = int( floor(affix_amount / 2.0 ))
	var suffix_amount = prefix_amount
	
	if affix_amount % 2 == 1:
		if randi() % 2 == 1:
			prefix_amount += 1
		else:
			suffix_amount += 1
	
	valid_prefixes.resize(prefix_amount)
	valid_suffixes.resize(suffix_amount)
	
	var valid_affixes = []
	valid_affixes.append_array(valid_prefixes)
	valid_affixes.append_array(valid_suffixes)
	return valid_affixes


func get_valid_affixes_group(affix_type, item_type, ilvl):
	var valid_affixes : Array = []
	
	for id in affix_groups:
		if affix_groups[ id ].type == affix_type and ilvl >= affix_groups[ id ].affixes.values()[ 0 ].min_level and affix_groups[ id ].apply_to.has(item_type):
			valid_affixes.append( affix_groups[ id ])
	return valid_affixes


func set_rare_name(item):
	var type = Game_Enums.EQUIPEMENT_TYPE.keys()[item.equipment_type]
	var name_prefix_type = rare_names.prefix[type]
	var name_prefix = name_prefix_type[randi() % name_prefix_type.size()]
	var name_suffix_type = rare_names.suffix[type]
	var name_suffix = name_suffix_type[randi() % name_suffix_type.size()]
	item.item_name = name_prefix + " " + name_suffix


func roll_unique(item):
	var scales = []
	for s in item.unique_data.stats:
		scales.append( randf() )
	
	item.item_name = item.unique_data.name
	item.components["unique_stats"] = Item_Unique_Stats.new(item.unique_data.stats, scales)


# Key Blinds Control
func set_game_binds():
	for key in keybinds.keys():
		var value = keybinds[key]
		
		var actionList = InputMap.get_action_list(key)
		if actionList.empty():
			InputMap.action_erase_event(key, actionList[0])
		
		if value != null:
			var new_key = InputEventKey.new()
			new_key.set_scancode(value)
			InputMap.action_add_event(key, new_key)

func write_config():
	for key in keybinds.keys():
		var key_value = keybinds[key]
		if key_value != null:
			configfile.set_value("keybinds", key, key_value)
		else:
			configfile.set_value("keybinds", key, "")
	configfile.save(filepath)

func _exit_tree():
	self.queue_free()
