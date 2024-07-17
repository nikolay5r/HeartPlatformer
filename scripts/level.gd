extends Node2D

@onready var heart_counter = $HeartCounter
@onready var pause_screen = $PauseScreen
@onready var level_timer = $LevelTimer

@export var level_number: int

var is_completed = false

func _ready():
	RenderingServer.set_default_clear_color(Color.BLACK)
	heart_counter.total_hearts = get_tree().get_nodes_in_group("Hearts").size()
	level_timer.start()
	for heart in get_tree().get_nodes_in_group("Hearts"):
		heart.connect("collected", _on_heart_collected)


func _process(_delta):
	if (not is_completed and heart_counter.collected_hearts == heart_counter.total_hearts):
		_show_level_completed()


func _on_heart_collected():
	heart_counter.collected_hearts += 1


func _show_level_completed():
	get_tree().paused = true
	heart_counter.hide()
	level_timer.hide()
	LevelCompleted.show()
	await get_tree().create_timer(1.0).timeout
	await TransitionLayer.fade_to_black()
	get_tree().paused = false
	LevelCompleted.hide()
	Globals.completed_levels.append(level_number)
	is_completed = true
	get_tree().call_deferred("change_scene_to_file", "res://scenes/level_selection_menu.tscn")
	await TransitionLayer.fade_from_black()


