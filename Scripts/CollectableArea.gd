extends Collectable

func load_loot():
	loot.append("Rifle")
		
func interact(delta) -> void:
	$Icon.value += 30 * delta

	if $Icon.value == $Icon.max_value:
		set_process(false)
		interacted = true
		$Icon.hide()
		
		if gui.get_node("Inventory").pickup_item(loot[0]):
			get_parent().set_cell(tile[0], tile[1], id, false, false, false, tile_region + Vector2(0,1))
			queue_free()

