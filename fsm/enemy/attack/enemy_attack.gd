extends State
class_name EnemyAttack

@onready var skin: Node3D = $"../../YBot/Armature"
@onready var animation_handler: NPCAnimationHandler = $"../../AnimationHandler"
@export var enemy_stats: Resource
@export var enemy: CharacterBody3D
@onready var dragonslayer_low: RigidBody3D = $"../../RightHand/Dragonslayer_low"

var timer: float = 0.0
var duration: float = 0
var rotation_speed : float = 10.0
var look_at: Vector3

func Enter():
	dragonslayer_low.freeze = false
	duration = 1.2
	look_at.x = player.global_position.x
	look_at.z = player.global_position.z
	
	animation_handler.update_animation("Punch")
	
func Exit():
	dragonslayer_low.freeze = true
	duration = 0.0
	
func Update(delta: float):
	duration -= delta
	
	if enemy_stats.health <= 0:
		Transitioned.emit(self, "Death")
	
func Physics_Update(delta: float):
	#if player.stats.health == 0:
		#Transitioned.emit(self, "wander")
		
	if duration <= 0:
		Transitioned.emit(self, "Idle")
