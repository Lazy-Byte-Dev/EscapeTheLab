extends State
class_name WaterMove

var swim_speed: float = 1.5
var dash_speed: float = 3

func Enter():
	pass
	
func Exit():
	pass
	
func Update(delta: float):
	if next_state != "" and next_state != "WaterMove" and next_state != "SwinUp"  and next_state != "SwimDown":
		Transitioned.emit(self, next_state)
	
func Physics_Update(delta: float):
	if next_state == "SwimUp":
		player.velocity.y = 1
		
	elif next_state == "SwimDown":
		player.velocity.y = -1

	else:
		player.velocity = player_direction.handle_movement_and_turning(delta) * swim_speed
		
	player.move_and_slide()
