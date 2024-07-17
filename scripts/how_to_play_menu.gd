extends Control

@onready var start_menu_button = %StartMenuButton

func _ready():
	start_menu_button.grab_focus()


func _on_start_menu_button_pressed():
	Sounds.button_press.playing = Globals.can_play_sounds
	await Events.change_scene("res://scenes/start_menu.tscn")
