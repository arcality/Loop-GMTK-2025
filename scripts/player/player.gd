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

const SPEED := 170.0
const JUMP_VELOCITY := -300.0
const ACCELERATION := 1500.0

const JUMP_BUFFER_TIME := 0.2

## @deprecated
var is_coyote: bool = false

var is_jump_buffered: bool = false
var is_throw_animating: bool = false

## Stores the x-component of the direction for a thrown object.
var x_direction: float = 1.0

## Stores teleport state of the player
var can_tp = true

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_just_pressed("jump") and !is_on_floor() and !is_jump_buffered:
		start_jump_buffer()
	
	if is_jump_buffered and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	
	if !Input.is_action_pressed("jump") and velocity.y < 0:
		velocity.y = clamp(velocity.y, 0, INF)
	
		
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction != 0.0:
		x_direction = direction
	if direction < 0:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta) if velocity.x <= 0 else 0
	elif direction > 0:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta) if velocity.x >= 0 else 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()

func _process(delta: float) -> void:
	if !is_throw_animating:
		if x_direction < 0.0 and !$AnimatedSprite2D.flip_h:
			$AnimatedSprite2D.flip_h = true
		elif x_direction > 0.0 and $AnimatedSprite2D.flip_h:
			$AnimatedSprite2D.flip_h = false
		if is_on_floor():
			if Input.get_axis("left", "right") == 0:
				if held_item != null:
					$AnimatedSprite2D.play("hold")
				else:
					$AnimatedSprite2D.play("idle")
			else:
				$AnimatedSprite2D.play("run")
		else:
			$AnimatedSprite2D.play("jump")
	if held_item:
		$GearIcon.show()
	else:
		$GearIcon.hide()

func start_jump_buffer() -> void:
	is_jump_buffered = true
	var timer: Timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.add_to_group("jump_timers")
	timer.start(JUMP_BUFFER_TIME)
	timer.connect("timeout", _on_jump_buffer_timer_timeout)

func _on_jump_buffer_timer_timeout() -> void:
	is_jump_buffered = false
	for t in get_tree().get_nodes_in_group("jump_timers"):
		t.queue_free()
	



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
	$AnimatedSprite2D.play("throw")
	is_throw_animating = true
	$AnimatedSprite2D.connect("animation_finished", _on_start_throw_animation)

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
	
func _on_hurt_box_body_entered(body: Node2D) -> void:
	died.emit()

func _on_start_throw_animation() -> void:
	is_throw_animating = false

func _on_portal_timer_timeout() -> void:
	can_tp = true
