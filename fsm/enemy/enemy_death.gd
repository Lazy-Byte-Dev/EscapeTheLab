extends State
class_name EnemyDeath
@onready var animation_handler: NPCAnimationHandler = $"../../AnimationHandler"
@onready var system_shield: Area3D = $"../../SystemShield"
@export var enemy: CharacterBody3D

func Enter():
	animation_handler.update_animation("Death")
	system_shield.collision_mask = 0
	
func Exit():
	pass
	
func Update(delta: float):
	pass
	
func Physics_Update(delta: float):
	pass
