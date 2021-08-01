extends TileMap

onready var loot = preload("res://PackageScenes/LootArea.tscn");

func _ready():
	var car_and_tent = get_used_cells_by_id(5);
	for tile in car_and_tent:
#		if get_cell_autotile_coord(tile[0], tile[1]) == Vector2(4, 0):
		var loot_area = loot.instance()
		add_child(loot_area)
		loot_area.position = map_to_world(tile) + Vector2(0, 10)
		loot_area.tile = tile
		loot_area.tile_region = get_cell_autotile_coord(tile[0], tile[1])
			
			
	for area in get_tree().get_nodes_in_group("LootArea"):
		pass

	
