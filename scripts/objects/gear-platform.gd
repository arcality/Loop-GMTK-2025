class_name GearPlatform extends StaticBody2D

@export var angular_velocity: float = 2.0:
	set(value):
		angular_velocity = value
		constant_angular_velocity = value

@export var pitch: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	constant_angular_velocity = angular_velocity
	$AudioStreamPlayer2D.pitch_scale = pitch
	$AudioStreamPlayer2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Sprite2D.rotation += angular_velocity * delta
	
