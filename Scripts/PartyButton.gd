extends CheckBox

export var agent = 0

signal set_agent(value)

func _on_Player1_pressed():
	emit_signal("set_agent", agent)
