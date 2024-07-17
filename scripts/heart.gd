extends Area2D

signal collected

func _on_body_entered(_body):
	queue_free()
	Sounds.collect_heart.play()
	collected.emit()
