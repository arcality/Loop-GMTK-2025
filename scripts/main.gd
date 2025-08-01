extends Node

const levels: Array[PackedScene] = [
	preload("res://scenes/levels/level-1.tscn")
]

var current_level: Level
@export var starting_level_number: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#load_level_number(starting_level_number)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_level_number(level_num: int) -> void:
	# ensure we aren't stacking multiple scenes
	if current_level:
		current_level.queue_free()
	
	var index = clamp(level_num - 1, 0, levels.size() - 1)
	current_level = levels[index].instantiate()
	
	assert(current_level is Level)
	self.add_child(current_level)

func remove_level():
	remove_child(current_level)


func _on_player_threw_item(item: ThrowableItem, x_direction: float) -> void:
	add_child(item)
	item.position = Vector2($Player.position)
	item.throw(x_direction)


func _on_player_picked_up_item(item: ThrowableItem) -> void:
	current_level.remove_child(item)
