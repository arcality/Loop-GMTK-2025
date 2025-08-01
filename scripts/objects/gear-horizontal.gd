class_name GearHorizontal extends StaticBody2D

## represents the velocity
@export var spin_velocity: float = 60

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	constant_linear_velocity.x = spin_velocity


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
