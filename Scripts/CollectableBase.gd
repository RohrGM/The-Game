extends Area2D

class_name Collectable

onready var gui = get_tree().get_root().get_node("World/GuiController")

var tile
var tile_region
var interacted = false
var loot = []
var id = 0

func start(tl : Vector2, tlr : Vector2, i : int, parent, pos):
	tile = tl
	tile_region = tlr
	id = i
	parent.add_child(self)
	position = pos

func _ready():
	set_process_unhandled_input(false)
	set_process(false)
	load_loot()
	
func _unhandled_input(event):
	if Input.is_action_pressed("Interact") and !interacted:
		set_process(true)

	elif Input.is_action_just_released("Interact"):
		set_process(false)
		$Icon.value = 0
		
func _process(delta):
	interact(delta)
	
func load_loot():
	pass
		
func interact(delta) -> void:
	$Icon.value += 30 * delta

	if $Icon.value == $Icon.max_value:
		set_process(false)
		interacted = true
		$Icon.hide()
		
		if gui.get_node("Inventory").pickup_item(loot[0]):
			get_parent().set_cell(tile[0], tile[1], id, false, false, false, tile_region + Vector2(0,1))
			queue_free()

func _on_LootArea_body_entered(body):
	if body.is_in_group("Party"):
		set_process_unhandled_input(true)
		$Icon.show()

func _on_LootArea_body_exited(body):
	if body.is_in_group("Party"):
		$Icon.hide()
		interacted = false
		set_process_unhandled_input(false)
