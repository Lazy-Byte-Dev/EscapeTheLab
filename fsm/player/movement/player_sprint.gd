extends State
class_name PlayerSprint

var SPEED: float = 6.0

func Enter():
	animator.play("animations/Sprint")
	player.is_sprinting = true
	
func Exit():
	player.is_sprinting = false
	
func Update(delta: float):
	player.stats.stamina -= 1
	player.update_stamina()
	
	if player.stamina.value <= 0:
		player.can_sprint = false
		Transitioned.emit(self, "Idle")
		
	player_direction.handle_movement_and_turning(delta)
	if next_state != "" and next_state != "Sprint":
		Transitioned.emit(self, next_state)
	
func Physics_Update(delta: float):
		player.velocity = player_direction.handle_movement_and_turning(delta) * SPEED
		player.move_and_slide()
