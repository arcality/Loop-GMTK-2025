extends Area2D


@export var is_active = false


func _process(delta: float) -> void:
	# if active, show active portal. If not, show inactive portal
	if is_active :
		$ActivePortal.visible = true
		$InactivePortal.visible = false
	else :
		$ActivePortal.visible = false
		$InactivePortal.visible = true


func _on_body_entered(body: Node2D) -> void:
	# if frame not active, return
	if not is_active : return
	
	# if not able to tp, return
	if not body.can_tp == true : return
	
	# if able to tp, set can_tp to false, wait, then set back to true
	body.can_tp = false;
	body.set_position($DestinationPoint.global_position)
	await get_tree().create_timer(0.25).timeout
	body.can_tp = true
