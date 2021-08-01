extends TextureRect

onready var icon_off = preload("res://Assets/Sprites/Icons/battle_off.png")
onready var icon_on = preload("res://Assets/Sprites/Icons/battle_on.png")

var agent = null

func start(ag):
	agent = ag
	agent.set_mode(agent.mode.BLOCKED)
	$AgentIcon.texture = agent.icon


func my_turn():
	texture = icon_on
	agent.set_mode(agent.mode.TURN)

func end_turn():
	texture = icon_off
	agent.set_mode(agent.mode.BLOCKED)
