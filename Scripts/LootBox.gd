extends Area2D

var loot = ["Rifle", "Rifle"]

func _ready():
	set_process_unhandled_input(false)
	
func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		get_tree().get_root().get_node("World/GuiController/Inventory").add_loot(self)
		get_tree().get_root().get_node("World/GuiController").show_loot()

# warning-ignore:unused_argument
func _on_Box_body_entered(body):
	set_process_unhandled_input(true)

# warning-ignore:unused_argument
func _on_Box_body_exited(body):
	set_process_unhandled_input(false)
