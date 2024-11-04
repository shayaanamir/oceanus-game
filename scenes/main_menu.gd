extends Panel


@onready var main_menu: Panel = $"."
@onready var character_select: Panel = $"../characterSelect"

@onready var pirate_container: Button = $"../characterSelect/pirateContainer"
@onready var navy_container: Button = $"../characterSelect/navyContainer"
@onready var sailor_container: Button = $"../characterSelect/sailorContainer"
@onready var seal_container: Button = $"../characterSelect/sealContainer"

@onready var pirate: CharacterBody2D = $Pirate
@onready var navy_captain: CharacterBody2D = $NavyCaptain

func _on_start_button_pressed() -> void:
	main_menu.visible = false
	character_select.visible = true
	pass # Replace with function body.


func _on_pirate_container_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	
	
