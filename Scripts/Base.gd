extends KinematicBody2D

class_name Base

var mv = null

onready var m = preload("res://PackageScenes/MoveAt.tscn")
onready var map = get_tree().get_root().get_node("World/BattleMap")
onready var battle = get_tree().get_root().get_node("World/GuiController/BattleManager")
onready var bt_message = preload("res://PackageScenes/BattleMessage.tscn")
onready var icon = preload("res://Assets/Sprites/Icons/blank.png")

var attributes = {
	"str": 5,
	"const": 5,
	"dex": 5,
	"action_points": 5,
	"ca": 10
}

var weapon = {
	"damage": Vector2(1,4),
	"distance": 1,
	"cost": 1
}

func move_at(pos, anim , speed = 20) -> void:
	if anim == "Run":
		speed *= 1.5
	stop_move()
	mv = m.instance()
	add_child(mv)
	mv.start(get_tree().get_root().get_node("World").get_closest_point(pos), speed, anim)
	mv.connect("in_position", self, "_on_MoveAt_in_position")
	
func get_ca():
	return attributes.ca

func stop_move():
	if is_instance_valid(mv):
		travel_anim("Idle")
		mv.queue_free()
		
func roll_dice(value : Vector2):
	var result = 0
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	for i in value.x:
		result += rng.randi_range(1, value.y)
	return result
	
		
func travel_anim(anim : String) -> void:
	$AnimationTree.get("parameters/playback").travel(anim)

func update_anim_tree(vector : Vector2) -> void:
	$AnimationTree.set("parameters/Idle/blend_position", vector.x)
	$AnimationTree.set("parameters/Run/blend_position", vector.x)
	$AnimationTree.set("parameters/BtIdle/blend_position", vector.x)
	$AnimationTree.set("parameters/Punch/blend_position", vector.x)
	$AnimationTree.set("parameters/Hit/blend_position", vector.x)

func center_block(pos):
	var new_pos = Vector2(int(pos.x / 16), int(pos.y / 16))
	new_pos = Vector2(new_pos.x * 16 + 8, new_pos.y * 16 + 7)
	
	return new_pos
