extends Area2D


func _on_body_entered(body: Node2D) -> void:
	# if not able to tp, return
	if not body.can_tp == true : return
	
	# if able to tp, set can_tp to false, wait, then set back to true
	body.can_tp = false;
	body.set_position($DestinationPoint.global_position)
	await get_tree().create_timer(1.00).timeout
	body.can_tp = true
