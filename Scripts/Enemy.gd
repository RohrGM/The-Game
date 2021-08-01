extends Base
class_name EnemyBase

enum mode{
	BLOCKED,
	FREE,
	TURN
}

var target = null
var current_mode = mode.FREE
var life = 10

func set_mode(md):
	current_mode = md
	match current_mode:
		mode.BLOCKED:
			position = center_block(position)
		mode.TURN:
			attributes.action_points = attributes.dex
			if attack_range(get_enemy().position):
				attack()
				print("alcance")
			else:
				print("fora de alcance")
				var pos = move_in_battle(get_enemy().position)
				if pos != null:
					attributes.action_points -= pos_in_range(center_block(pos), attributes.action_points)
					move_at(center_block(pos), "Run")
		
func _on_MoveAt_in_position():
	travel_anim("Idle")
	match current_mode:
		mode.TURN:
			if attributes.action_points > 0 and attack_range(get_enemy().position):
				attack()
				
#func get_distance(pos):
#	var nav = get_tree().get_root().get_node("World")
#	var path = nav.get_simple_path(position, pos, false)
#	path.remove(0)
#	return path.size()-1
		
func take_damage(value):
	life -= value
	var message = bt_message.instance()
	add_child(message)
	message.rect_global_position = global_position + Vector2(-46, -20)
	message.start(String(value))
	if life <= 0:
		life = 0
		dead()
		
func dead():
	battle.clear_deads()
	queue_free()
	
 #TURN FUNCTIONS###################################################################################


func pos_in_range(pos, distance):
	var nav = get_tree().get_root().get_node("World")
	var path = nav.get_simple_path(position, pos, false)
	path.remove(0)
	
	if path.size() -1 <= distance:
		return path.size()-1
	return 0
	
func move_in_battle(p):
	var cells_range = []
	var in_range = Vector2()
	var distance = .0
	
	var pos = position - Vector2(attributes.action_points, attributes.action_points) * 16
	for i in (attributes.action_points * 2 + 1):
		for j in (attributes.action_points * 2 + 1):
			if pos_in_range(pos + Vector2(i * 16, j * 16), attributes.action_points) > 0:
				var cell = map.world_to_map(pos + Vector2(i * 16, j * 16))
				if not cell in battle.get_busy_cells():
					cells_range.append(cell)
					
	if cells_range.size() > 0:
		in_range = cells_range[0]
		distance = map.map_to_world(in_range).distance_to(p)
		
		for i in cells_range:
			var d = map.map_to_world(i).distance_to(p)
			if distance > d:
				distance = d
				in_range = i
		return map.map_to_world(in_range)
	return null
	
func attack_range(p):
	var cells_range = []
	p = map.world_to_map(p)
	var pos = position - Vector2(weapon.distance, weapon.distance) * 16
	var my_pos = map.world_to_map(position)
	
	for i in (weapon.distance * 2 + 1):
		for j in (weapon.distance * 2 + 1):
			if pos_in_range(pos + Vector2(i * 16, j * 16), weapon.distance) > 0:
				var cell = map.world_to_map(pos + Vector2(i * 16, j * 16))
				if cell.x == my_pos.x or cell.y == my_pos.y:
					cells_range.append(cell)
	if p in cells_range:
		return true
	return false
	
func in_cell(cell):
	if map.world_to_map(position) == cell:
		return true
	return false

func get_enemy():
	if target == null:
		target = get_tree().get_nodes_in_group("Party")[0]
	return target
	
func attack():
	if attributes.action_points >= weapon.cost:
		attributes.action_points -= weapon.cost
		travel_anim("Attack")
	else:
		battle.next_turn()
		
func attack_test():
	if roll_dice(Vector2(1, 20)) > get_enemy().get_ca():
		get_enemy().take_damage(roll_dice(weapon.damage), self)
	else:
		var message = bt_message.instance()
		add_child(message)
		message.rect_global_position = global_position + Vector2(-46, -20)
		message.start("MISS")           

# warning-ignore:unused_argument
func _on_View_body_entered(body):
	match current_mode:
		mode.FREE:
			get_tree().get_root().get_node("World/GuiController/BattleManager").start_battle()
