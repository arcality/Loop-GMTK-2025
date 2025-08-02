extends Node

const levels: Array[PackedScene] = [
	preload("res://scenes/levels/level-1.tscn"),
	preload("res://scenes/levels/level-2.tscn"),
	preload("res://scenes/levels/level-3.tscn"),
	preload("res://scenes/levels/level-4.tscn")
]
const player_scene = preload("res://scenes/player/player.tscn")

@onready var window_width = get_viewport().size.x
@onready var window_height = get_viewport().size.y

var player: Player
var current_level: Level
@export var starting_level_number: int = 1

@onready var camera_max: Vector2 = Vector2(window_width/2, window_height/2)
@onready var camera_min: Vector2 = Vector2(window_width/2, window_height/2)

func _init() -> void:
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#load_level_number(starting_level_number)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player != null:
		var x_dest: float = clamp(player.position.x, camera_min.x, camera_max.x)
		var y_dest: float = clamp(player.position.y, camera_min.y, camera_max.y)
		$Camera2D.position = lerp($Camera2D.position, Vector2(x_dest, y_dest), 0.5)

func load_level_from_number(level_num: int, spawn_pos_index: int) -> void:
	# ensure we aren't stacking multiple scenes
	if current_level:
		current_level.queue_free()
	
	var index = clamp(level_num - 1, 0, levels.size() - 1)
	current_level = levels[index].instantiate()
	
	player.position = current_level.spawn_positions[spawn_pos_index]
	
	assert(current_level is Level)
	self.add_child(current_level)
	current_level.level_progressed.connect(_on_level_progressed)
	
	current_level.player = player
	
	camera_max = current_level.camera_max
	camera_min = current_level.camera_min
	

#func remove_level():
	#remove_child(current_level)


func _on_player_threw_item(item: ThrowableItem, x_direction: float) -> void:
	add_child(item)
	item.position = Vector2($Player.position)
	item.throw(x_direction)


func _on_player_picked_up_item(item: ThrowableItem) -> void:
	current_level.remove_child(item)

func _on_player_died() -> void:
	call_deferred("load_level_from_number", starting_level_number, 0)

func _on_level_progressed(next_level: int, spawn_pos_index: int) -> void:
	call_deferred("load_level_from_number", next_level, spawn_pos_index)
	


func _on_titlescreen_start_game() -> void:
	player = player_scene.instantiate()
	self.add_child(player)
	player.picked_up_item.connect(_on_player_picked_up_item)
	player.threw_item.connect(_on_player_threw_item)
	player.died.connect(_on_player_died)
	
	call_deferred("load_level_from_number", starting_level_number, 0)
	
	$AudioStreamPlayer.play()

	
