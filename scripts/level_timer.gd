extends CanvasLayer

@onready var label = $Label

var is_paused = false
var has_started = false
var start_ticks_msec = 0.0
var paused_times: Array[float]

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		is_paused = not is_paused
		paused_times.append(Time.get_ticks_msec())
	
	if has_started and not is_paused:
		label.text = str(_calculate_current_time())


func _calculate_current_time() -> int:
	var current_time = Time.get_ticks_msec()
	
	var flag = true
	for time in paused_times:
		if flag:
			current_time = current_time + time
		else: 
			current_time = current_time - time
		flag = not flag
	
	current_time = current_time - start_ticks_msec
	
	return current_time / 1000

func start():
	has_started = true
	is_paused = false
	start_ticks_msec = Time.get_ticks_msec()
