extends CanvasLayer

func _ready():
	hide_windows()

func _input(event):
	if event.is_action_pressed("inventory"):
		if $Inventory.visible:
			$Inventory.inv_hide()
		else:
			$Inventory.inv_show()
			
func show_loot(lt):
	$Inventory.inv_loot_show(lt)
	
func party_hide():
	$PartyControl.hide()

func party_show():
	$PartyControl.show()
			
func hide_windows():
	$Inventory.inv_hide()
