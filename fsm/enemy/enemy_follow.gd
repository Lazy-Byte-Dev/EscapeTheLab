extends State
class_name EnemyFollow

@export var enemy : CharacterBody3D
@export var move_speed:= 6.0
@onready var skin: Node3D = $"../../YBot/Armature"
@onready var animation_handler: NPCAnimationHandler = $"../../AnimationHandler"

var dir := Vector3.ZERO
var last_move_dir := Vector3.ZERO
var rotation_speed := 15.0

func Enter():
	animation_handler.update_animation("Running")
	
func Exit():
	pass
	
func Update(delta: float):
	if dir.length() > 0.2:
		last_move_dir = dir
	var target_angle := Vector3.BACK.signed_angle_to(last_move_dir, Vector3.UP)
	
	skin.global_rotation.y = lerp(skin.global_rotation.y, target_angle, rotation_speed * delta)
	
func Physics_Update(delta: float):
	if player.stats.health == 0:
		Transitioned.emit(self, "Wander")
	
	var direction = player.global_position - enemy.global_position
	dir = direction

	if direction.length() < 10:
		enemy.velocity = direction.normalized() * move_speed
		if direction.length() < 2:
			enemy.velocity = Vector3.ZERO
			Transitioned.emit(self, "Attack")
	else:
		enemy.velocity = Vector3.ZERO
		Transitioned.emit(self, "Idle")
		
	if direction.length() > 25:
		Transitioned.emit(self, "Wander")
