class_name Resource_Manager extends Node

const STAT_PATH = "res://Script/Inventory/stats.json"

var sprites = {
	"chestplate": preload("res://assets/Iventory/chestplate.png"),
	"golden_armor": preload("res://assets/Iventory/golden_armor.png"),
	"helmet": preload("res://assets/Iventory/helmet.png"),
	"shield": preload("res://assets/Iventory/shield-item.png"),
	"tshirt": preload("res://assets/Iventory/t-shirt.png"),
	"sword_stock": preload("res://assets/Iventory/sword-stock-nva.png"),
	"potion_red": preload("res://assets/Iventory/PotionRed.png"),
	"potion_green": preload("res://assets/Iventory/PotionGreen.png"),
	"potion_blue": preload("res://assets/Iventory/PotionBlue.png"),
	"potion_purple": preload("res://assets/Iventory/Potion.png"),
	"stone": preload("res://assets/Iventory/Stone.png"),
	"wood": preload("res://assets/Iventory/Wood.png"),
	"axe": preload("res://assets/Iventory/Axe.png"),
	"pickaxe": preload("res://assets/Iventory/Pickaxe.png"),
	"holy_graill": preload("res://assets/Iventory/holy_graill.png")
}

var font = {
	8: preload("res://assets/Font_Textur/font_8.tres"),
	12: preload("res://assets/Font_Textur/font_12.tres")
}

var colors = {
	Game_Enums.RARITY.NORMAL: Color("515151"),
	Game_Enums.RARITY.MAGIC: Color("006ac2"),
	Game_Enums.RARITY.RARE: Color("451361"),
	Game_Enums.RARITY.UNIQUE: Color("930d0d")
}

var tscn = {
	"splitter": preload("res://Scene/InventorySysteme/splitter.tscn"),
	"hotbar_slot": preload("res://Scene/InventorySysteme/hotbar_slot.tscn"),
	"floor_item": preload("res://Scene/InventorySysteme/floor_item.tscn")
}

var stat_info = {}

func _ready():
	var file = File.new()
	file.open(STAT_PATH, File.READ)
	var data = parse_json(file.get_as_text())
	
	for stat in data:
		stat_info[Game_Enums.STAT[stat]] = data[stat]
	
	file.close()

func _exit_tree():
	self.queue_free()
