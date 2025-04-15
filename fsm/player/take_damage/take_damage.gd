extends State
class_name PlayerDamage


@export var player_stats: Resource
@export var timer: float = 0.0

func Enter():
	pass
	
func Exit():
	pass
	player.is_kicked = false
	
func Update(delta: float):
	timer += delta
	
func Physics_Update(delta: float):
	if player_stats.health <= 0:
		Transitioned.emit(self, "Death")
	
	if timer >= 1.5:
		Transitioned.emit(self, "idle")
		timer = 0.0
	
