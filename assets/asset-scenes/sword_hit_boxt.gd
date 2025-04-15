extends Area3D

@onready var sword: InteractableItem = $".."

func _on_body_entered(body: Node3D) -> void:
	if body.has_method("hurt") and sword.player:
		if sword.player.is_attacking:
			var damage = sword.player.calculate_damage()
			body.hurt(damage, sword.player, body)


func _on_body_exited(body: Node3D) -> void:
	pass
