extends CanvasLayer

@onready var label = $Label

@export var total_hearts: int
var collected_hearts: int = 0

func _process(_delta):
	label.text = str(collected_hearts) + "/" + str(total_hearts)
