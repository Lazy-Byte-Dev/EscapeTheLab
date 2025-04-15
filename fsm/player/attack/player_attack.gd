extends State
class_name PlayerAttack

@export var combo_timer: float = 1.0  # Time allowed to chain combos
var current_combo_step: int = 0
var combo_time_remaining: float = 0.0
var weapon_type: String  # Default weapon type
var weapon_combo_patterns: Dictionary = {
	"Fist": ["Punch1", "Punch2", "Punch3"],
	"Sword": ["Slash1", "Slash2", "Slash3"],
	"Spear": ["Stab1", "Stab2", "Stab3"]
}
var attack_in_progress: bool = false

func Enter():
	player.is_attacking = true
	weapon_type = player.equipped_weapon
	current_combo_step = 0
	combo_time_remaining = combo_timer
	attack_in_progress = false
	execute_attack()

func Exit():
	player.is_attacking = false
	combo_time_remaining = 0.0
	current_combo_step = 0
	attack_in_progress = false
	reset_combo()

func Update(delta: float):
	if combo_time_remaining > 0:
		combo_time_remaining -= delta

	# Handle follow-up attacks or state transitions
	if !attack_in_progress and Input.is_action_just_pressed("primary attack"):
		attack_in_progress = true
		execute_attack()
		combo_time_remaining = 1.0

	if next_state != "" and next_state != "Attack" and combo_time_remaining <= 0:
		Transitioned.emit(self, next_state)

func execute_attack():
	if weapon_type in weapon_combo_patterns:
		var attack_sequence = weapon_combo_patterns[weapon_type]
		if current_combo_step < attack_sequence.size():
			animator.handle_attack_animation(weapon_type, current_combo_step, 0.5)
			current_combo_step += 1
			combo_time_remaining = combo_timer  # Reset combo timer for the next attack
			# Simulate attack duration; this can be tied to animations or timers
			await(get_tree().create_timer(0.5))
			attack_in_progress = false
		else:
			reset_combo()  # Reset combo after completing the sequence
	else:
		print("No attack pattern defined for weapon: %s" % weapon_type)

func reset_combo():
	current_combo_step = 0
	attack_in_progress = false
