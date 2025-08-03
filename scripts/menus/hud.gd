extends CanvasLayer

# total time of a full run (seconds)
@export var total_run_time: float = 90.0
# if you ever change how many clocks, this will pick them up automatically
@onready var clocks = [
	$"ClockContainer/Clock-1",
	$"ClockContainer/Clock-2",
	$"ClockContainer/Clock-3",
	$"ClockContainer/Clock-4",
	$"ClockContainer/Clock-5",
	$"ClockContainer/Clock-6",
	$"ClockContainer/Clock-7",
	$"ClockContainer/Clock-8"
]
# terrible practice right here
@onready var timer_node: Timer = get_tree().current_scene.get_node("TimeLimitTimer")

func _ready() -> void:
	# hide all but the first clock at start
	for c in clocks:
		c.visible = false
	if clocks.size() > 0:
		clocks[0].visible = true

func _process(delta: float) -> void:
	# get how far into the run we are (0.0–1.0)
	var elapsed = get_run_elapsed_time()
	var frac = elapsed / total_run_time

	# pick an index 0 through clocks.size()-1
	var idx = int(frac * clocks.size())
	idx = clamp(idx, 0, clocks.size() - 1)

	# show only that clock
	for i in clocks.size():
		clocks[i].visible = (i == idx)


func get_run_elapsed_time() -> float:
	# assuming Main has a TimeLimitTimer that counts down
	# and you know total_run_time = Main.TimeLimitTimer.wait_time
	var rem = timer_node.time_left
	return total_run_time - rem
