extends CharacterBody2D

var held_item: ThrowableItem

signal threw_item(item: ThrowableItem, x_direction: float)
signal picked_up_item(item: ThrowableItem)

const SPEED = 150.0
const JUMP_VELOCITY = -400.0

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
	if event.is_action_pressed("throw") and held_item != null:
		throw_item()
	elif event.is_action_pressed("throw") and held_item == null:
		pick_up_item()

func throw_item():
	threw_item.emit(held_item, x_direction)
	held_item = null

func pick_up_item():
	for i in $PickUpRange.get_overlapping_bodies():
		if i is ThrowableItem:
			if i.is_being_thrown == false:
				held_item = i
				picked_up_item.emit(i)
				break
