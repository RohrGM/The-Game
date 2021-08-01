extends Node2D

const save_path = "user://save.dat"
var party_save = []

func _ready():
	load_game()
	
func _unhandled_input(event):
	if event.is_action_pressed("save"):
		save_game()

func save_game():
	var party = get_tree().get_nodes_in_group("Party")
	for i in party:
		var p = {
			"pos" : i.position
		}
		party_save.append(p)
		
	var file = File.new()
	var error = file.open(save_path, File.WRITE)
	if error == OK:
		file.store_var(party_save)
		file.close()
		print("salvo")
		
func load_game():
	var file = File.new()
	if file.file_exists(save_path):
		var error = file.open(save_path, File.READ)
		if error == OK:
			var data = file.get_var()
			print("carregado")
			file.close()
			var party = get_tree().get_nodes_in_group("Party")
			for i in range(party.size()):
				party[i].position = data[i].pos
