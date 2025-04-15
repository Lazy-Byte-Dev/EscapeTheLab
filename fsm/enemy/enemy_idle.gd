extends State
class_name EnemyIdle

@export var enemy : CharacterBody3D
@export var move_speed:= 3.0
@onready var animation_handler: NPCAnimationHandler = $"../../AnimationHandler"
@export var enemy_stats: Resource

var move_direction : Vector2
var wander_time: float
var timer: float = 0.0
	
func Enter():
	timer = randf_range(5, 15)
	animation_handler.update_animation("Idle")
	enemy.velocity = Vector3.ZERO
	
func Exit():
	timer = 0.0
	
func  Update(delta: float):
	if timer > 0:
		timer -= delta
		
	if timer <= 0:
		Transitioned.emit(self, "Wander")
		
	if enemy_stats.health <= 0:
		Transitioned.emit(self, "Death")

func  Physics_Update(delta: float):
	#if player.stats.health == 0:
		#Transitioned.emit(self, "Wander")
		
	var direction = player.global_position - enemy.global_position
	if direction.length() <= 10:
		Transitioned.emit(self, "Follow")
