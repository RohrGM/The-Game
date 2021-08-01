extends Button

var gp = preload("res://PackageScenes/new_buttongroup.tres")
var skill = null
var agent = null

func start(tp, ag):
	agent = ag
	skill = tp
	group = gp
	
	set("custom_icons/radio_checked", load("res://Assets/Sprites/Icons/"+skill+"2.png"))
	set("custom_icons/radio_unchecked", load("res://Assets/Sprites/Icons/"+skill+"1.png"))
	
func set_press():
	pressed = true
	agent.show_skill(skill) 
	
func _on_BtnSkill_pressed():
	agent.show_skill(skill) 
