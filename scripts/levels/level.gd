class_name Level extends Node2D

## General superclass for levels
##
## Offers basic functionality for all levels and has variables that can specify
## how the level is handled by the mains script.

## Used to specify the axes on which the camera should move to follow the
## player. (Meant to function as a vector of booleans)
@export var camera_movement_axes: Vector2i = Vector2i(0,0)
