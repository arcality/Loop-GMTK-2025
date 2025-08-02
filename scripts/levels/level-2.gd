extends Level


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_exit_1_body_entered(body: Node2D) -> void:
	if body is Player:
		level_progressed.emit(1, 1)


func _on_switch_switched(is_on: bool) -> void:
	$GearPlatform.angular_velocity *= -1
