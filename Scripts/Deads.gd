extends Sprite

func update_anim_tree(vector : Vector2) -> void:
	$AnimationTree.set("parameters/Dead/blend_position", vector.x)
