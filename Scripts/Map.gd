extends Control

onready var maps = ["res://Scenes/World.tscn", "res://Scenes/World2.tscn"]

# Called when the node enters the scene tree for the first time.
func _ready():
	$Locations.get_child(Global.pos).pressed = true


func _on_Back_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene(maps[Global.pos])

func _on_Go_pressed():
	for i in $Locations.get_children().size():
		if $Locations.get_child(i).pressed == true:
			Global.pos = i
# warning-ignore:return_value_discarded
			get_tree().change_scene(maps[i])
			break
