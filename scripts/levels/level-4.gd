extends Level


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	vertical_gears.append($"Gear-vertical")
	vertical_gears.append($"Gear-vertical2")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_exit_1_body_entered(body: Node2D) -> void:
	if body is Player:
		level_progressed.emit(3, 1)
