extends Area3D

@export var player: CharacterBody3D

func _on_body_entered(body: Node3D) -> void:
	print(body)
	if body == player.chest:
		print("In The Water")
		player.input.is_in_water = true


func _on_body_exited(body: Node3D) -> void:
	if body == player.chest:
		player.input.is_in_water = false
