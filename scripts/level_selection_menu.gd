extends Control

@onready var level_selector = $LevelSelectorContainer/LevelSelector

func _ready():
	level_selector.button.grab_focus()


func _on_button_pressed():
	Sounds.button_press.playing = Globals.can_play_sounds
	await Events.change_scene("res://scenes/start_menu.tscn")
	

