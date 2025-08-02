class_name Level extends Node2D

## General superclass for levels
##
## Offers basic functionality for all levels and has variables to specify
## how the level is handled by the main script.

## The maximum position (x,y) that the camera can go to.
@export var camera_max: Vector2 = Vector2(192, 108)
## The minimum position (x,y) that the camera can go to.
@export var camera_min: Vector2 = Vector2(192, 108)

## Stores the different spawn positions for when a [Player] enters the room.
## Each individual [Level] will emit the correct spawn index of the next Level when
## sending a [Player] to the next room.
@export var spawn_positions: Array[Vector2]

## Emitted when switching levels. [param spawn_pos_index] refers to the index
## in the [member spawn_pos] of the [Level] represented by [param next_level]
signal level_progressed(next_level: int, spawn_pos_index: int)

## Stores a reference to the player. To be updated by the main scene
@onready var player: Player

## Add all children of this type to this array so that they can be 
## correctly ticked
@onready var vertical_gears: Array[GearVertical]


func _physics_process(delta: float) -> void:
	for g in vertical_gears:
		g.tick(delta, player.position.y)
