extends TextureRect

const item_base = preload("res://PackageScenes/ItemBase.tscn")

var items = []
var cells = []
 
var grid = {}
var cell_size = 8
var grid_width = 0
var grid_height = 0
 
func _ready():
	var s = get_grid_size(self)
	grid_width = s.x
	grid_height = s.y 
	for x in range(grid_width):
		grid[x] = {}
		for y in range(grid_height):
			$TileMap.set_cellv(Vector2(x,y), 0)
			grid[x][y] = false

func find_item(item):
	for i in items:
		if item == i.get_meta("id"):
			return true
	return false
 
func insert_item(item):
	var item_pos = item.rect_global_position + Vector2(cell_size / 2, cell_size / 2)
	var g_pos = pos_to_grid_coord(item_pos)
	var item_size = get_grid_size(item)
	if is_grid_space_available(g_pos.x, g_pos.y, item_size.x, item_size.y):
		set_grid_space(g_pos.x, g_pos.y, item_size.x, item_size.y, true)
		item.rect_global_position = rect_global_position + Vector2(g_pos.x, g_pos.y) * cell_size
		items.append(item)
		return true
	else:
		return false
		
func show_cells(item):
	var item_pos = item.rect_global_position + Vector2(cell_size / 2, cell_size / 2)
	var g_pos = pos_to_grid_coord(item_pos)
	var item_size = get_grid_size(item)
	set_cell_space(g_pos.x, g_pos.y, item_size.x, item_size.y)
	
func hide_cells():
	for i in cells:
		if $TileMap.get_cellv(i) == 3:
			$TileMap.set_cellv(i, 1)
		elif $TileMap.get_cellv(i) == 2:
			$TileMap.set_cellv(i, 0)
	cells.clear()
 
func grab_item(pos):
	var item = get_item_under_pos(pos)
	if item == null:
		return null
   
	var item_pos = item.rect_global_position + Vector2(cell_size / 2, cell_size / 2)
	var g_pos = pos_to_grid_coord(item_pos)
	var item_size = get_grid_size(item)
	set_grid_space(g_pos.x, g_pos.y, item_size.x, item_size.y, false)
   
	items.remove(items.find(item))
	return item
 
func pos_to_grid_coord(pos):
	var local_pos = pos - rect_global_position
	var results = {}
	results.x = int(local_pos.x / cell_size)
	results.y = int(local_pos.y / cell_size)
	return results
 
func get_grid_size(item):
	var results = {}
	var s = item.rect_size
	results.x = clamp(int(s.x / cell_size), 1, 500)
	results.y = clamp(int(s.y / cell_size), 1, 500)
	return results
 
func is_grid_space_available(x, y, w ,h):
	if x < 0 or y < 0:
		return false
	if x + w > grid_width or y + h > grid_height:
		return false
	for i in range(x, x + w):
		for j in range(y, y + h):
			if grid[i][j]:
				return false
	return true
	
func set_cell_space(x, y, w, h):
	hide_cells()
	for i in range(x, x + w):
		for j in range(y, y + h):
			if $TileMap.get_cellv(Vector2(i,j)) == 1:
				$TileMap.set_cellv(Vector2(i,j), 3)
				cells.append(Vector2(i,j))
			elif $TileMap.get_cellv(Vector2(i,j)) == 0:
				$TileMap.set_cellv(Vector2(i,j), 2)
				cells.append(Vector2(i,j))
 
func set_grid_space(x, y, w, h, state):
	for i in range(x, x + w):
		for j in range(y, y + h):
			if state:
				$TileMap.set_cellv(Vector2(i,j), 1)
			else:
				$TileMap.set_cellv(Vector2(i,j), 0)
			grid[i][j] = state
 
func get_item_under_pos(pos):
	for item in items:
		if item.get_global_rect().has_point(pos):
			return item
	return null
 
func insert_item_at_first_available_spot(item):
	for y in range(grid_height):
		for x in range(grid_width):
			if !grid[x][y]:
				item.rect_global_position = rect_global_position + Vector2(x, y) * cell_size
				if insert_item(item):
					return true
	return false
