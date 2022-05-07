extends Chest

export (int) var number_of_items

func set_items():
	for nb in number_of_items:
		var item = Global.get_items(items[randi() % items.size()])
		
		if item.equipment_type != Game_Enums.EQUIPEMENT_TYPE.NONE:
			Global.generate_random_rarity(item, 100)
		
		item.quantity = item.stack_size
		inventory.add_item(item)
