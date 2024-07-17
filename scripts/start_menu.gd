extends Control

@onready var play_button = %PlayButton
@onready var sounds_button = %SoundsButton
@onready var music_button = %MusicButton

func _ready():
	play_button.grab_focus()


func _on_play_button_pressed():
	Sounds.button_press.playing = Globals.can_play_sounds
	await Events.change_scene("res://scenes/level_selection_menu.tscn")


func _on_how_to_play_button_pressed():
	Sounds.button_press.playing = Globals.can_play_sounds
	await Events.change_scene("res://scenes/how_to_play_menu.tscn")


func _on_quit_button_pressed():
	Sounds.button_press.playing = Globals.can_play_sounds
	get_tree().quit()


func _on_music_button_pressed():
	Sounds.button_press.playing = Globals.can_play_sounds
	Sounds.background_music.playing = not Sounds.background_music.playing
	if Sounds.background_music.playing:
		music_button.text = "Mute Music"
	else:
		music_button.text = "Unmute Music"


func _on_sounds_button_pressed():
	Sounds.button_press.playing = Globals.can_play_sounds
	Globals.can_play_sounds = not Globals.can_play_sounds
	if Globals.can_play_sounds:
		sounds_button.text = "Mute Sounds"
	else:
		sounds_button.text = "Unmute Sounds"
