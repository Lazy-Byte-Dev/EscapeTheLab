extends State
class_name PlayerFalling

var _delta: float

func Enter():
	animator.play("animations/Falling")
	
func Exit():
	pass
	
func Update(delta: float):
	_delta = delta
	if next_state != "" and next_state != "Falling":
		Transitioned.emit(self, next_state)
	
func Physics_Update(delta: float):
	if !player.is_on_floor() or player.velocity.y != 0: 
		player.velocity += player.get_gravity() * delta
	player.move_and_slide()
		
		
