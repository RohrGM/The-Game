extends Control

onready var party = get_tree().get_nodes_in_group("Party")

func _ready():
	for i in get_children():
		i.connect("set_agent", self, "set_agent")
	set_agent(0)
		

func set_agent(agent):
	
	for i in range(party.size()):
		if i != agent:
			party[i].set_mode(party[i].mode.FALLOWER, party[agent])
		else:
			party[i].set_mode(party[i].mode.FREE)
