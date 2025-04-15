extends State
class_name LedgeHold

func Enter():
	player.velocity = Vector3.ZERO
	
func Exit():
	pass
	
func Update(delta: float):
	if next_state != "" and next_state != "LedgeHold" and next_state != "MoveLeft" and next_state != "MoveRight":
		Transitioned.emit(self, next_state)
	
func Physics_Update(delta: float):
	if Input.is_action_pressed("left"):
		player.velocity.x = -1
		player.move_and_slide()
		return
		
	if Input.is_action_pressed("right"):
		player.velocity.x = 1 
		player.move_and_slide()
		return
		
	if Input.is_action_pressed("forward"):
		player.velocity.y = 6
		player.move_and_slide()
		return
	
	player.velocity = Vector3.ZERO
		
	player.move_and_slide()
