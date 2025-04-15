extends State
class_name PlayerCrouchWalk

@onready var standing: CollisionShape3D = $"../../../Standing"
@onready var crouching: CollisionShape3D = $"../../../Crouching"
@onready var camera_3d: Camera3D = $"../../../TwistPivot/PitchPivot/SpringArm3D/Camera3D"

var input_dir:= Vector2.ZERO
var SPEED = 5.0
var dir := Vector3.ZERO
var last_move_dir := Vector3.ZERO
var rotation_speed := 10.0

func Enter():
	print("Enter CrouchWalk")
	SPEED = 3.0
	standing.disabled = true
	crouching.disabled = false

	
func Exit():
	print("Exit CrouchWalk")
	standing.disabled = false
	crouching.disabled = true
	
func Update(delta: float):
	var camera = camera_3d.global_basis
	input_dir = Input.get_vector("left", "right", "forward", "backwards")
	var direction = (camera.x * input_dir.x + camera.z * input_dir.y)
	direction.y = 0.0
	direction = direction.normalized()
	dir = direction
	last_move_dir = -dir
	
func Physics_Update(delta: float):
	if Input.get_vector("left", "right", "forward", "backwards"):
		player.velocity.x = dir.x * SPEED
		player.velocity.z = dir.z * SPEED
		
	if !Input.get_vector("left", "right", "forward", "backwards"):
		Transitioned.emit(self, "Crouch")
		
