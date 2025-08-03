extends Node

const levels: Array[PackedScene] = [
	preload("res://scenes/levels/level-1.tscn"),
	preload("res://scenes/levels/level-2.tscn"),
	preload("res://scenes/levels/level-3.tscn"),
	preload("res://scenes/levels/level-4.tscn"),
	preload("res://scenes/levels/level-5.tscn"),
	preload("res://scenes/levels/level-6.tscn"),
	preload("res://scenes/levels/level-7.tscn")
]
const player_scene = preload("res://scenes/player/player.tscn")

# this is where level data is saved
var loaded_levels: Array[Level] = []

@onready var window_width = get_viewport().size.x
@onready var window_height = get_viewport().size.y

var player: Player
var current_level: Level
@export var starting_level_number: int = 1

@onready var camera_max: Vector2 = Vector2(window_width/2, window_height/2)
@onready var camera_min: Vector2 = Vector2(window_width/2, window_height/2)

## time limit timer
@onready var time_limit_timer: Timer = $TimeLimitTimer

var loop_counter: int = 0

func _init() -> void:
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#load_level_number(starting_level_number)
	get_viewport().size = Vector2i(384*4,216*4)
	get_window().move_to_center()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player != null:
		var x_dest: float = clamp(player.position.x, camera_min.x, camera_max.x)
		var y_dest: float = clamp(player.position.y, camera_min.y, camera_max.y)
		$Camera2D.position = lerp($Camera2D.position, Vector2(x_dest, y_dest), 0.5)

func load_level_from_number(level_num: int, spawn_pos_index: int) -> void:
	# ensure we aren't stacking multiple scenes
	if current_level:
		remove_child(current_level)
	
	var index = clamp(level_num - 1, 0, levels.size() - 1)
	current_level = loaded_levels[index]
	
	player.position = current_level.spawn_positions[spawn_pos_index]
	
	assert(current_level is Level)
	self.add_child(current_level)
	var cb = Callable(self, "_on_level_progressed")
	if not current_level.is_connected("level_progressed", cb):
		current_level.level_progressed.connect(_on_level_progressed)
	
	current_level.player = player
	
	camera_max = current_level.camera_max
	camera_min = current_level.camera_min
	
	var x_dest: float = clamp(player.position.x, camera_min.x, camera_max.x)
	var y_dest: float = clamp(player.position.y, camera_min.y, camera_max.y)
	$Camera2D.position = Vector2(x_dest, y_dest)
	

#func remove_level():
	#remove_child(current_level)

func respawn() -> void:
	if player == null:
		return
	
	loaded_levels.clear()
	if not loaded_levels:
		for level in levels:
			loaded_levels.append(level.instantiate())
	
	loop_counter += 1
	player.can_tp = true
	call_deferred("load_level_from_number", starting_level_number, 0)
	
	$AudioStreamPlayer.stop()
	$AudioStreamPlayer.play()
	$TimeLimitTimer.start()


func _on_player_threw_item(item: ThrowableItem, x_direction: float) -> void:
	current_level.add_child(item)
	item.position = Vector2($Player.position)
	item.throw(x_direction)


func _on_player_picked_up_item(item: ThrowableItem) -> void:
	current_level.remove_child(item)

func _on_player_died() -> void:
	rewind()


func _on_level_progressed(next_level: int, spawn_pos_index: int) -> void:
	call_deferred("load_level_from_number", next_level, spawn_pos_index)
	


func _on_titlescreen_start_game() -> void:
	player = player_scene.instantiate()
	self.add_child(player)
	player.picked_up_item.connect(_on_player_picked_up_item)
	player.threw_item.connect(_on_player_threw_item)
	player.died.connect(_on_player_died)
	
	if not loaded_levels:
		for level in levels:
			loaded_levels.append(level.instantiate())
			
	$Hud.visible = true
	
	respawn()
	#call_deferred("load_level_from_number", starting_level_number, 0)
	#
	#$AudioStreamPlayer.play()
	#
	#$TimeLimitTimer.start()

	


func _on_time_limit_timer_timeout() -> void:
	# play rewind sound, stop all player movement, reverse clock hud
	rewind_with_music()
	
func rewind() -> void:
	# disable all player interactions
	player.set_physics_process(false)
	player.set_process(false)
	
	# stop music
	$AudioStreamPlayer.stop()
	
	# play rewind sound
	$RewindSound.play()
	
	#play rewind animation
	$Camera2D/RewindAnimation.visible = true
	# reset the sprite back to frame 0 before playing
	$Camera2D/RewindAnimation.stop()
	$Camera2D/RewindAnimation.frame = 0
	$Camera2D/RewindAnimation.play()
	
	# when rewind sound is fininshed, then player will unfreeze and respawn


# same thing as rewind, but doesn't stop the music (lets the bell ring out)
func rewind_with_music() -> void:
	# disable all player interactions
	player.set_physics_process(false)
	player.set_process(false)
	
	# stop music
	#$AudioStreamPlayer.stop()
	
	# play rewind sound
	$RewindSound.play()
	
	#play rewind animation
	$Camera2D/RewindAnimation.visible = true
	# reset the sprite back to frame 0 before playing
	$Camera2D/RewindAnimation.stop()
	$Camera2D/RewindAnimation.frame = 0
	$Camera2D/RewindAnimation.play()
	
	# when rewind sound is fininshed, then player will unfreeze and respawn

func _on_pause_restart_loop() -> void:
	respawn()


func _on_rewind_sound_finished() -> void:
	# unfreeze and respawn
	player.set_physics_process(true)
	player.set_process(true)
	$Camera2D/RewindAnimation.stop()
	$Camera2D/RewindAnimation.visible = false
	respawn()
