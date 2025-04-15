extends State
class_name EnemyWander

@export var enemy : CharacterBody3D
@export var move_speed:= 3.0
@onready var skin: Node3D = $"../../YBot/Armature"
@onready var animation_handler: NPCAnimationHandler = $"../../AnimationHandler"

var move_direction : Vector2
var wander_time: float
var timer: float = 0.0

var dir := Vector3.ZERO
var last_move_dir := Vector3.ZERO
var rotation_speed := 10.0

func randomize_wander():
	move_direction = Vector2(randi_range(-1, 1), randi_range(-1, 1)).normalized()
	dir = Vector3(move_direction.x, 0, move_direction.y)
	wander_time = randf_range(1, 3)
	
func Enter():
	timer = randf_range(5, 15)
	animation_handler.update_animation("Walking")
	randomize_wander()
	
func  Update(delta: float):
	if timer > 0:
		timer -= delta
		
	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_wander()
		
	if timer <= 0:
		Transitioned.emit(self, "Idle")
		
	if dir.length() > 0.2:
		last_move_dir = dir
	var target_angle := Vector3.BACK.signed_angle_to(last_move_dir, Vector3.UP)
	
	skin.global_rotation.y = lerp(skin.global_rotation.y, target_angle, rotation_speed * delta)

func  Physics_Update(delta: float):
	var direction = player.global_position - enemy.global_position
	
	enemy.velocity.x = move_direction.x * move_speed
	enemy.velocity.z = move_direction.y * move_speed

	if direction.length() < 10 and player.stats.health > 0:
		Transitioned.emit(self, "follow")
