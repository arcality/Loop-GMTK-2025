extends Area2D

@export var is_active = false

signal teleport_player()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_active :
		$ActivePortal.visible = true
		$InactivePortal.visible = false
	else :
		$ActivePortal.visible = false
		$InactivePortal.visible = true


func _on_body_entered(body: Node2D) -> void:
	print("teleport player")
	# if something other than a player entered, return
	if not (body is Player) : return
	
	# if frame not active, return
	if not is_active : return
	
	# if not able to tp, return
	if not body.can_tp == true : return
	
	# if able to tp, set can_tp to false, wait, then set back to true
	body.can_tp = false;
	#body.set_position($DestinationPoint.global_position)
	teleport_player.emit()
	body.get_tree().create_timer(0.25).timeout.connect(body._on_portal_timer_timeout)
	#body.can_tp = true
