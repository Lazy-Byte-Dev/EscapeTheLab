extends State
class_name PlayerRun

@export var SPEED: float = 3.0

func Enter():
	animator.play("animations/Run")
	
func Exit():
	pass
		
func Update(delta: float):
	player_direction.handle_movement_and_turning(delta)
	if next_state != "" and next_state != "Running":
		Transitioned.emit(self, next_state)
	
func Physics_Update(delta: float):
	player.velocity = player_direction.handle_movement_and_turning(delta) * SPEED
	player.move_and_slide()
	
