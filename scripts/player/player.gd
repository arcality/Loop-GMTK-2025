class_name Player extends CharacterBody2D

## Class for the player character
##
## Holds all data for the player. Has functions to handle throwing and handles
## movement input.

## Stores a reference to a [ThrowableItem] held by the player.
var held_item: ThrowableItem

## Emitted when the [method throw_item] is called. Passes the
## [ThrowableItem] being thrown as well as its direction.
signal threw_item(item: ThrowableItem, x_direction: float)
## Emitted when the [method pick_up_item] is called. Passes the [ThrowableItem]
## being picked up.
signal picked_up_item(item: ThrowableItem)
## Emitted when the player dies
signal died()

const SPEED = 150.0
const JUMP_VELOCITY = -300.0

## Stores the x-component of the direction for a thrown object.
var x_direction: float = 1.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction != 0.0:
		x_direction = direction
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and held_item != null:
		throw_item()
	elif event.is_action_pressed("interact") and held_item == null:
		interact()

## Emits [signal threw_item] using the [member held_item] and
## [member x_direction]. Also sets [member held_item] to null.
func throw_item():
	threw_item.emit(held_item, x_direction)
	held_item = null

## Emits [signal picked_up_item] passing the first [ThrowableItem] in range
## through the signal.
func interact():
	for i in $InteractRange.get_overlapping_bodies():
		if i is ThrowableItem:
			if i.is_being_thrown == false:
				held_item = i
				picked_up_item.emit(i)
				break
		if i is Switch:
			i.switch()
	


func _on_hurt_box_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	died.emit()
