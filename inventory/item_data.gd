extends Resource
class_name ItemData

enum ItemType { CONSUMABLE, WEAPON, EQUIPMENT }

@export var ItemName: String
@export var Icon: Texture2D
@export var ItemModelPrefab: PackedScene 

@export var Type: ItemType
