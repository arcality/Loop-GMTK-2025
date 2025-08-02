class_name Switch extends StaticBody2D

## Whether the switch is switched
@export var is_on: bool = false

## Emitted when the switch switches
signal switched(is_on: bool)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_on:
		$OnSprite.show()
		$OffSprite.hide()
	else:
		$OffSprite.show()
		$OnSprite.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


## Switches the switch
func switch() -> void:
	if is_on:
		is_on = false
		$OffSprite.show()
		$OnSprite.hide()
	else:
		is_on = true
		$OnSprite.show()
		$OffSprite.hide()
	switched.emit(is_on)
