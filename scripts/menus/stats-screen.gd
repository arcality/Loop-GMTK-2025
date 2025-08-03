extends Control

var time: float
var total_time: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_stats(final_time: float, total_time: float):
	$FinalTime.text = str(int(final_time/60.0)) + ":" + str(floor(int(final_time)%60)) + "min"
	$TotalTime.text = str(int(total_time/60.0)) + ":" + str(floor(int(total_time)%60)) + "min"


func _on_back_pressed() -> void:
	get_tree().paused = false
	hide()  # hide the pause menu just in case
	get_tree().reload_current_scene()
