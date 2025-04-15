extends State
class_name WaterIdle

# Drag and buoyancy parameters
var damping_rate: float = 1.0
var damping_threshold: float = 0.1
var buoyancy_acceleration: float = 0.1 # Matches gravity for neutral buoyancy
var max_buoyancy: float = 3.0
var vertical_buoyancy_factor: float = 1.0

# Drowning recovery parameters
var drowning_recovery_speed: float = 0.5 # Slow upward movement when drowning
var max_drowning_recovery_speed: float = 2.0

# State tracking
var damping_complete: bool = false

func Enter():
	damping_complete = false
	
func Exit():
	print("Exited Water State")
	
func Update(delta: float):
	if next_state == "SwimUp":
		Transitioned.emit(self, "WaterMove")
	
	if next_state == "SwimDown":
		Transitioned.emit(self, "WaterMove")

	if next_state != "" and next_state != "WaterIdle" and next_state != "SwinUp" and next_state != "SwimDown":
		Transitioned.emit(self, next_state)
	
func Physics_Update(delta: float):
	# Smooth swimming controls
	var swim_input = Vector3.ZERO
	# Gradual swim movement with limited acceleration
	var swim_acceleration = 0.5
	player.velocity.y = lerp(player.velocity.y, swim_input.y, swim_acceleration * delta)
	
	if not damping_complete:
		# Apply non-linear drag
		var speed = player.velocity.length()
		var drag_coefficient = damping_rate * speed
		
		# Exponential decay for more natural deceleration
		player.velocity = player.velocity.lerp(
			Vector3.ZERO, 
			1.0 - exp(-drag_coefficient * delta)
		)
		
		# Apply buoyancy
		var buoyancy_force = Vector3.UP * buoyancy_acceleration
		var vertical_velocity = player.velocity.y
		var buoyancy_adjustment = clamp(
			vertical_buoyancy_factor * abs(vertical_velocity), 
			0, 
			max_buoyancy
		)
		
		# Combine drag and buoyancy
		player.velocity += buoyancy_force * delta
		
		# Check if velocity is near zero
		if speed < damping_threshold:
			player.velocity = Vector3.ZERO
			damping_complete = true
	
	# Drowning recovery mechanism
	if player.check_drowning() and damping_complete:
		# Gradually pull player upwards when drowning
		var drowning_recovery_force = Vector3.UP * drowning_recovery_speed
		player.velocity.y = clamp(
			player.velocity.y + drowning_recovery_force.y, 
			-max_drowning_recovery_speed, 
			max_drowning_recovery_speed
		)
	
	player.move_and_slide()
