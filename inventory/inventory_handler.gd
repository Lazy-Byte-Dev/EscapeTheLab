extends Node
class_name InventoryHandler

@export var PlayerBody : CharacterBody3D

@export_flags_3d_physics var CollisionMask : int

@export var ItemSlotCount: int = 12
@export var InventoryGrid: GridContainer
@export var InventorySlotPrefab: PackedScene = preload("res://inventory/inventory_slot.tscn")

var InventorySlots: Array[InventorySlot] = []

var EquippedSlot : int = -1
var WeaponEquip: bool = false
var EquippedItemInstance: Node3D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in ItemSlotCount:
		var slot = InventorySlotPrefab.instantiate() as InventorySlot
		InventoryGrid.add_child(slot)
		slot.InventorySlotID = i
		slot.OnItemDropped.connect(ItemDroppedOnSlot.bind())
		slot.OnItemEquiped.connect(ItemEquipped.bind())
		InventorySlots.append(slot)


func PickedItem(Item: ItemData):
	var foundSlot: bool = false
	for slot in InventorySlots:
		if !slot.SlotFilled:
			slot.FillSlot(Item, false)
			foundSlot = true
			break
			
	if (!foundSlot):
		var newItem = Item.ItemModelPrefab.instantiate() as Node3D
		
		PlayerBody.get_parent().add_child(newItem)
		newItem.global_position = PlayerBody.global_position + PlayerBody.global_transform.basis.x * 2.0

func GetEquippedItem() -> ItemData:
	if WeaponEquip and EquippedSlot != -1:
		return InventorySlots[EquippedSlot].SlotData
	return null

			
func ItemEquipped(slotID : int):
	if (EquippedSlot != -1):
		UnequipItem()
	
	if (slotID != EquippedSlot && InventorySlots[slotID].SlotData != null):
		match InventorySlots[slotID].SlotData.Type:
			ItemData.ItemType.CONSUMABLE:
				# Handle consumable item logic here
				pass
			ItemData.ItemType.WEAPON:
				EquipWeapon(InventorySlots[slotID].SlotData)
				InventorySlots[slotID].FillSlot(InventorySlots[slotID].SlotData, true)
				EquippedSlot = slotID
				WeaponEquip = true
					
			ItemData.ItemType.EQUIPMENT:
				# Handle equipment item logic here
				pass
	else:
		EquippedSlot = -1
		
func UnequipItem():
	if EquippedSlot == -1 or WeaponEquip == false:
		return
		
	if EquippedItemInstance:
		# Re-enable collision layers
		if EquippedItemInstance is CollisionObject3D:
			var equipped_body = EquippedItemInstance as CollisionObject3D
			equipped_body.set_collision_layer(2)  # Re-enable collision layer (adjust as needed)
			equipped_body.set_collision_mask(1)  # Re-enable collision mask (adjust as needed)
			
	InventorySlots[EquippedSlot].FillSlot(InventorySlots[EquippedSlot].SlotData, false)
	WeaponEquip = false
	PlayerBody.equipped_weapon = "Fist"
	
	if EquippedItemInstance:
		EquippedItemInstance.queue_free()  # Removes the item from the scene
		EquippedItemInstance = null  # Clears the reference

func EquipWeapon(item: ItemData):
	if WeaponEquip == true:
		print(item.ItemName, " Is Equipped")
		return
		
	# Instantiate and attach the weapon to the player's hand
	EquippedItemInstance = item.ItemModelPrefab.instantiate() as Node3D
	EquippedItemInstance.player = PlayerBody
	PlayerBody.right_hand.add_child(EquippedItemInstance)
	EquippedItemInstance.freeze = true
	if EquippedItemInstance is CollisionObject3D:
		var equipped_body = EquippedItemInstance as CollisionObject3D
		equipped_body.set_collision_layer(0)
		equipped_body.set_collision_mask(0)
	PlayerBody.equipped_weapon = item.ItemName
	EquippedItemInstance.set_owner(PlayerBody.right_hand)
	
func ItemDroppedOnSlot(fromSlotID : int, toSlotID : int):
	if EquippedSlot != -1:
		if EquippedSlot == fromSlotID:
			EquippedSlot = toSlotID
		elif EquippedSlot == toSlotID:
			EquippedSlot = fromSlotID
	
	var toSlotItem = InventorySlots[toSlotID].SlotData
	var fromSlotItem = InventorySlots[fromSlotID].SlotData
	
	InventorySlots[toSlotID].FillSlot(fromSlotItem, EquippedSlot == toSlotID)
	InventorySlots[fromSlotID].FillSlot(toSlotItem, EquippedSlot == fromSlotID)
	
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return typeof(data) == TYPE_DICTIONARY and data["Type"] == "Item"
	
func _drop_data(at_position: Vector2, data: Variant) -> void:
	if EquippedSlot != -1 and InventorySlots[EquippedSlot].SlotData == InventorySlots[data["ID"]].SlotData:
		UnequipItem()
		
	if (EquippedSlot == data["ID"]):
		EquippedSlot = -1
	
	var newItem = InventorySlots[data["ID"]].SlotData.ItemModelPrefab.instantiate() as Node3D
	InventorySlots[data["ID"]].FillSlot(null, false)
	
	PlayerBody.get_parent().add_child(newItem)
	newItem.global_position = GetWorldMousePosition()
	
func GetWorldMousePosition() -> Vector3:
	var mousePos = get_viewport().get_mouse_position()
	var cam = get_viewport().get_camera_3d()
	var ray_start = cam.project_ray_origin(mousePos)
	var ray_end = ray_start + cam.project_ray_normal(mousePos) * cam.global_position.distance_to(PlayerBody.global_position) * 2.0
	var world3d : World3D = PlayerBody.get_world_3d()
	var space_state = world3d.direct_space_state
	
	var query = PhysicsRayQueryParameters3D.create(ray_start, ray_end, CollisionMask)
	
	var results = space_state.intersect_ray(query)
	if (results):
		return results["position"] as Vector3 + Vector3(0.0, 0.5, 0.0)
	else:
		return ray_start.lerp(ray_end, 0.5) + Vector3(0.0, 0.5, 0.0)
			
			
