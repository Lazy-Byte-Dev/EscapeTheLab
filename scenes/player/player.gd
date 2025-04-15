extends CharacterBody3D
class_name Player

@onready var twist_pivot: Node3D = $TwistPivot
@onready var pitch_pivot: Node3D = $TwistPivot/PitchPivot
@onready var camera_3d: Camera3D = $TwistPivot/PitchPivot/SpringArm3D/Camera3D
@onready var right_hand: BoneAttachment3D = $EquippesItems/Arm/RightHand
@onready var visuals: PlayerDirection = $Visuals
@onready var camera: RayCast3D = $TwistPivot/PitchPivot/SpringArm3D/Camera3D/Camera
@onready var eyes_ray: RayCast3D = $Eyes
@onready var head_ray: RayCast3D = $Head

@onready var health_bar: ProgressBar = $UI/Panel/HealthBar
@onready var stamina: ProgressBar = $UI/Panel/Stamina

@export var input: Node
@export var stats: Resource

var twistinput = 0.0
var pitchinput = 0.0
var sensitivity = 0.005

var is_kicked: bool = false
var is_attacking: bool = false
var equipped_weapon: String = "Fist"
var is_blocking: bool = false
var is_sprinting: bool = false

var can_sprint: bool = true

func _ready() -> void:
	health_bar.max_value = stats.max_health
	health_bar.value = stats.health
	
	stamina.max_value = stats.max_stamina
	stamina.value = stats.stamina
	
func _process(delta: float) -> void:
	if stats.stamina < stats.max_stamina and !is_sprinting:
		stats.stamina += 1
		update_stamina()
		if stats.stamina >= stats.max_stamina / 2:
			can_sprint = true

func _physics_process(delta: float) -> void:
	twist_pivot.rotate_y(twistinput)
	pitch_pivot.rotate_x(pitchinput)
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, deg_to_rad(-40), deg_to_rad(30))
	
	twistinput = 0.0
	pitchinput = 0.0

	
func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		twistinput -= event.relative.x * sensitivity
		pitchinput -= event.relative.y * sensitivity
		

func hurt(damage: int, source: Node3D, victim: Node3D):
	stats.take_damage(damage, source, victim)
	update_health()
	
func update_health():
	health_bar.value = stats.health
	
func update_stamina():
	stamina.value = stats.stamina
	
func calculate_damage() -> int:
	if is_blocking:
		return 0
	if stats == null:
		print(stats)
		return 0
		
	return stats.attack_power
	
func gain_exp(exp: int):
	stats.gain_experience(exp)

func check_head() -> bool:
	if head_ray.is_colliding():
		return true
	return false
	
func check_eyes() -> bool:
	if eyes_ray.is_colliding():
		return true
	return false
