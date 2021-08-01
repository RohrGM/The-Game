extends Area2D

onready var gui = get_tree().get_root().get_node("World/GuiController")

var tile
var tile_region
var interacted = false
var loot = ["Rifle", "Rifle"]


func _ready():
	set_process_unhandled_input(false)
	set_process(false)
	
func _unhandled_input(event):
	if Input.is_action_pressed("Interact") and !interacted:
		set_process(true)

	elif Input.is_action_just_released("Interact"):
		set_process(false)
		$Icon.value = 0
		
func _process(delta):
	interact(delta)
		
func interact(delta) -> void:
	$Icon.value += 30 * delta

	if $Icon.value == $Icon.max_value:
		set_process(false)
		interacted = true
		print("mostrando loot")
		gui.show_loot(self)
		$Icon.hide()
		
func show_loot():
	pass


func _on_LootArea_body_entered(body):
	if body.is_in_group("Party"):
		set_process_unhandled_input(true)
		$Icon.show()


func _on_LootArea_body_exited(body):
	if body.is_in_group("Party"):
		$Icon.hide()
		interacted = false
		set_process_unhandled_input(false)



#
#	onready var inventory : Control = get_node("../../../GUI/Inventory")
#var tile : Vector2 = Vector2.ZERO
#var tile_region : Vector2 = Vector2.ZERO
#
#var interacted : bool = false
#
#func _ready() -> void:
#	set_process_unhandled_input(false)
#	set_process(false)
#

#
#func _unhandled_input(event) -> void:
#	if Input.is_action_pressed("Interact") and !interacted:
#		set_process(true)
#
#	elif Input.is_action_just_released("Interact") and !interacted:
#		set_process(false)
#		$Icon.value = 0
#
#
#		get_parent().set_cell(tile[0], tile[1], 0, false, false, false, tile_region + Vector2(1,0))
#
#		if tile_region.x == 0:
#			inventory.pickup_item("Red Leaves")
#
#		elif tile_region.x == 2:
#			inventory.pickup_item("Green Leaves")
#
#		elif tile_region.x == 4:
#			inventory.pickup_item("Blueberry")
#
#		elif tile_region.x == 6:
#			inventory.pickup_item("Mushroon")
#
#		elif tile_region.x == 8:
#			inventory.pickup_item("Poison Mushroon")
#
#
#
#
#
#		set_process(false)
#
#func _on_Vegetation_area_body_entered(body) -> void:
#	if body.is_in_group("Group") and !interacted:
#		set_process_unhandled_input(true)
#		$Icon.show()
#
#
#func _on_Vegetation_area_body_exited(body) -> void:
#	if body.is_in_group("Group"):
#		$Icon.hide()
#		set_process_unhandled_input(false)
#


