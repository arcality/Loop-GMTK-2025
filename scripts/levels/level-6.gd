extends Level


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	vertical_gears.append($"Gear-vertical")
	vertical_gears.append($"Gear-vertical2")
	vertical_gears.append($"Gear-vertical3")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_crosssceneportal_teleport_player() -> void:
	level_progressed.emit(5, 1)


func _on_switch_switched(is_on: bool) -> void:
	$"Gear-vertical".change_direction()
	$"Gear-vertical2".change_direction()
	$"Gear-vertical3".change_direction()
	$GearPlatform.change_direction()


func _on_crosssceneportal_2_teleport_player() -> void:
	level_progressed.emit(1, 2)
