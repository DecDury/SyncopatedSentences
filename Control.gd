extends Control

func _ready() -> void:
	# add stages to pop up menu
	var menu_button = $PanelContainer/VBoxContainer/MenuButton
	menu_button.get_popup().add_item("1: LEAP")
	menu_button.get_popup().add_item("2: BOSS battle 2")
	menu_button.get_popup().add_item("3: Final Boss Battle 6")

