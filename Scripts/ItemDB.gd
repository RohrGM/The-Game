extends Node

const ICON_PATH = "res://assets/Sprites/Items/"
const ITEMS = {
	"Rifle":{
		"icon": ICON_PATH + "rifle.png",
		"slot": "MAIN_HAND",
		"type": "RIFLE",
	},
#	"Wood Axe":{
#		"icon": ICON_PATH + "wood_axe.png",
#		"slot": "MAIN_HAND",
#		"type": "TWO_HANDS"
#	},
#	"Blueberry":{ 
#		"icon": ICON_PATH + "blueberry.png",
#		"slot": "FOOD",
#		"calories": 200
#	},
#	"Green Leaves":{ 
#		"icon": ICON_PATH + "green_leaves.png",
#		"slot": "NONE",
#	},
#	"Red Leaves":{ 
#		"icon": ICON_PATH + "red_leaves.png",
#		"slot": "NONE",
#	},
#	"Analgesico":{ 
#		"icon": ICON_PATH + "analgesic.png",
#		"slot": "NONE"
#	},
#	"Meat":{ 
#		"icon": ICON_PATH + "meat.png",
#		"slot": "FOOD",
#		"calories": 100
#	},
#	"Roast Meat":{ 
#		"icon": ICON_PATH + "roast_meat.png",
#		"slot": "FOOD",
#		"calories": 600
#	},
#	"Burnt Meat":{ 
#		"icon": ICON_PATH + "burnt_meat.png",
#		"slot": "FOOD",
#		"calories": 0
#	},
#	"Gear":{ 
#		"icon": ICON_PATH + "gear.png",
#		"slot": "NONE",
#		"type": "QUEST"
#	},
#	"Pistola":{ 
#		"icon": ICON_PATH + "pistol.png",
#		"slot": "MAIN_HANDS"
#	},
#	"Gravação":{ 
#		"icon": ICON_PATH + "data_tape.png",
#		"slot": "NONE"
#	},
#	"Matches":{ 
#		"icon": ICON_PATH + "matches.png",
#		"slot": "IGNITION"
#	},
#	"Mushroon":{ 
#		"icon": ICON_PATH + "mushroom1.png",
#		"slot": "FOOD",
#		"calories": 100
#	},
#	"Poison Mushroon":{ 
#		"icon": ICON_PATH + "mushroom2.png",
#		"slot": "FOOD",
#		"calories": -1
#	},
#	"Herbs Tea":{ 
#		"icon": ICON_PATH + "herbs_tea.png",
#		"slot": "FOOD",
#		"calories": 1
#	},
#	"Prepared Herb":{ 
#		"icon": ICON_PATH + "prepared_herb.png",
#		"slot": "NONE",
#	},
#	"Cloth":{ 
#		"icon": ICON_PATH + "cloth.png",
#		"slot": "NONE",
#	},
#	"Metal Pipe":{ 
#		"icon": ICON_PATH + "metal_pipe.png",
#		"slot": "MAIN_HAND",
#		"type": "TWO_HANDS"
#	},
#	"Stick":{ 
#		"icon": ICON_PATH + "stick.png",
#		"slot": "FUEL",
#	},
#	"Barbed Metal Pipe":{ 
#		"icon": ICON_PATH + "barbed_metal_pipe.png",
#		"slot": "MAIN_HAND",
#		"type": "TWO_HANDS"
#	},
#	"Bandage":{ 
#		"icon": ICON_PATH + "bandage.png",
#		"slot": "NONE",
#	},
#	"Barbed Wire":{ 
#		"icon": ICON_PATH + "barbed_wire.png",
#		"slot": "NONE",
#	},
#	"error":{
#		"icon": ICON_PATH + "error.png",
#		"slot": "NONE"
#	}
}
func get_item(id):
	if id in ITEMS:
		return ITEMS[id]
		
	return ITEMS["error"]
