extends Control

@onready var button = $Button
@onready var check = $Check

@export var level_number: int
@export var level_scene_path: String 

func _ready():
	button.text = str(level_number)
	check.visible = Globals.completed_levels.has(level_number)


func _on_button_pressed():
	Sounds.button_press.playing = Globals.can_play_sounds
	await Events.change_scene(level_scene_path)
