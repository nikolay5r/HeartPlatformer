extends Node

signal level_completed(level_number: int)

func change_scene(path: String):
	await TransitionLayer.fade_to_black()
	get_tree().call_deferred("change_scene_to_file", path)
	await TransitionLayer.fade_from_black()
