extends Node
class_name NPCAnimationHandler

@onready var enemy_anim: AnimationTree = $"../EnemyAnim"


func update_animation(state: String):
	match state:
		"Idle":
			enemy_anim.set("parameters/Locomotion/transition_request", "Idle")
			
		"Walking":
			enemy_anim.set("parameters/Locomotion/transition_request", "Walk")
	
		"Falling":
			enemy_anim.set("parameters/Locomotion/transition_request", "Fall")
	
		"Running":
			enemy_anim.set("parameters/Locomotion/transition_request", "Run")
		
		"Sprint":
			enemy_anim.set("parameters/Locomotion/transition_request", "Sprint")
			
		"Punch":
			enemy_anim["parameters/AttackState/blend_amount"] = -1
			enemy_anim.set("parameters/Attack/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
			
		"Death":
			enemy_anim["parameters/Death/blend_amount"] = 1
