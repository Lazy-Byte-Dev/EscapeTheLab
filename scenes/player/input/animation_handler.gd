extends Node
class_name AnimationHandler

@onready var animation_tree: AnimationTree = $"../YBot/AnimationTree"

@export var blend_speed = 10
var timer: float

var run_val = 0.0
var jump = 0.0
var fall = 0.0
	
func update_animation(state: String, delta: float):
	match state:
		"Idle":
			animation_tree.set("parameters/Locomotion/transition_request", "Idle")
	
		"Falling":
			animation_tree.set("parameters/Locomotion/transition_request", "Fall")
	
		"Running":
			animation_tree.set("parameters/Locomotion/transition_request", "Run")
		
		"Sprint":
			animation_tree.set("parameters/Locomotion/transition_request", "Sprint")
			
		"WaterIdle":
			animation_tree.set("parameters/Locomotion/transition_request", "WaterIdle")
			
		"WaterMove":
			animation_tree.set("parameters/Locomotion/transition_request", "WaterMove")
			
		"LedgeHold":
			animation_tree.set("parameters/Locomotion/transition_request", "LedgeHold")
			
		"MoveLeft":
			animation_tree.set("parameters/Locomotion/transition_request", "MoveLeft")
			
		"MoveRight":
			animation_tree.set("parameters/Locomotion/transition_request", "MoveRight")
	
	
func handle_attack_animation(weapon_type: String, combo_step: int, delta: float):
	match weapon_type:
		"Fist":
			match combo_step:
				0:
					animation_tree["parameters/PunchState/blend_amount"] = -1
					animation_tree.set("parameters/Punch/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
					
				1:
					animation_tree["parameters/PunchState/blend_amount"] = 0
					animation_tree.set("parameters/Punch/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
					
				2:
					animation_tree["parameters/PunchState/blend_amount"] = 1
					animation_tree.set("parameters/Punch/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
					
		"Sword":
			match  combo_step:
				0:
					animation_tree.set("parameters/Sword/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
	
	
	
	
	
	
