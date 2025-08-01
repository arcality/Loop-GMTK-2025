class_name Switch extends StaticBody2D

@export var is_on: bool = false

signal switched(is_on: bool)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


## Switches the switch
func switch() -> void:
	if is_on:
		is_on = false
	else:
		is_on = true
	switched.emit(is_on)
