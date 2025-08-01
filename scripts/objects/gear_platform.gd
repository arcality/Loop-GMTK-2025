class_name GearPlatform extends StaticBody2D

const ANGULAR_VELOCITY: float = 2.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	constant_angular_velocity = ANGULAR_VELOCITY


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Sprite2D.rotation += ANGULAR_VELOCITY * delta
