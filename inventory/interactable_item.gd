extends Node3D
class_name InteractableItem

var player: CharacterBody3D

@export var ItemHighLightMesh: MeshInstance3D

func GainFocus():
	ItemHighLightMesh.visible = true
	
func LoseFocus():
	ItemHighLightMesh.visible = false
