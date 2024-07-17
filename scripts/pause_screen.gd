extends CanvasLayer

@onready var exit_button = %ExitButton

func _process(_delta):
	if (Input.is_action_just_pressed("pause")):
		if (not get_tree().paused):
			get_tree().paused = true
			show()
			exit_button.grab_focus()
		else:
			get_tree().paused = false
			hide()


func _on_exit_button_pressed():
	Sounds.button_press.playing = Globals.can_play_sounds
	get_tree().paused = false
	hide()
	await Events.change_scene("res://scenes/level_selection_menu.tscn")


func _on_restart_button_pressed():
	Sounds.button_press.playing = Globals.can_play_sounds
	get_tree().paused = false
	hide()
	get_tree().reload_current_scene()
