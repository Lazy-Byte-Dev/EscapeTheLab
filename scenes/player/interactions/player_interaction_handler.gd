extends Area3D

signal OnItemPickedUp(item)

@export var ItemTypes: Array[ItemData] = []
@export var inventory_handler: InventoryHandler

var NearbyBodies: Array[InteractableItem]

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		PickupNearestItem()
		
func PickupNearestItem():
	var nearestItem: InteractableItem = null
	var nearestItemDistance: float = INF
	for Item in NearbyBodies:
		if Item.global_position.distance_to(global_position) < nearestItemDistance:
			nearestItemDistance - Item.global_position.distance_to(global_position)
			nearestItem = Item
			
		nearestItem.queue_free()
		NearbyBodies.remove_at(NearbyBodies.find(nearestItem))
		var itemPrefab = nearestItem.scene_file_path
		for i in ItemTypes.size():
			if ItemTypes[i].ItemModelPrefab != null and ItemTypes[i].ItemModelPrefab.resource_path == itemPrefab:
				OnItemPickedUp.emit(ItemTypes[i])
				return
				
		printerr("Item not found")

func OnObjectEnteredArea(body: Node3D):
	if (body is InteractableItem):
		body.GainFocus()
		NearbyBodies.append(body)
		
func OnObjectExitedArea(body: Node3D):
	if (body is InteractableItem and NearbyBodies.has(body)):
		body.LoseFocus()
		NearbyBodies.remove_at(NearbyBodies.find(body))
		


func _on_pick_up_pressed() -> void:
	PickupNearestItem()
