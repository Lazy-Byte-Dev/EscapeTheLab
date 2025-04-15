extends State
class_name PlayerCrouch

@onready var standing: CollisionShape3D = $"../../Standing"
@onready var crouching: CollisionShape3D = $"../../Crouching"

@export var fsm: FSM


func Enter():
	for state in fsm.states:
		print(state)
	print("New State: ", fsm.states.get("crouch/crouchwalk".to_lower()))
	if fsm.old_state != fsm.states.get("crouch/crouchwalk".to_lower()):
		print("Hello")
		
	standing.disabled = true
	crouching.disabled = false
	
func Exit():
	standing.disabled = false
	crouching.disabled = true
	
func Update(delta: float):
	player.velocity = Vector3.ZERO
	
func Physics_Update(delta: float):
	if Input.get_vector("left", "right", "forward", "backwards"):
		Transitioned.emit(self, "crouch/crouchwalk")
		
	if Input.is_action_just_pressed("crouch"):
		Transitioned.emit(self, "Idle")
