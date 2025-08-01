class_name Level extends Node2D

## General superclass for levels
##
## Offers basic functionality for all levels and has variables to specify
## how the level is handled by the main script.

## Used to specify the axes on which the camera should move to follow the
## player. (Meant to function as a vector of booleans)
@export var camera_movement_axes: Vector2i = Vector2i(0,0)

## Stores the different spawn positions for when a [Player] enters the room.
## Each individual [Level] will emit the correct spawn index of the next Level when
## sending a [Player] to the next room.
@export var spawn_positions: Array[Vector2]

## Emitted when switching levels. [param spawn_pos_index] refers to the index
## in the [member spawn_pos] of the [Level] represented by [param next_level]
signal level_progressed(next_level: int, spawn_pos_index: int)

## Stores a reference to the player. To be updated by the main scene
@onready var player: Player
