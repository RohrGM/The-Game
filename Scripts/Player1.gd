extends PlayerBase

func _ready():
	icon = preload("res://Assets/Players/player1_icon.png")
	attributes.str = 8
	attributes.const = 7
	attributes.dex = 4
	
	life += int(attributes.const * 1.5)
	
	battle_icon = "res://Assets/Sprites/Icons/blank.png"
	
	print("position ",position)

