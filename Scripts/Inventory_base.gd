extends Control

const item_base = preload("res://PackageScenes/ItemBase.tscn")

 
var item_held = null
var item_offset = Vector2()
var last_container = null
var last_pos = Vector2()
var local_loot = null

signal equipped_item(value)
signal unequipped_item(value)
signal item_quest_find(value)
signal item_add(value)
 
func _ready():
	pickup_item("Rifle")
	pickup_item("Rifle")

func _input(event):
	var cursor_pos = get_global_mouse_position()
	if event.is_action_pressed("inv_grab"):
		grab(cursor_pos)
	if event.is_action_released("inv_grab"):
		release(cursor_pos)
	if item_held != null:
		$GridBackPack.show_cells(item_held)
		$GridLoot.show_cells(item_held)
		item_held.rect_global_position = cursor_pos + item_offset
		
 
func grab(cursor_pos):
	var c = get_container_under_cursor(cursor_pos)
	if c != null and c.has_method("grab_item"):
		item_held = c.grab_item(cursor_pos)
	
		if is_instance_valid(item_held):
			if c == $GridLoot:
				local_loot.loot.erase(item_held.get_meta("id"))
				print("removi item do loot")
			last_container = c
			last_pos = item_held.rect_global_position
			item_offset = item_held.rect_global_position - cursor_pos
			move_child(item_held, get_child_count())
			$GridBackPack.show_cells(item_held)
 
func release(cursor_pos):
	if item_held == null:
		return
	var c = get_container_under_cursor(cursor_pos)
	if c == null:
		drop_item()
	elif c.has_method("insert_item"):

		if c.insert_item(item_held):
			if c == $GridLoot:
				print("coloquei item no loot")
				local_loot.loot.append(item_held.get_meta("id"))
			item_held = null
			$GridBackPack.hide_cells()
			$GridLoot.hide_cells()
		else:
			$GridBackPack.hide_cells()
			$GridLoot.hide_cells()
			return_item()
	else:
		$GridBackPack.hide_cells()
		$GridLoot.hide_cells()
		return_item()
   
func get_container_under_cursor(cursor_pos):
	var containers = [$GridBackPack, $EquipmentSlots, $InventoryBase, $GridLoot, $LootBase]
	for c in containers:
		if c.get_global_rect().has_point(cursor_pos):
			return c
	return null
 
func inv_show():
	show()
	$GridLoot.hide()
	
func inv_hide():
	hide()
	$GridLoot.hide()
	$GridLoot.clear_items()
	local_loot = null
	
func inv_loot_show(lt):
	show()
	add_loot(lt)
	$GridLoot.show()
	
func drop_item():
	$GridBackPack.hide_cells()
	item_held.queue_free()
	item_held = null
 
func return_item():
	item_held.rect_global_position = last_pos
	last_container.insert_item(item_held)
	item_held = null
	
func add_loot(loot):
	local_loot = loot
	for item_id in local_loot.loot:
		var item = item_base.instance()
		item.set_meta("id", item_id)
		item.texture = load(ItemDB.get_item(item_id)["icon"])
		add_child(item)
		
		if !$GridLoot.insert_item_at_first_available_spot(item):
			item.queue_free()
			
		elif ItemDB.get_item(item_id).has("type")  and ItemDB.get_item(item_id)["type"] == "QUEST":
			emit_signal("item_quest_find", item_id)
		emit_signal("item_add", item_id)
	
 
func pickup_item(item_id):
	var item = item_base.instance()
	item.set_meta("id", item_id)
	item.texture = load(ItemDB.get_item(item_id)["icon"])
	add_child(item)
	
	if !$GridBackPack.insert_item_at_first_available_spot(item):
		item.queue_free()
		return false
	if ItemDB.get_item(item_id).has("type")  and ItemDB.get_item(item_id)["type"] == "QUEST":
		emit_signal("item_quest_find", item_id)
	emit_signal("item_add", item_id)
	return true
	
func equip(item):
	emit_signal("equipped_item", item)
	
func unequip(item):
	emit_signal("unequipped_item", item)
