class_name ThrowableItem extends CharacterBody2D

signal was_removed()

const THROW_SPEED: float = 500
var is_being_thrown: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_being_thrown and abs(velocity.x) < THROW_SPEED:
		queue_free()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and not is_being_thrown:
		velocity += get_gravity() * delta
	
	move_and_slide()

func throw(x_direction: float):
	is_being_thrown = true
	velocity.x = x_direction * THROW_SPEED


func _on_interact_range_body_entered(body: Node2D) -> void:
	if body is Switch:
		body.switch()
