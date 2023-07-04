class_name MovementComponent
extends Node


## Maximum reachable speed in px/s.
@export var max_speed := 0.0

## Body acceleration in px/s2.
@export var acceleration := 0.0

## Body deceleration in px/s2.
@export var decelration := 0.0

## Counter acceleration in px/s2 to apply when the body is being knocked back.
@export var knock_back_resistance := 150.0
