class_name GearPlatform extends StaticBody2D

@export var angular_velocity: float = 2.0#:
	#set(value):
		#angular_velocity = value
		#constant_angular_velocity = value

@export var pitch: float = 0.7

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	constant_angular_velocity = angular_velocity
	$AudioStreamPlayer2D.pitch_scale = pitch
	$AudioStreamPlayer2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Sprite2D.rotation += constant_angular_velocity * delta
	

func change_direction() -> void:
	angular_velocity *= -1
	var tween2: Tween = create_tween()
	tween2.tween_property($AudioStreamPlayer2D, "pitch_scale", pitch * 0.5, 1).set_trans(Tween.TRANS_QUAD)
	tween2.tween_property($AudioStreamPlayer2D, "pitch_scale", pitch, 1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	var tween: Tween = create_tween()
	tween.tween_property(self, "constant_angular_velocity", angular_velocity, 1)
	
