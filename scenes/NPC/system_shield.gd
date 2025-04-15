extends Area3D

@onready var outline: MeshInstance3D = $Outline

@export var npc: CharacterBody3D
@export var force_applied: Vector3 = Vector3.ZERO
@export var force_strength: float = 10.0
@export var damping: float = 0.5

func _on_body_entered(body: Node3D) -> void:
	outline.show()
	if body and body.global_position and npc:
		#var body_position = body.global_transform.origin
		#var direction = (npc.global_transform.origin - body_position).normalized()
		#force_applied = direction * force_strength
		
		# Calculate direction from NPC to player
		var npc_position = npc.global_transform.origin
		var body_position = body.global_transform.origin
		var direction = (npc_position - body_position).normalized()
		
		# Scale the force by the strength and optionally body velocity
		force_applied = direction * force_strength
		
		if body == RigidBody3D:
			var body_velocity = body.linear_velocity
			force_applied += body_velocity * 0.01
			outline.show()
			
		if body == CharacterBody3D:
			var body_velocity = body.velocity
			force_applied += body_velocity * 0.01
			outline.show()

		
func _physics_process(delta: float) -> void:
	if force_applied.length() > 0.01 and npc:
		npc.velocity = force_applied
		npc.move_and_slide()
		force_applied *= damping


func _on_body_exited(body: Node3D) -> void:
	outline.hide()
