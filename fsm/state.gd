extends Node
class_name State

signal Transitioned

var player: CharacterBody3D
var input_manager: InputManager
var player_direction: PlayerDirection
var next_state: String
var animator: AnimationPlayer

func Enter():
	pass
	
func Exit():
	pass
	
func Update(delta: float):
	pass
	
func Physics_Update(delta: float):
	pass
