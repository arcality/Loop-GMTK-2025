extends Node2D

## [float] controlled by a tween. Acts as a multiplier for the angle of the
## pendulum.
var distance: float = -1.0

@export var max_angle: float = PI/4
@export var speed: float = 60.0 / 65.0
@export var length: float = 64

const STARTING_ANGLE: float = PI/2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_tween()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	var x_pos: float = cos(distance*max_angle + STARTING_ANGLE) * length
	var y_pos: float = sin(distance*max_angle + STARTING_ANGLE) * length
	$AnimatableBody2D.position = Vector2(x_pos, y_pos)


func start_tween() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self, "distance", -distance, speed).from(distance).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.connect("finished", _on_tween_finished)

func _on_tween_finished() -> void:
	#tween_positions.reverse()
	start_tween()
