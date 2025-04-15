extends CharacterBody3D
class_name Ememy

@onready var skin: Node3D = $YBot/Armature

@export var health_bar: ProgressBar

@export var stats: Resource

var timer: float = 0.0

func _ready() -> void:
	if health_bar:
		health_bar.value = stats.health
		health_bar.max_value = stats.max_health
	
func _physics_process(delta: float) -> void:
	if timer > 0:
		timer -= delta
	
	if !is_on_floor():
		velocity += get_gravity() * delta
		
	move_and_slide()
	
func _process(delta: float) -> void:
	if timer <= 0.0:
		if health_bar:
			health_bar.hide()
			timer = 0.0
		

func hurt(damage: int, source: Node3D, victim: Node3D):
	stats.take_damage(damage, source, victim)
	update_health()
	
func update_health():
	if health_bar:
		health_bar.value = stats.health
		health_bar.show()
		timer = 5

func calculate_damage() -> int:
	return stats.attack_power
	
func gain_exp(exp: int):
	stats.gain_experience(exp)
