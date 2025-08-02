extends Level


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# activate portals:
	$UpperPortal.is_active = true
	$LowerPortal.is_active = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_exit_1_body_entered(body: Node2D) -> void:
	if body is Player:
		level_progressed.emit(2, 1)


func _on_exit_2_body_entered(body: Node2D) -> void:
	if body is Player:
		level_progressed.emit(4, 0)
