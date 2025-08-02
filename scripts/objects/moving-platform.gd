class_name MovingPlatform extends Node2D

## Speed it takes for the platform to get to its destination, in seconds.
@export var speed: float = 60.0 / 65.0

## A [Vector2] representing the destination of the moving platform before it
## moves back.
@export var destination: Vector2 = Vector2(100.0, 0)
const START: Vector2 = Vector2(0.0, 0.0)

@onready var tween_positions: Array[Vector2] = [
	START,
	destination
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_tween()

func _physics_process(delta: float) -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_tween() -> void:
	var tween: Tween = create_tween()
	tween.tween_property($AnimatableBody2D, "position", tween_positions[1], speed).from(tween_positions[0])
	tween.connect("finished", _on_tween_finished)

func _on_tween_finished() -> void:
	tween_positions.reverse()
	start_tween()
