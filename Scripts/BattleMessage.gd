extends Label

func start(txt):
	text = txt

	$Tween.interpolate_property(self, "rect_position", rect_position, rect_position + Vector2(0, -30) ,1,Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.start()
	$Tween.interpolate_property(self, "modulate", Color(1,0,0,1), Color(1,0,0,0),1,Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")
	queue_free()
