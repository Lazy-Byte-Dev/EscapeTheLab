extends Resource
class_name CharacterStats

#Conditions
@export var is_dead: bool = false

# General Information
@export var name: String = ""
@export var title: String = ""
@export var rank: String = ""
@export var _class: String = ""
@export var level: int = 1
@export var experience: int = 0
@export var experience_to_next_level: int = 100
@export var exp_gained: int = 50

# Core Attributes
@export var strength: int = 10
@export var dexterity: int = 10
@export var intelligence: int = 10
@export var constitution: int = 10
@export var charisma: int = 10
@export var wisdom: int = 10

# Secondary Stats (Derived from Core Attributes)
@export var health: int = 100
@export var max_health: int = 100
@export var mana: int = 50
@export var max_mana: int = 50
@export var stamina: int = 50
@export var max_stamina: int = 50

# Combat Stats
@export var attack_power: int = 10
@export var defense: int = 5
@export var magic_power: int = 5
@export var magic_resistance: int = 5
@export var critical_chance: float = 0.05 # 5% chance
@export var critical_damage_multiplier: float = 1.5 # 150% damage

# Resources
@export var gold: int = 0
@export var inventory: Array = [] # Store items as strings or objects

# Methods
func level_up():
	level += 1
	experience_to_next_level = experience_to_next_level * 2 # Increase XP threshold by 20%
	strength += 2
	dexterity += 2
	intelligence += 2
	constitution += 2
	charisma += 1
	wisdom += 1
	max_health += constitution * 2
	max_mana += intelligence * 1.5
	max_stamina += dexterity * 2
	health = max_health
	mana = max_mana
	stamina = max_stamina
	print("Level Up! You are now level ", level)

func gain_experience(amount: int):
	experience += amount
	while experience >= experience_to_next_level:
		experience -= experience_to_next_level
		level_up()

func take_damage(amount: int, source: Node3D, victim: Node3D):
	health -= amount
	if health <= 0:
		if source == CharacterBody3D:
			source.gain_exp(victim.stats.exp_gained)
		die()

func heal(amount: int):
	health += amount
	if health > max_health:
		health = max_health

func die():
	is_dead = true

func display_stats():
	print("Name: ", name)
	print("Title: ", title)
	print("Class: ", _class)
	print("Level: ", level)
	print("Health: ", health, "/", max_health)
	print("Mana: ", mana, "/", max_mana)
	print("Stamina: ", stamina, "/", max_stamina)
	print("Strength: ", strength)
	print("Dexterity: ", dexterity)
	print("Intelligence: ", intelligence)
	print("Constitution: ", constitution)
	print("Charisma: ", charisma)
	print("Wisdom: ", wisdom)
	print("Attack Power: ", attack_power)
	print("Defense: ", defense)
	print("Gold: ", gold)
	print("Inventory: ", inventory)
