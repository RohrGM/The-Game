extends KinematicBody2D

func _ready():
	set_process_unhandled_input(false)
	
func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		get_tree().get_root().get_node("World/Save").save_game()
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Scenes/Map.tscn")
		
	
# warning-ignore:unused_argument
func _on_Area2D_body_entered(body):
	set_process_unhandled_input(true)


# warning-ignore:unused_argument
func _on_Area2D_body_exited(body):
	set_process_unhandled_input(false)
