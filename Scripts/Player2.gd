extends PlayerBase



func _ready():
	attributes.str = 5
	attributes.const = 5
	attributes.dex = 8
	
	life += int(attributes.const * 1.5)
	
	battle_icon = "res://Assets/Sprites/Icons/blank.png"
	
	weapon = {
		"damage": 5,
		"distance": 5,
		"cost": 1
	}
	
