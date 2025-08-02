extends Level


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_exit_1_body_entered(body: Node2D) -> void:
	if body is Player:
		level_progressed.emit(4, 1)


func _on_switch_switched(is_on: bool) -> void:
	$FramePortal.is_active = is_on
	$FramePortal2.is_active = is_on


func _on_exit_2_body_entered(body: Node2D) -> void:
	if body is Player and $Exits/Exit2.is_active:
		level_progressed.emit(6, 0)


func _on_switch_2_switched(is_on: bool) -> void:
	$Exits/Exit2.is_active = is_on
