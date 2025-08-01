extends Level

# add all children of this type to this array so that they can be 
# correctly ticked
@onready var vertical_gears: Array[GearVertical] = [
	$"Gear-vertical"
]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	for g in vertical_gears:
		g.tick(delta, player.position.y)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
