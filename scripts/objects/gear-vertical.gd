class_name GearVertical extends Node2D

var player_is_on_gear: bool = false
var player: Player

## The topmost position of the platform. This is used to clamp its position
const TOP_EDGE: float = -32
## The bottommost position of the platform. This is used to clamp its position
const BOTTOM_EDGE: float = 0

const PLAYER_RADIUS: float = 6.0

## The velocity the gear will move the player by
@export var y_velocity: float =  -40

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func tick(delta: float, player_y: float) -> void:
	if player_is_on_gear:
		$Platform.position.y = clamp($Platform.position.y + y_velocity * delta, TOP_EDGE, BOTTOM_EDGE)
	else:
		$Platform.position.y = clamp(player_y - self.global_position.y + PLAYER_RADIUS + 2, TOP_EDGE, BOTTOM_EDGE)
	
	# disable the platform if it reaches the bottom of the gear (player falls off)
	if $Platform.position.y == 0.0 and $Platform/CollisionShape2D.disabled == false:
		#print("disabled the collision shape")
		$Platform/CollisionShape2D.disabled = true
	elif $Platform.position.y != 0.0 and $Platform/CollisionShape2D.disabled == true:
		#print("enabled the collision shape")
		$Platform/CollisionShape2D.disabled = false


func _on_collision_area_body_entered(body: Node2D) -> void:
	if body is Player:
		player_is_on_gear = true


func _on_collision_area_body_exited(body: Node2D) -> void:
	if body is Player:
		player_is_on_gear = false
