extends Base

class_name PlayerBase

var fallow = null
var life = 10
var battle_icon = ""
var cell_hover = Vector2.ZERO
var cells_range = []
var current_target = null

onready var gui = get_tree().get_root().get_node("World/GuiController")

enum mode{
	BLOCKED,
	FREE,
	TURN,
	FALLOWER
}

var status = {
	"bleeding": 0,
	"poisoned": 0,
	"hungry": false
}

enum skills{
	MOVE,
	PUNCH
}

var current_mode = mode.FREE

# warning-ignore:unused_argument
func _physics_process(delta):
	
	if fallow != null:
		if position.distance_to(fallow.position) > 40:
			randomize()
			move_at(fallow.position + Vector2(int(rand_range(5, 15)),int(rand_range(5, 15))), "Run")

func _unhandled_input(event):
	
	match current_mode:
		mode.FREE:
			if event.is_action_pressed("left_click"):
				move_at(get_global_mouse_position(), "Run", 25)
				gui.hide_windows()
		mode.TURN:
			var pos = map.world_to_map(get_global_mouse_position())
			if pos in cells_range:
				if pos != cell_hover:
					if map.get_cellv(pos) == 0:
						if cell_hover in cells_range:
							map.set_cellv(cell_hover, 0)
						else:
							map.set_cellv(cell_hover, -1)
						cell_hover = pos
						map.set_cellv(cell_hover, 1)
					elif map.get_cellv(pos) == 3:
						if cell_hover in cells_range:
							map.set_cellv(cell_hover, 3)
						else:
							map.set_cellv(cell_hover, -1)
						cell_hover = pos
						map.set_cellv(cell_hover, 2)
						
			if event.is_action_pressed("left_click"):
				if map.get_cellv(cell_hover) == 2:
					attack(cell_hover)
					clear_cells()
				elif map.get_cellv(cell_hover) == 1:
					var new_pos = center_block(map.map_to_world(cell_hover))
					attributes.action_points -= pos_in_range(new_pos, attributes.action_points)
					move_at(center_block(new_pos), "Run")
					clear_cells()
		
func take_damage(value, enemy):
	travel_anim("Hit")
	life -= value
	
	var direction = Vector2(enemy.position.x - position.x, 0)
	update_anim_tree(direction)
	
	var message = bt_message.instance()
	add_child(message)
	message.rect_global_position = global_position + Vector2(-46, -20)
	message.start(String(value))
	if life <= 0:
		life = 0
		dead()
		
func dead():
	print("morri")

func _on_MoveAt_in_position():
	if current_mode != mode.FREE and current_mode != mode.FALLOWER:
		travel_anim("BtIdle")
	else:
		travel_anim("Idle")
	match current_mode:
		mode.TURN:
			if attributes.action_points > 0:
				show_move_range()
			else:
				battle.next_turn()
			

 #TURN FUNCTIONS###################################################################################

func in_cell(cell):
	if map.world_to_map(position) == cell:
		return true
	return false

func pos_in_range(pos, distance):
	var nav = get_tree().get_root().get_node("World")
	var path = nav.get_simple_path(position, pos, false)
	path.remove(0)
	
	if path.size() -1 <= distance:
		return path.size()-1
	return 0
	
func clear_cells():
	for i in cells_range:
		map.set_cellv(i, -1)
		
	cells_range = []
	
func show_move_range():
	clear_cells()
	var pos = position - Vector2(attributes.action_points, attributes.action_points) * 16
	for i in (attributes.action_points * 2 + 1):
		for j in (attributes.action_points * 2 + 1):
			if pos_in_range(pos + Vector2(i * 16, j * 16), attributes.action_points) > 0:
				var cell = map.world_to_map(pos + Vector2(i * 16, j * 16))
				if not cell in battle.get_busy_cells():
					cells_range.append(cell)
					map.set_cellv(cell, 0)
					
func show_attack_range():
	clear_cells()
	var pos = position - Vector2(weapon.distance, weapon.distance) * 16
	var my_pos = map.world_to_map(position)
	
	for i in (weapon.distance * 2 + 1):
		for j in (weapon.distance * 2 + 1):
			
			if pos_in_range(pos + Vector2(i * 16, j * 16), weapon.distance) > 0:
				var cell = map.world_to_map(pos + Vector2(i * 16, j * 16))
				if cell.x == my_pos.x or cell.y == my_pos.y:
					cells_range.append(cell)
					map.set_cellv(cell, 3)
	
	
func show_skill(sk):
	match sk:
		"MOVE":
			show_move_range()
		"PUNCH":
			show_attack_range()

func set_mode(md, agentF = null):
	set_physics_process(false)
	
	match current_mode:
		mode.TURN:
			clear_cells()
		mode.BLOCKED:
			clear_cells()
	
	current_mode = md

	match current_mode:
		mode.BLOCKED:
			move_at(center_block(position), "Run")
		mode.FREE:
			$Camera2D.current = true
			stop_move()
		mode.FALLOWER:
			set_physics_process(true)
			fallow = agentF
		mode.TURN:
			$Camera2D.current = true
			attributes.action_points = attributes.dex
			battle.show_skills(skills, self)

func attack(cell):
	current_target = battle.get_agent_in_cell(cell)
	if is_instance_valid(current_target) and weapon.cost <= attributes.action_points:
		attributes.action_points -= weapon.cost
		travel_anim("Punch")
		
func hit():
	if is_instance_valid(current_target):
		current_target.take_damage(roll_dice(weapon.damage))
		current_target = null
			
func end_attack():
	if battle.active:
		if attributes.action_points > 0 :
			show_attack_range()
		else:
			print("proximo")
			battle.next_turn()
	
		
		


