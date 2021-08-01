extends Control

onready var bt_icon = preload("res://PackageScenes/BattleIcon.tscn")
onready var map = get_tree().get_root().get_node("World/BattleMap")
onready var bt_skill = preload("res://PackageScenes/BtnSkill.tscn")

var turn = 0
var deads = []
var active = false

func start_battle():
	var party = get_tree().get_nodes_in_group("Party") + get_tree().get_nodes_in_group("Npc")
	active = true
	show()
	for i in party:
		var new = bt_icon.instance()
		new.start(i)
		$BattleParty.add_child(new)

	$BattleParty.get_child(turn).my_turn()
	get_parent().party_hide()
	
func _unhandled_input(event):
	if event.is_action_pressed("next_turn"):
		next_turn()
	
func next_turn():
	
	$BattleParty.get_child(turn).end_turn()
	turn += 1
	if turn >= $BattleParty.get_children().size():
		turn = 0 
	$BattleParty.get_child(turn).my_turn()
	
func clear_deads():
	for i in $BattleParty.get_children():
		if i.agent.life <= 0:
			deads.append(i.agent)
			i.queue_free()
			if check_victory():
				end_battle()
				
func check_victory():
	for i in $BattleParty.get_children():
		if i.agent.is_in_group("Enemy") and !(i.agent in deads):
			return false
	return true
	
func end_battle():
	active = false
	for i in $BattleParty.get_children():
		i.queue_free()
		
	clear_skills()
	hide()
	get_parent().party_show()
	
	var party = get_tree().get_nodes_in_group("Party")
	for i in party.size():
		if i == 0:
			party[i].set_mode(party[i].mode.FREE)
		else:
			party[i].set_mode(party[i].mode.FALLOWER)
	
	
func get_busy_cells():
	var cells = []
	for i in $BattleParty.get_children():
		cells.append(map.world_to_map(i.agent.position))
	return cells
	
func get_busy_enemy_cells():
	var cells = []
	for i in $BattleParty.get_children():
		if i.agent.is_in_group("Enemy"):
			cells.append(map.world_to_map(i.agent.position))
	return cells
	
func get_agent_in_cell(cell):
	for i in $BattleParty.get_children():
		if i.agent.in_cell(cell):
			return i.agent
	return null
	
func show_skills(skills, agent):
	clear_skills()
	var default = null
	for i in skills:
		var new_bt = bt_skill.instance()
		new_bt.start(i, agent)
		if default == null:
			default = new_bt
		$BattleSkills.add_child(new_bt)
	default.set_press()
		
func clear_skills():
	for i in $BattleSkills.get_children():
		i.queue_free()
	
	
